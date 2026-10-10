import CoreLocation
import CoreMotion
import Flutter
import MessageUI
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let compass = CompassStreamHandler()
  private let tilt = TiltStreamHandler()
  private let shake = ShakeStreamHandler()
  private let report = ReportMailer()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "SabeeliCompass") {
      FlutterEventChannel(name: "dev.adez.sabeeli/compass", binaryMessenger: registrar.messenger())
        .setStreamHandler(compass)
      FlutterEventChannel(name: "dev.adez.sabeeli/tilt", binaryMessenger: registrar.messenger())
        .setStreamHandler(tilt)
      FlutterEventChannel(name: "dev.adez.sabeeli/shake", binaryMessenger: registrar.messenger())
        .setStreamHandler(shake)
      FlutterMethodChannel(name: "dev.adez.sabeeli/url", binaryMessenger: registrar.messenger())
        .setMethodCallHandler { call, result in
          guard call.method == "open", let s = call.arguments as? String, let url = URL(string: s) else {
            result(FlutterMethodNotImplemented)
            return
          }
          UIApplication.shared.open(url)
          result(true)
        }
      FlutterMethodChannel(name: "dev.adez.sabeeli/report", binaryMessenger: registrar.messenger())
        .setMethodCallHandler { [report] call, result in
          guard call.method == "email", let args = call.arguments as? [String: Any] else {
            result(FlutterMethodNotImplemented)
            return
          }
          result(report.send(args))
        }
    }
  }
}

/// Streams how the phone is tilted, for the parallax of the home sky. Same contract
/// as Android's TiltStreamHandler: `[x, y]` gravity in units of g, upright ≈ [0, 1].
final class TiltStreamHandler: NSObject, FlutterStreamHandler {
  private let motion = CMMotionManager()

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    guard motion.isDeviceMotionAvailable else {
      return FlutterError(code: "unavailable", message: "No motion sensor", details: nil)
    }
    // Parallax needs no more than 20 readings a second.
    motion.deviceMotionUpdateInterval = 1.0 / 20.0
    motion.startDeviceMotionUpdates(to: .main) { data, _ in
      guard let g = data?.gravity else { return }
      // Core Motion's y axis points the other way from Android's.
      events([g.x, -g.y])
    }
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    motion.stopDeviceMotionUpdates()
    return nil
  }
}

/// Streams the device heading to Dart for the Qibla screen.
///
/// Same contract as the Android CompassStreamHandler: `heading` (degrees from north),
/// `trueNorth` and `accuracy` (0 = unreliable … 3 = high). Core Location already
/// corrects for declination once it has a position, so the listen arguments are unused.
final class CompassStreamHandler: NSObject, FlutterStreamHandler, CLLocationManagerDelegate {
  private let manager = CLLocationManager()
  private var sink: FlutterEventSink?

  override init() {
    super.init()
    manager.delegate = self
    manager.headingFilter = 1
  }

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    guard CLLocationManager.headingAvailable() else {
      return FlutterError(code: "unavailable", message: "This device has no compass", details: nil)
    }
    sink = events
    manager.startUpdatingHeading()
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    manager.stopUpdatingHeading()
    sink = nil
    return nil
  }

  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    let hasTrue = newHeading.trueHeading >= 0
    let accuracy: Int
    switch newHeading.headingAccuracy {
    case ..<0: accuracy = 0
    case ..<15: accuracy = 3
    case ..<30: accuracy = 2
    default: accuracy = 1
    }
    sink?([
      "heading": hasTrue ? newHeading.trueHeading : newHeading.magneticHeading,
      "trueNorth": hasTrue,
      "accuracy": accuracy,
    ])
  }

  func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
    true
  }
}

/// Emits an event when the phone is shaken: two jolts above 2.4 g within
/// 0.7 s. Same contract as Android's ShakeStreamHandler; listened to only while
/// the app is in the foreground.
final class ShakeStreamHandler: NSObject, FlutterStreamHandler {
  private let motion = CMMotionManager()
  private var firstJolt: TimeInterval = 0
  private var lastShake: TimeInterval = 0

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    guard motion.isAccelerometerAvailable else {
      return FlutterError(code: "unavailable", message: "No accelerometer", details: nil)
    }
    motion.accelerometerUpdateInterval = 1.0 / 20.0
    motion.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
      guard let self = self, let a = data?.acceleration else { return }
      let g = (a.x * a.x + a.y * a.y + a.z * a.z).squareRoot()
      guard g > 2.4 else { return }
      let now = Date().timeIntervalSince1970
      if now - self.lastShake < 2.5 { return }
      if self.firstJolt == 0 || now - self.firstJolt > 0.7 {
        self.firstJolt = now
        return
      }
      self.firstJolt = 0
      self.lastShake = now
      events(nil)
    }
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    motion.stopAccelerometerUpdates()
    return nil
  }
}

/// A problem report in the user's own mail: the composer with the screenshot
/// attached, or, without a mail account, a plain mailto link.
final class ReportMailer: NSObject, MFMailComposeViewControllerDelegate {
  func send(_ args: [String: Any]) -> Bool {
    let to = args["to"] as? String ?? ""
    let subject = args["subject"] as? String ?? ""
    let body = args["body"] as? String ?? ""
    let root = UIApplication.shared.connectedScenes
      .compactMap { ($0 as? UIWindowScene)?.keyWindow?.rootViewController }
      .first
    if MFMailComposeViewController.canSendMail(), let root = root {
      let mail = MFMailComposeViewController()
      mail.mailComposeDelegate = self
      mail.setToRecipients([to])
      mail.setSubject(subject)
      mail.setMessageBody(body, isHTML: false)
      if let path = args["path"] as? String,
         let data = FileManager.default.contents(atPath: path) {
        mail.addAttachmentData(data, mimeType: "image/png", fileName: "screenshot.png")
      }
      root.present(mail, animated: true)
      return true
    }
    var parts = URLComponents()
    parts.scheme = "mailto"
    parts.path = to
    parts.queryItems = [
      URLQueryItem(name: "subject", value: subject),
      URLQueryItem(name: "body", value: body),
    ]
    guard let url = parts.url else { return false }
    UIApplication.shared.open(url)
    return true
  }

  func mailComposeController(
    _ controller: MFMailComposeViewController,
    didFinishWith result: MFMailComposeResult,
    error: Error?
  ) {
    controller.dismiss(animated: true)
  }
}
