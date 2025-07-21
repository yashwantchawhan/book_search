import 'package:dashboard/domain/device_details_model.dart';
import 'package:dashboard/presentation/bloc/dashboard_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardState', () {
    test('DashboardLoadingState can be instantiated', () {
      final state = DashboardLoadingState();
      expect(state, isA<DashboardState>());
      expect(state, isA<DashboardLoadingState>());
    });

    test('DashboardLoadedState holds DeviceDetailsModel', () {
      var deviceDetails = DeviceDetailsModel(
        batteryLevel: 85,
        deviceName: 'Pixel 6',
        osName: 'Android 13',
      );

      final state = DashboardLoadedState(deviceDetailsModel: deviceDetails);

      expect(state, isA<DashboardState>());
      expect(state, isA<DashboardLoadedState>());
      expect(state.deviceDetailsModel, equals(deviceDetails));
    });

    test('DashboardErrorState holds errorMessage', () {
      const errorMessage = 'Something went wrong';

      final state = DashboardErrorState(errorMessage: errorMessage);

      expect(state, isA<DashboardState>());
      expect(state, isA<DashboardErrorState>());
      expect(state.errorMessage, equals(errorMessage));
    });

    test('NavigateToSensorScreenState can be instantiated', () {
      final state = NavigateToSensorScreenState();

      expect(state, isA<DashboardState>());
      expect(state, isA<NavigateToSensorScreenState>());
    });
  });
}
