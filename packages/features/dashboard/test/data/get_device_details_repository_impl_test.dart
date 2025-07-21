import 'package:dashboard/data/get_device_details_repository_impl.dart';
import 'package:dashboard/domain/device_details_model.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPlatformService extends Mock implements PlatformService {}

void main() {
  late GetDeviceDetailsRepositoryImpl repository;
  late MockPlatformService mockPlatformService;

  setUp(() {
    mockPlatformService = MockPlatformService();
    repository = GetDeviceDetailsRepositoryImpl(platformService: mockPlatformService);
  });

  test('returns DeviceDetailsModel with correct values', () async {
    // Arrange
    const mockBatteryLevel = 80;
    const mockDeviceName = 'iPhone 14 Pro';
    const mockOSVersion = 'iOS 17.2';

    when(() => mockPlatformService.getBatteryLevel())
        .thenAnswer((_) async => mockBatteryLevel);
    when(() => mockPlatformService.getDeviceName())
        .thenAnswer((_) async => mockDeviceName);
    when(() => mockPlatformService.getOSVersion())
        .thenAnswer((_) async => mockOSVersion);

    // Act
    final result = await repository.getDeviceInformation();

    // Assert
    expect(result, isA<DeviceDetailsModel>());
    expect(result.batteryLevel, mockBatteryLevel);
    expect(result.deviceName, mockDeviceName);
    expect(result.osName, mockOSVersion);

    verify(() => mockPlatformService.getBatteryLevel()).called(1);
    verify(() => mockPlatformService.getDeviceName()).called(1);
    verify(() => mockPlatformService.getOSVersion()).called(1);
  });
}
