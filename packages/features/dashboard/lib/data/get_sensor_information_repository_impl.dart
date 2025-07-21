import 'package:dashboard/domain/get_sensor_information_repository.dart';
import 'package:dashboard/domain/gyro_scope_model.dart';
import 'package:device_information/device_information.dart';

class GetSensorInformationRepositoryImpl
    extends GetSensorInformationRepository {
  final PlatformService platformService;

  GetSensorInformationRepositoryImpl({required this.platformService});
  @override
  Future<GyroScopeModel> getGyroScopeInformation() async {
    final data = await platformService.getGyroscopeData();
    final gyroX = data['x'].toStringAsFixed(2);
    final gyroY = data['y'].toStringAsFixed(2);
    final gyroZ = data['z'].toStringAsFixed(2);
    return GyroScopeModel(gyroX: gyroX, gyroY: gyroY, gyroZ: gyroZ);
  }
}
