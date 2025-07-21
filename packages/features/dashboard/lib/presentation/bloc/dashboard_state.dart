import 'package:dashboard/domain/device_details_model.dart';

abstract class DashboardState {}

class DashboardLoadingState extends DashboardState {}

class DashboardLoadedState extends DashboardState {
  final DeviceDetailsModel deviceDetailsModel;
  DashboardLoadedState({required this.deviceDetailsModel});
}

class DashboardErrorState extends DashboardState {
  final String errorMessage;
  DashboardErrorState({required this.errorMessage});
}

class NavigateToSensorScreenState extends DashboardState {}
