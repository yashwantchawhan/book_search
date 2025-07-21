import 'package:dashboard/di/dashboard_multiple_bloc_provider.dart';
import 'package:dashboard/di/dashboard_provider.dart';
import 'package:dashboard/presentation/widgets/dashboard_screen.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockPlatformService extends Mock implements PlatformService {}

void main() {
  late MockPlatformService mockPlatformService;

  setUp(() {
    mockPlatformService = MockPlatformService();
    // optionally stub methods if required
    when(() => mockPlatformService.getBatteryLevel())
        .thenAnswer((_) async => 100);
    when(() => mockPlatformService.getDeviceName())
        .thenAnswer((_) async => 'Test Device');
    when(() => mockPlatformService.getOSVersion())
        .thenAnswer((_) async => 'Test OS');
    when(() => mockPlatformService.getGyroscopeData())
        .thenAnswer((_) async => {'x': 0.0, 'y': 0.0, 'z': 0.0});
  });

  testWidgets(
      'DashboardProvider wraps DashboardScreen with DashboardMultipleBlocProvider',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Provider<PlatformService>.value(
              value: mockPlatformService,
              child: const DashboardProvider(),
            ),
          ),
        );

        // Verify the wrapper exists
        expect(find.byType(DashboardMultipleBlocProvider), findsOneWidget);

        // Verify the DashboardScreen is rendered
        expect(find.byType(DashboardScreen), findsOneWidget);
      });
}
