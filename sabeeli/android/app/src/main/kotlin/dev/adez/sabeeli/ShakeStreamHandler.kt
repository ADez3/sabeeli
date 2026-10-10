package dev.adez.sabeeli

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel
import kotlin.math.sqrt

/**
 * Emits an event when the phone is shaken: two jolts above [THRESHOLD] g
 * within [WINDOW_MS]. Listened to only while the app is in the foreground, at
 * the accelerometer's low "UI" rate.
 */
class ShakeStreamHandler(context: Context) : EventChannel.StreamHandler, SensorEventListener {
    private val sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    private var sink: EventChannel.EventSink? = null
    private var firstJolt = 0L
    private var lastShake = 0L

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        val sensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        if (sensor == null) {
            events.error("unavailable", "No accelerometer", null)
            return
        }
        sink = events
        sensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_UI)
    }

    override fun onCancel(arguments: Any?) {
        sensorManager.unregisterListener(this)
        sink = null
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) = Unit

    override fun onSensorChanged(event: SensorEvent) {
        val (x, y, z) = Triple(event.values[0], event.values[1], event.values[2])
        val g = sqrt(x * x + y * y + z * z) / SensorManager.GRAVITY_EARTH
        if (g < THRESHOLD) return
        val now = System.currentTimeMillis()
        if (now - lastShake < COOLDOWN_MS) return
        if (firstJolt == 0L || now - firstJolt > WINDOW_MS) {
            firstJolt = now
            return
        }
        firstJolt = 0L
        lastShake = now
        sink?.success(null)
    }

    private companion object {
        const val THRESHOLD = 2.4f
        const val WINDOW_MS = 700L
        const val COOLDOWN_MS = 2500L
    }
}
