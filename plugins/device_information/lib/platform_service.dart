abstract class PlatformService {
  Future<int> getBatteryLevel();
  Future<String> getDeviceName();
  Future<String> getOSVersion();
  Future<Map<String, dynamic>> getGyroscopeData();
}