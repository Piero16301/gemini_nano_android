import 'package:flutter_test/flutter_test.dart';
import 'package:gemini_nano_android/gemini_nano_ios.dart';
import 'package:gemini_nano_android/gemini_nano_android_platform_interface.dart';

void main() {
  group('GeminiNanoIos', () {
    late GeminiNanoIos iosPlatform;

    setUp(() {
      iosPlatform = GeminiNanoIos();
    });

    test('registerWith sets instance', () {
      GeminiNanoIos.registerWith();
      expect(GeminiNanoAndroidPlatform.instance, isA<GeminiNanoIos>());
    });

    test('getModelVersion returns null', () async {
      final version = await iosPlatform.getModelVersion();
      expect(version, isNull);
    });

    test('isAvailable returns false', () async {
      final isAvailable = await iosPlatform.isAvailable();
      expect(isAvailable, isFalse);
    });

    test('generate returns an empty list', () async {
      final results = await iosPlatform.generate(prompt: 'test prompt');
      expect(results, isEmpty);
      expect(results, isA<List<String>>());
    });
  });
}
