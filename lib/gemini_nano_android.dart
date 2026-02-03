
import 'gemini_nano_android_platform_interface.dart';

class GeminiNanoAndroid {
  Future<String?> getPlatformVersion() {
    return GeminiNanoAndroidPlatform.instance.getPlatformVersion();
  }
}
