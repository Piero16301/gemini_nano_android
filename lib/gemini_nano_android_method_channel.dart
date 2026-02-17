/// The method channel implementation of the Gemini Nano Android plugin.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'gemini_nano_android_platform_interface.dart';

/// An implementation of [GeminiNanoAndroidPlatform] that uses method channels.
class MethodChannelGeminiNanoAndroid extends GeminiNanoAndroidPlatform {
  /// Creates a new instance of [MethodChannelGeminiNanoAndroid].
  MethodChannelGeminiNanoAndroid();

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('gemini_nano_android');

  @override
  Future<String?> getModelVersion() async {
    final version = await methodChannel.invokeMethod<String>('getModelVersion');
    return version;
  }

  @override
  Future<bool> isAvailable() async {
    try {
      final bool? result =
          await methodChannel.invokeMethod<bool>('isAvailable');
      return result ?? false;
    } on PlatformException catch (_) {
      return false;
    }
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
    final List<String>? result =
        await methodChannel.invokeListMethod<String>('generateText', {
      'prompt': prompt,
      'image': image,
      'temperature': temperature,
      'seed': seed,
      'topK': topK,
      'candidateCount': candidateCount,
      'maxOutputTokens': maxOutputTokens,
    });
    if (result == null) {
      throw PlatformException(
        code: 'NULL_RESPONSE',
        message: 'The model returned null.',
      );
    }
    return result;
  }
}
