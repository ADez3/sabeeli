import CoreLocation
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let compass = CompassStreamHandler()

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
    }
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
