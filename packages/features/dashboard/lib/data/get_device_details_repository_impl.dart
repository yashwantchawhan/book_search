import 'package:dashboard/domain/device_details_model.dart';
import 'package:dashboard/domain/get_device_details_repository.dart';
import 'package:device_information/device_information.dart';

class GetDeviceDetailsRepositoryImpl extends GetDeviceDetailsRepository {
 final PlatformService platformService;
  GetDeviceDetailsRepositoryImpl({required this.platformService});

  @override
  Future<DeviceDetailsModel> getDeviceInformation() async {
    final batteryLevel = await platformService.getBatteryLevel();
    final deviceName = await platformService.getDeviceName();
    final osName = await platformService.getOSVersion();

    return DeviceDetailsModel(
        batteryLevel: batteryLevel, deviceName: deviceName, osName: osName);
  }
}
