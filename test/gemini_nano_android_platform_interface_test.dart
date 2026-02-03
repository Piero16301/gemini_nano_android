import 'package:flutter_test/flutter_test.dart';
import 'package:gemini_nano_android/gemini_nano_android_platform_interface.dart';

class MockGeminiNanoAndroidPlatform extends GeminiNanoAndroidPlatform {}

void main() {
  group('GeminiNanoAndroidPlatform', () {
    test(
        'default implementation of getPlatformVersion throws UnimplementedError',
        () {
      final platform = MockGeminiNanoAndroidPlatform();
      expect(
        () => platform.getPlatformVersion(),
        throwsUnimplementedError,
      );
    });

    test('default implementation of isAvailable throws UnimplementedError', () {
      final platform = MockGeminiNanoAndroidPlatform();
      expect(
        () => platform.isAvailable(),
        throwsUnimplementedError,
      );
    });

    test('default implementation of generate throws UnimplementedError', () {
      final platform = MockGeminiNanoAndroidPlatform();
      expect(
        () => platform.generate('prompt'),
        throwsUnimplementedError,
      );
    });
  });
}
