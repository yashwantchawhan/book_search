package com.example.book_search

import android.os.BatteryManager
import android.os.Build
import android.content.Context
import android.hardware.camera2.CameraManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "device_info_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

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
                    // Here you’d implement actual sensor reading if you want.
                    result.success(mapOf("x" to 0, "y" to 0, "z" to 0))
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
            cameraManager.setTorchMode(cameraId, on)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
