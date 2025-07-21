import 'package:dashboard/domain/gyro_scope_model.dart';

abstract class GetSensorInformationRepository {
   Future<GyroScopeModel> getGyroScopeInformation();
}