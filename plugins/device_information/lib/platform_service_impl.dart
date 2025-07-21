import 'package:device_information/platform_channels.dart';
import 'package:device_information/platform_service.dart';

class PlatformServiceImpl implements PlatformService {
  @override
  Future<int> getBatteryLevel() => PlatformChannels.getBatteryLevel();

  @override
  Future<String> getDeviceName() => PlatformChannels.getDeviceName();

  @override
  Future<String> getOSVersion() => PlatformChannels.getOSVersion();

  @override
  Future<Map<String, dynamic>> getGyroscopeData() =>
      PlatformChannels.getGyroscopeData();
}
