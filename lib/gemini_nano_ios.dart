import 'package:flutter/foundation.dart';

import 'gemini_nano_android_platform_interface.dart';

/// The iOS implementation of [GeminiNanoAndroidPlatform].
class GeminiNanoIos extends GeminiNanoAndroidPlatform {
  /// Registers this class as the default instance of [GeminiNanoAndroidPlatform].
  static void registerWith() {
    GeminiNanoAndroidPlatform.instance = GeminiNanoIos();
  }

  @override
  Future<String?> getModelVersion() async {
    return null;
  }

  @override
  Future<bool> isAvailable() async {
    return false;
  }

  @override
  Future<List<String>> generate({
    required String prompt,
    Uint8List? image,
    double temperature = 0.2,
    int seed = 0,
    int topK = 3,
    int candidateCount = 1,
    int maxOutputTokens = 256,
  }) async {
    return <String>[];
  }
}
