import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gemini_nano_android_method_channel.dart';

abstract class GeminiNanoAndroidPlatform extends PlatformInterface {
  /// Constructs a GeminiNanoAndroidPlatform.
  GeminiNanoAndroidPlatform() : super(token: _token);

  static final Object _token = Object();

  static GeminiNanoAndroidPlatform _instance = MethodChannelGeminiNanoAndroid();

  /// The default instance of [GeminiNanoAndroidPlatform] to use.
  ///
  /// Defaults to [MethodChannelGeminiNanoAndroid].
  static GeminiNanoAndroidPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GeminiNanoAndroidPlatform] when
  /// they register themselves.
  static set instance(GeminiNanoAndroidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
