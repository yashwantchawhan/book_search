import 'package:dashboard/domain/gyro_scope_model.dart';

abstract class SensorState {}

class SensorLoadingState extends SensorState {}

class SensorLoadedState extends SensorState {
  final GyroScopeModel gyroScopeModel;

  SensorLoadedState({required this.gyroScopeModel});
}

class SensorErrorState extends SensorState {
  final String errorMessage;

  SensorErrorState({required this.errorMessage});
}

class FlashLightLoadedState extends SensorState {
  final bool newValue;

  FlashLightLoadedState({required this.newValue});
}

class FlashLightErrorState extends SensorState {
  final String errorMessage;

  FlashLightErrorState({required this.errorMessage});
}