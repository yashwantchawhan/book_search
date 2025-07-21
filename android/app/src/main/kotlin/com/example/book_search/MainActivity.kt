package com.example.book_search

import android.os.BatteryManager
import android.os.Build
import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.hardware.camera2.CameraManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.book_search/device_info"
    private lateinit var sensorManager: SensorManager
    private var gyroscopeSensor: Sensor? = null
    private var gyroData: Map<String, Float> = mapOf("x" to 0f, "y" to 0f, "z" to 0f)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        gyroscopeSensor = sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getBatteryLevel" -> {
                    val batteryLevel = getBatteryLevel()
                    if (batteryLevel != -1) {
                        result.success(batteryLevel)
                    } else {
                        result.error("UNAVAILABLE", "Battery level not available.", null)
                    }
                }
                "getDeviceName" -> {
                    result.success(Build.MODEL ?: "Unknown Device")
                }
                "getOSVersion" -> {
                    result.success(Build.VERSION.RELEASE ?: "Unknown Version")
                }
                "toggleFlashlight" -> {
                    val on = call.argument<Boolean>("on") ?: false
                    toggleFlashlight(on)
                    result.success(null)
                }
                "getGyroscopeData" -> {
                    startGyroscopeListener {
                        result.success(mapOf(
                            "x" to it["x"],
                            "y" to it["y"],
                            "z" to it["z"]
                        ))
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getBatteryLevel(): Int {
        return try {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } catch (e: Exception) {
            -1
        }
    }

    private fun toggleFlashlight(on: Boolean) {
        try {
            val cameraManager = getSystemService(Context.CAMERA_SERVICE) as CameraManager
            val cameraId = cameraManager.cameraIdList[0]
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                cameraManager.setTorchMode(cameraId, on)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun startGyroscopeListener(onDataReady: (Map<String, Float>) -> Unit) {
        val listener = object : SensorEventListener {
            override fun onSensorChanged(event: SensorEvent) {
                gyroData = mapOf(
                    "x" to event.values[0],
                    "y" to event.values[1],
                    "z" to event.values[2]
                )
                onDataReady(gyroData)

                // stop after one reading
                sensorManager.unregisterListener(this)
            }

            override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
                // Do nothing
            }
        }

        gyroscopeSensor?.let {
            sensorManager.registerListener(listener, it, SensorManager.SENSOR_DELAY_NORMAL)
        } ?: onDataReady(mapOf("x" to 0f, "y" to 0f, "z" to 0f))
    }
}
