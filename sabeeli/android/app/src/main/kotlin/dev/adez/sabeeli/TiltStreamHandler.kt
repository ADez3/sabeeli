package dev.adez.sabeeli

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel

/**
 * Streams how the phone is tilted, for the parallax of the home sky.
 *
 * Each event is `[x, y]`: the gravity vector across and along the screen, divided
 * by g so a phone held upright reads about [0, 1]. Listened to only while the home
 * screen is visible.
 */
class TiltStreamHandler(context: Context) : EventChannel.StreamHandler, SensorEventListener {
    private val sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    private var sink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        val sensor = sensorManager.getDefaultSensor(Sensor.TYPE_GRAVITY)
            ?: sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        if (sensor == null) {
            events.error("unavailable", "No gravity sensor", null)
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
        val g = SensorManager.GRAVITY_EARTH
        sink?.success(listOf(event.values[0] / g, event.values[1] / g))
    }
}
