import 'package:dashboard/data/get_sensor_information_repository_impl.dart';
import 'package:dashboard/domain/gyro_scope_model.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock PlatformService
class MockPlatformService extends Mock implements PlatformService {}

void main() {
  late GetSensorInformationRepositoryImpl repository;
  late MockPlatformService mockPlatformService;

  setUp(() {
    mockPlatformService = MockPlatformService();
    repository = GetSensorInformationRepositoryImpl(
      platformService: mockPlatformService,
    );
  });

  test('should return GyroScopeModel with formatted values', () async {
    // Arrange
    final mockGyroData = {
      'x': 1.2345,
      'y': -2.3456,
      'z': 3.4567,
    };

    when(() => mockPlatformService.getGyroscopeData())
        .thenAnswer((_) async => mockGyroData);

    // Act
    final result = await repository.getGyroScopeInformation();

    // Assert
    expect(result, isA<GyroScopeModel>());
    expect(result.gyroX, '1.23');
    expect(result.gyroY, '-2.35');
    expect(result.gyroZ, '3.46');

    verify(() => mockPlatformService.getGyroscopeData()).called(1);
  });
}
