import 'package:dashboard/domain/device_details_model.dart';

abstract class GetDeviceDetailsRepository {
  Future<DeviceDetailsModel> getDeviceInformation();
}