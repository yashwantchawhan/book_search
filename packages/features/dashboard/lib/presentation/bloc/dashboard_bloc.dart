import 'package:dashboard/domain/get_device_details_repository.dart';
import 'package:dashboard/presentation/bloc/dashboard_event.dart';
import 'package:dashboard/presentation/bloc/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDeviceDetailsRepository repository;
  DashboardBloc(
    this.repository,
  ) : super(DashboardLoadingState()) {
    on<FetchDeviceInformationEvent>((event, emit) async {
      try {
        final deviceDetailsModel = await repository.getDeviceInformation();
        emit(DashboardLoadedState(deviceDetailsModel: deviceDetailsModel));
      } catch (e) {
        emit(DashboardErrorState(errorMessage: e.toString()));
      }
    });
  }
}
