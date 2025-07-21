import 'package:dashboard/di/get_sensor_information_repository.dart';
import 'package:dashboard/domain/gyro_scope_model.dart';
import 'package:device_information/platform_channels.dart';

class GetSensorInformationRepositoryImpl
    extends GetSensorInformationRepository {
  @override
  Future<GyroScopeModel> getGyroScopeInformation() async {
    final data = await PlatformChannels.getGyroscopeData();
    final gyroX = data['x'].toStringAsFixed(2);
    final gyroY = data['y'].toStringAsFixed(2);
    final gyroZ = data['z'].toStringAsFixed(2);
    return GyroScopeModel(gyroX: gyroX, gyroY: gyroY, gyroZ: gyroZ);
  }
}
