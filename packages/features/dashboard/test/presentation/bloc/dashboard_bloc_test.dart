import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/domain/get_device_details_repository.dart';
import 'package:dashboard/domain/device_details_model.dart';
import 'package:dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:dashboard/presentation/bloc/dashboard_event.dart';
import 'package:dashboard/presentation/bloc/dashboard_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDeviceDetailsRepository extends Mock implements GetDeviceDetailsRepository {}

void main() {
  late DashboardBloc bloc;
  late MockGetDeviceDetailsRepository mockRepository;

  final mockDeviceDetails = DeviceDetailsModel(
    batteryLevel: 80,
    deviceName: 'Test Device',
    osName: 'Test OS',
  );

  setUp(() {
    mockRepository = MockGetDeviceDetailsRepository();
    bloc = DashboardBloc(mockRepository);
  });

  test('initial state is DashboardLoadingState', () {
    expect(bloc.state, isA<DashboardLoadingState>());
  });

  blocTest<DashboardBloc, DashboardState>(
    'emits [DashboardLoadedState] when repository returns data',
    build: () {
      when(() => mockRepository.getDeviceInformation())
          .thenAnswer((_) async => mockDeviceDetails);
      return bloc;
    },
    act: (bloc) => bloc.add(FetchDeviceInformationEvent()),
    expect: () => [
      isA<DashboardLoadedState>().having(
            (state) => state.deviceDetailsModel.deviceName,
        'deviceName',
        equals('Test Device'),
      ),
    ],
    verify: (_) {
      verify(() => mockRepository.getDeviceInformation()).called(1);
    },
  );

  blocTest<DashboardBloc, DashboardState>(
    'emits [DashboardErrorState] when repository throws',
    build: () {
      when(() => mockRepository.getDeviceInformation())
          .thenThrow(Exception('Failed to fetch'));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchDeviceInformationEvent()),
    expect: () => [
      isA<DashboardErrorState>().having(
            (state) => state.errorMessage,
        'errorMessage',
        contains('Failed to fetch'),
      ),
    ],
    verify: (_) {
      verify(() => mockRepository.getDeviceInformation()).called(1);
    },
  );
}
