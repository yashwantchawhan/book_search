import 'package:flutter/services.dart';

class PlatformChannels {
  static const MethodChannel _channel = MethodChannel('device_info_channel');

  static Future<int> getBatteryLevel() async {
    final int batteryLevel = await _channel.invokeMethod('getBatteryLevel');
    return batteryLevel;
  }

  static Future<String> getDeviceName() async {
    final String deviceName = await _channel.invokeMethod('getDeviceName');
    return deviceName;
  }

  static Future<String> getOSVersion() async {
    final String osVersion = await _channel.invokeMethod('getOSVersion');
    return osVersion;
  }

  static Future<void> toggleFlashlight(bool on) async {
    await _channel.invokeMethod('toggleFlashlight', {'on': on});
  }

  static Future<Map<String, dynamic>> getGyroscopeData() async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('getGyroscopeData');
    return Map<String, dynamic>.from(result);
  }
}
