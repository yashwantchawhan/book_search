import 'package:dashboard/domain/flash_light_usecase.dart';
import 'package:device_information/platform_channels.dart';

class FlashLightUseCaseImpl extends FlashLightUseCase {
  @override
  Future<void> execute(bool value) async {
    return  await PlatformChannels.toggleFlashlight(value);
  }
}