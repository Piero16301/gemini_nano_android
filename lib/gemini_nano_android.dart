import 'package:flutter/services.dart';

import 'gemini_nano_android_platform_interface.dart';

class GeminiNanoAndroid {
  Future<String?> getPlatformVersion() {
    return GeminiNanoAndroidPlatform.instance.getPlatformVersion();
  }

  /// Verifica si el dispositivo soporta Gemini Nano vía AI Core.
  Future<bool> isAvailable() {
    return GeminiNanoAndroidPlatform.instance.isAvailable();
  }

  /// Genera texto basado en un prompt usando el modelo on-device.
  /// Lanza una [PlatformException] si el modelo no está descargado o falla.
  Future<String> generate(String prompt) {
    return GeminiNanoAndroidPlatform.instance.generate(prompt);
  }
}
