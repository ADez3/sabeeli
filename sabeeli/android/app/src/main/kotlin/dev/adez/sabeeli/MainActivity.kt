package dev.adez.sabeeli

import android.content.ActivityNotFoundException
import android.content.ClipData
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // The activity context is needed (not the application one) so the compass can
        // read the current display rotation.
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "dev.adez.sabeeli/compass")
            .setStreamHandler(CompassStreamHandler(this))
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "dev.adez.sabeeli/tilt")
            .setStreamHandler(TiltStreamHandler(this))
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "dev.adez.sabeeli/shake")
            .setStreamHandler(ShakeStreamHandler(this))
        // A problem report: the user's own mail app, the screenshot attached.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "dev.adez.sabeeli/report")
            .setMethodCallHandler { call, result ->
                if (call.method != "email") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val to = call.argument<String>("to") ?: ""
                val attachment = call.argument<String>("path")?.let {
                    ReportFileProvider.uriFor(packageName, java.io.File(it))
                }
                val base = Intent(Intent.ACTION_SEND).apply {
                    type = "image/png"
                    putExtra(Intent.EXTRA_EMAIL, arrayOf(to))
                    putExtra(Intent.EXTRA_SUBJECT, call.argument<String>("subject"))
                    putExtra(Intent.EXTRA_TEXT, call.argument<String>("body"))
                    if (attachment != null) {
                        putExtra(Intent.EXTRA_STREAM, attachment)
                        // The grant travels with the clip, through a chooser too.
                        clipData = ClipData.newRawUri("", attachment)
                        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                    }
                }
                // Mail apps only: those that answer mailto:, each sent the full
                // message with its attachment.
                val mailApps = packageManager
                    .queryIntentActivities(Intent(Intent.ACTION_SENDTO, Uri.parse("mailto:")), 0)
                    .map { it.activityInfo.packageName }
                    .distinct()
                if (mailApps.isEmpty()) {
                    result.success(false)
                    return@setMethodCallHandler
                }
                val intents = mailApps.map { Intent(base).setPackage(it) }
                val launch = if (intents.size == 1) {
                    intents.first()
                } else {
                    Intent.createChooser(intents.first(), null)
                        .putExtra(Intent.EXTRA_INITIAL_INTENTS, intents.drop(1).toTypedArray())
                }
                try {
                    startActivity(launch)
                    result.success(true)
                } catch (e: ActivityNotFoundException) {
                    result.success(false)
                }
            }
        // Opens a web page (the privacy policy) in the user's browser.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "dev.adez.sabeeli/url")
            .setMethodCallHandler { call, result ->
                val url = call.arguments as? String
                if (call.method != "open" || url == null) {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                try {
                    startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
                    result.success(true)
                } catch (e: ActivityNotFoundException) {
                    result.success(false)
                }
            }
        // The app hands the home-screen widget its coming prayers, localized.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "dev.adez.sabeeli/widget")
            .setMethodCallHandler { call, result ->
                if (call.method == "update") {
                    PrayerWidgetProvider.save(
                        applicationContext,
                        call.argument<String>("entries") ?: "[]",
                        call.argument<String>("caption") ?: "",
                        call.argument<String>("empty") ?: "",
                    )
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }
}
