import 'package:dashboard/di/dashboard_multiple_bloc_provider.dart';
import 'package:dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:dashboard/presentation/bloc/sensor_bloc.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

// Mock PlatformService
class MockPlatformService extends Mock implements PlatformService {}

void main() {
  late MockPlatformService mockPlatformService;

  setUp(() {
    mockPlatformService = MockPlatformService();
  });

  testWidgets(
      'DashboardMultipleBlocProvider provides DashboardBloc and SensorBloc and builds child',
          (tester) async {
        final testKey = Key('test-child');

        await tester.pumpWidget(
          Provider<PlatformService>.value(
            value: mockPlatformService,
            child: MaterialApp(
              home: DashboardMultipleBlocProvider(
                child: Container(key: testKey),
              ),
            ),
          ),
        );

        // Verify that the child is in the widget tree
        expect(find.byKey(testKey), findsOneWidget);

        // Verify that DashboardBloc is available in the context
        final dashboardBloc =
        tester.element(find.byKey(testKey)).read<DashboardBloc>();
        expect(dashboardBloc, isA<DashboardBloc>());

        // Verify that SensorBloc is available in the context
        final sensorBloc =
        tester.element(find.byKey(testKey)).read<SensorBloc>();
        expect(sensorBloc, isA<SensorBloc>());
      });
}
