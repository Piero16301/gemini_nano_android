import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gemini_nano_android_method_channel.dart';

/// The interface that implementations of gemini_nano_android must implement.
///
/// Platform implementations should extend this class rather than implement it as `GeminiNanoAndroid`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [GeminiNanoAndroidPlatform] methods.
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

  /// Returns the model version used.
  Future<String?> getModelVersion() {
    throw UnimplementedError('getModelVersion() has not been implemented.');
  }

  /// Checks if the device supports Gemini Nano via AICore.
  Future<bool> isAvailable() {
    throw UnimplementedError('isAvailable() has not been implemented.');
  }

  /// Generates a list of strings based on a prompt using the on-device model.
  Future<List<String>> generate({
    required String prompt,
    double? temperature,
    int? seed,
    int? topK,
    int? candidateCount,
    int? maxOutputTokens,
  }) {
    throw UnimplementedError('generate() has not been implemented.');
  }
}
