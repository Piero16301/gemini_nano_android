import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'gemini_nano_android_platform_interface.dart';

/// An implementation of [GeminiNanoAndroidPlatform] that uses method channels.
class MethodChannelGeminiNanoAndroid extends GeminiNanoAndroidPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('gemini_nano_android');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
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
  Future<String> generate(String prompt) async {
    final String? result =
        await methodChannel.invokeMethod<String>('generateText', {
      'prompt': prompt,
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
