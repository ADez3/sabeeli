package dev.adez.sabeeli

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // The activity context is needed (not the application one) so the compass can
        // read the current display rotation.
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "dev.adez.sabeeli/compass")
            .setStreamHandler(CompassStreamHandler(this))
    }
}
