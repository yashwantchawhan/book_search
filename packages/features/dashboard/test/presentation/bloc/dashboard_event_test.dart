import 'package:dashboard/presentation/bloc/dashboard_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FetchDeviceInformationEvent can be instantiated and is a DashboardEvent', () {
    final event = FetchDeviceInformationEvent();

    expect(event, isA<FetchDeviceInformationEvent>());
    expect(event, isA<DashboardEvent>());
  });
}
