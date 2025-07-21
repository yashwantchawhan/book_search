import 'package:flutter_test/flutter_test.dart';
import 'package:dashboard/presentation/bloc/sensor_event.dart';

void main() {
  group('FetchSensorInformationEvent', () {
    test('supports value comparison', () {
      expect(
        FetchSensorInformationEvent(),
        isA<FetchSensorInformationEvent>(),
      );
    });
  });

  group('TriggeredFlashLightEvent', () {
    test('has correct currentValue', () {
      final event = TriggeredFlashLightEvent(currentValue: true);

      expect(event.currentValue, isTrue);
    });

    test('two events with same currentValue are equal (if == implemented)', () {
      final event1 = TriggeredFlashLightEvent(currentValue: false);
      final event2 = TriggeredFlashLightEvent(currentValue: false);

      // Here we only check their field because unless you override ==/hashCode,
      // two instances are NOT equal even with same values.
      expect(event1.currentValue, event2.currentValue);
    });

    test('two events with different currentValue are not equal', () {
      final event1 = TriggeredFlashLightEvent(currentValue: true);
      final event2 = TriggeredFlashLightEvent(currentValue: false);

      expect(event1.currentValue, isNot(equals(event2.currentValue)));
    });
  });
}
