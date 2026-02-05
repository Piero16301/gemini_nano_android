import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gemini_nano_android/gemini_nano_android_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelGeminiNanoAndroid platform = MethodChannelGeminiNanoAndroid();
  const MethodChannel channel = MethodChannel('gemini_nano_android');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getModelVersion':
            return 'nano-v3';
          case 'isAvailable':
            return true;
          case 'generateText':
            if (methodCall.arguments['prompt'] == 'test prompt') {
              return ['Generated text'];
            }
            return null;
          default:
            return null;
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getModelVersion', () async {
    expect(await platform.getModelVersion(), 'nano-v3');
  });

  test('isAvailable', () async {
    expect(await platform.isAvailable(), isTrue);
  });

  test('generate', () async {
    expect(
      await platform.generate(prompt: 'test prompt'),
      ['Generated text'],
    );
  });

  test('isAvailable returns false on PlatformException', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      throw PlatformException(code: 'ERROR');
    });

    expect(await platform.isAvailable(), false);
  });

  test('generate throws PlatformException on null response', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return null;
    });

    expect(
      () => platform.generate(prompt: 'prompt'),
      throwsA(isA<PlatformException>()),
    );
  });
}
