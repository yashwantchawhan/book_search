import 'package:dashboard/domain/device_details_model.dart';
import 'package:dashboard/domain/get_device_details_repository.dart';
import 'package:device_information/platform_channels.dart';

class GetDeviceDetailsRepositoryImpl extends GetDeviceDetailsRepository {
  @override
  Future<DeviceDetailsModel> getDeviceInformation() async {
    final batteryLevel = await PlatformChannels.getBatteryLevel();
    final deviceName = await PlatformChannels.getDeviceName();
    final osName = await PlatformChannels.getOSVersion();

    return DeviceDetailsModel(
        batteryLevel: batteryLevel, deviceName: deviceName, osName: osName);
  }
}
