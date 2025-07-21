import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/domain/flash_light_usecase.dart';
import 'package:dashboard/domain/get_sensor_information_repository.dart';
import 'package:dashboard/domain/gyro_scope_model.dart';
import 'package:dashboard/presentation/bloc/sensor_bloc.dart';
import 'package:dashboard/presentation/bloc/sensor_event.dart';
import 'package:dashboard/presentation/bloc/sensor_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetSensorInformationRepository extends Mock
    implements GetSensorInformationRepository {}

class MockFlashLightUseCase extends Mock implements FlashLightUseCase {}

void main() {
  late SensorBloc sensorBloc;
  late MockGetSensorInformationRepository mockRepository;
  late MockFlashLightUseCase mockFlashLightUseCase;

  final gyroScopeModel = GyroScopeModel(gyroX: '1.0', gyroY: '2.0', gyroZ: '3.0');

  setUp(() {
    mockRepository = MockGetSensorInformationRepository();
    mockFlashLightUseCase = MockFlashLightUseCase();
    sensorBloc = SensorBloc(mockRepository, mockFlashLightUseCase);
  });

  tearDown(() {
    sensorBloc.close();
  });

  group('FetchSensorInformationEvent', () {
    blocTest<SensorBloc, SensorState>(
      'emits [SensorLoadedState] when repository succeeds',
      build: () {
        when(() => mockRepository.getGyroScopeInformation())
            .thenAnswer((_) async => gyroScopeModel);
        return sensorBloc;
      },
      act: (bloc) => bloc.add(FetchSensorInformationEvent()),
      expect: () => [
        isA<SensorLoadedState>().having(
              (state) => state.gyroScopeModel,
          'gyroScopeModel',
          gyroScopeModel,
        )
      ],
    );

    blocTest<SensorBloc, SensorState>(
      'emits [SensorErrorState] when repository throws',
      build: () {
        when(() => mockRepository.getGyroScopeInformation())
            .thenThrow(Exception('Failed to fetch'));
        return sensorBloc;
      },
      act: (bloc) => bloc.add(FetchSensorInformationEvent()),
      expect: () => [
        isA<SensorErrorState>().having(
              (state) => state.errorMessage,
          'errorMessage',
          contains('Exception'),
        )
      ],
    );
  });

  group('TriggeredFlashLightEvent', () {
    blocTest<SensorBloc, SensorState>(
      'emits [FlashLightLoadedState] with toggled value when use case succeeds',
      build: () {
        when(() => mockFlashLightUseCase.execute(any()))
            .thenAnswer((_) async => Future.value());
        return sensorBloc;
      },
      act: (bloc) => bloc.add(TriggeredFlashLightEvent(currentValue: false)),
      expect: () => [
        isA<FlashLightLoadedState>().having(
              (state) => state.newValue,
          'newValue',
          true,
        )
      ],
    );

    blocTest<SensorBloc, SensorState>(
      'emits [FlashLightErrorState] when use case throws',
      build: () {
        when(() => mockFlashLightUseCase.execute(any()))
            .thenThrow(Exception('Flashlight failed'));
        return sensorBloc;
      },
      act: (bloc) => bloc.add(TriggeredFlashLightEvent(currentValue: false)),
      expect: () => [
        isA<FlashLightErrorState>().having(
              (state) => state.errorMessage,
          'errorMessage',
          contains('Exception'),
        )
      ],
    );
  });
}
