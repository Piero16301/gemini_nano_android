import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:gemini_nano_android/gemini_nano_android.dart';
import 'package:gemini_nano_android/gemini_nano_android_platform_interface.dart';
import 'package:gemini_nano_android/gemini_nano_android_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGeminiNanoAndroidPlatform
    with MockPlatformInterfaceMixin
    implements GeminiNanoAndroidPlatform {
  @override
  Future<String?> getModelVersion() => Future.value('nano-v3');

  @override
  Future<bool> isAvailable() => Future.value(true);

  @override
  Future<List<String>> generate({
    required String prompt,
    Uint8List? image,
    double? temperature,
    int? seed,
    int? topK,
    int? candidateCount,
    int? maxOutputTokens,
  }) =>
      Future.value(['mocked response']);
}

void main() {
  final GeminiNanoAndroidPlatform initialPlatform =
      GeminiNanoAndroidPlatform.instance;

  test('$MethodChannelGeminiNanoAndroid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGeminiNanoAndroid>());
  });

  test('getModelVersion', () async {
    GeminiNanoAndroid geminiNanoAndroidPlugin = GeminiNanoAndroid();
    MockGeminiNanoAndroidPlatform fakePlatform =
        MockGeminiNanoAndroidPlatform();
    GeminiNanoAndroidPlatform.instance = fakePlatform;

    expect(await geminiNanoAndroidPlugin.getModelVersion(), 'nano-v3');
  });

  test('isAvailable', () async {
    GeminiNanoAndroid geminiNanoAndroid = GeminiNanoAndroid();
    MockGeminiNanoAndroidPlatform fakePlatform =
        MockGeminiNanoAndroidPlatform();
    GeminiNanoAndroidPlatform.instance = fakePlatform;

    expect(await geminiNanoAndroid.isAvailable(), true);
  });

  test('generate', () async {
    GeminiNanoAndroid geminiNanoAndroid = GeminiNanoAndroid();
    MockGeminiNanoAndroidPlatform fakePlatform =
        MockGeminiNanoAndroidPlatform();
    GeminiNanoAndroidPlatform.instance = fakePlatform;

    expect(
      await geminiNanoAndroid.generate(prompt: 'prompt'),
      ['mocked response'],
    );
  });
}
