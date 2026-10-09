package dev.adez.sabeeli

import android.content.Context
import android.hardware.GeomagneticField
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Build
import android.view.Surface
import android.view.WindowManager
import io.flutter.plugin.common.EventChannel

/**
 * Streams the device heading to Dart for the Qibla screen.
 *
 * Written in-house instead of taking a compass package: it is one sensor, and owning
 * it means the declination and screen-rotation handling below are ours to fix.
 *
 * Each event is a map: `heading` in degrees clockwise from north (true north when the
 * listener passed a position, magnetic otherwise), `trueNorth` and `accuracy`
 * (0 = unreliable … 3 = high), so the UI can ask for a figure-eight calibration.
 */
class CompassStreamHandler(private val context: Context) :
    EventChannel.StreamHandler, SensorEventListener {

    private val sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    private var sink: EventChannel.EventSink? = null
    private var declination = 0f
    private var trueNorth = false
    private var accuracy = SensorManager.SENSOR_STATUS_UNRELIABLE

    private val rotation = FloatArray(9)
    private val remapped = FloatArray(9)
    private val orientation = FloatArray(3)

    // Smoothed on the unit circle so the needle does not jump across 359° → 0°.
    private var smoothSin = 0.0
    private var smoothCos = 1.0
    private var hasReading = false

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        val sensor = sensorManager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR)
        if (sensor == null) {
            events.error("unavailable", "This device has no rotation-vector sensor", null)
            return
        }
        sink = events
        hasReading = false
        (arguments as? Map<*, *>)?.let { args ->
            val lat = (args["latitude"] as? Number)?.toFloat()
            val lng = (args["longitude"] as? Number)?.toFloat()
            if (lat != null && lng != null) {
                declination = GeomagneticField(lat, lng, 0f, System.currentTimeMillis()).declination
                trueNorth = true
            }
        }
        sensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_GAME)
    }

    override fun onCancel(arguments: Any?) {
        sensorManager.unregisterListener(this)
        sink = null
        trueNorth = false
        declination = 0f
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        this.accuracy = accuracy
    }

    override fun onSensorChanged(event: SensorEvent) {
        val events = sink ?: return
        SensorManager.getRotationMatrixFromVector(rotation, event.values)

        // The rotation matrix is relative to the device's natural orientation, so it
        // has to be remapped when the screen is rotated or the heading is 90° off.
        val (axisX, axisY) = when (displayRotation()) {
            Surface.ROTATION_90 -> SensorManager.AXIS_Y to SensorManager.AXIS_MINUS_X
            Surface.ROTATION_180 -> SensorManager.AXIS_MINUS_X to SensorManager.AXIS_MINUS_Y
            Surface.ROTATION_270 -> SensorManager.AXIS_MINUS_Y to SensorManager.AXIS_X
            else -> SensorManager.AXIS_X to SensorManager.AXIS_Y
        }
        SensorManager.remapCoordinateSystem(rotation, axisX, axisY, remapped)
        SensorManager.getOrientation(remapped, orientation)

        val azimuth = Math.toDegrees(orientation[0].toDouble()) + declination
        val rad = Math.toRadians(azimuth)
        if (hasReading) {
            smoothSin += SMOOTHING * (Math.sin(rad) - smoothSin)
            smoothCos += SMOOTHING * (Math.cos(rad) - smoothCos)
        } else {
            smoothSin = Math.sin(rad)
            smoothCos = Math.cos(rad)
            hasReading = true
        }
        val heading = (Math.toDegrees(Math.atan2(smoothSin, smoothCos)) + 360.0) % 360.0

        events.success(
            mapOf(
                "heading" to heading,
                "trueNorth" to trueNorth,
                "accuracy" to accuracy,
            )
        )
    }

    @Suppress("DEPRECATION")
    private fun displayRotation(): Int =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            context.display?.rotation ?: Surface.ROTATION_0
        } else {
            (context.getSystemService(Context.WINDOW_SERVICE) as WindowManager).defaultDisplay.rotation
        }

    private companion object {
        /** Low-pass weight per sample: steady enough to read, quick enough to follow a turn. */
        const val SMOOTHING = 0.15
    }
}
