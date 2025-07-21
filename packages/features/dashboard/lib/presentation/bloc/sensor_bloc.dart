import 'package:dashboard/domain/get_sensor_information_repository.dart';
import 'package:dashboard/domain/flash_light_usecase.dart';
import 'package:dashboard/presentation/bloc/sensor_event.dart';
import 'package:dashboard/presentation/bloc/sensor_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SensorBloc extends Bloc<SensorEvent, SensorState> {
  final GetSensorInformationRepository repository;
  final FlashLightUseCase flashLightUseCase;

  SensorBloc(
    this.repository,
    this.flashLightUseCase,
  ) : super(SensorLoadingState()) {
    on<FetchSensorInformationEvent>((event, emit) async {
      try {
        final gyroScopeModel = await repository.getGyroScopeInformation();
        emit(SensorLoadedState(gyroScopeModel: gyroScopeModel));
      } catch (e) {
        emit(SensorErrorState(errorMessage: e.toString()));
      }
    });

    on<TriggeredFlashLightEvent>((event, emit) async {
      try {
        final newValue = !event.currentValue;
        await flashLightUseCase.execute(newValue);
        emit(FlashLightLoadedState(newValue: newValue));
      } catch (e) {
        emit(FlashLightErrorState(errorMessage: e.toString()));
      }
    });
  }
}
