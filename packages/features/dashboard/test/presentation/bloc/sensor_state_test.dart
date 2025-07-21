import 'package:flutter_test/flutter_test.dart';
import 'package:dashboard/domain/gyro_scope_model.dart';
import 'package:dashboard/presentation/bloc/sensor_state.dart';

void main() {
  group('SensorLoadingState', () {
    test('can be instantiated', () {
      final state = SensorLoadingState();
      expect(state, isA<SensorLoadingState>());
    });
  });

  group('SensorLoadedState', () {
    test('stores the provided GyroScopeModel', () {
      final gyroModel = GyroScopeModel(gyroX: '1.0', gyroY: '2.0', gyroZ: '3.0');
      final state = SensorLoadedState(gyroScopeModel: gyroModel);

      expect(state.gyroScopeModel, equals(gyroModel));
      expect(state.gyroScopeModel.gyroX, '1.0');
      expect(state.gyroScopeModel.gyroY, '2.0');
      expect(state.gyroScopeModel.gyroZ, '3.0');
    });
  });

  group('SensorErrorState', () {
    test('stores the error message', () {
      final state = SensorErrorState(errorMessage: 'Something went wrong');
      expect(state.errorMessage, 'Something went wrong');
    });
  });

  group('FlashLightLoadedState', () {
    test('stores the newValue', () {
      final state = FlashLightLoadedState(newValue: true);
      expect(state.newValue, isTrue);
    });
  });

  group('FlashLightErrorState', () {
    test('stores the error message', () {
      final state = FlashLightErrorState(errorMessage: 'Flashlight failed');
      expect(state.errorMessage, 'Flashlight failed');
    });
  });
}
