import 'package:flutter_test/flutter_test.dart';
import 'package:gemini_nano_android/gemini_nano_android.dart';
import 'package:gemini_nano_android/gemini_nano_android_platform_interface.dart';
import 'package:gemini_nano_android/gemini_nano_android_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGeminiNanoAndroidPlatform
    with MockPlatformInterfaceMixin
    implements GeminiNanoAndroidPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GeminiNanoAndroidPlatform initialPlatform = GeminiNanoAndroidPlatform.instance;

  test('$MethodChannelGeminiNanoAndroid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGeminiNanoAndroid>());
  });

  test('getPlatformVersion', () async {
    GeminiNanoAndroid geminiNanoAndroidPlugin = GeminiNanoAndroid();
    MockGeminiNanoAndroidPlatform fakePlatform = MockGeminiNanoAndroidPlatform();
    GeminiNanoAndroidPlatform.instance = fakePlatform;

    expect(await geminiNanoAndroidPlugin.getPlatformVersion(), '42');
  });
}
