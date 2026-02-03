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
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
