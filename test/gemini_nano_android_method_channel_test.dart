import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gemini_nano_android/gemini_nano_android_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelGeminiNanoAndroid platform = MethodChannelGeminiNanoAndroid();
  const MethodChannel channel = MethodChannel('gemini_nano_android');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
