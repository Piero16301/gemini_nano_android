import 'package:flutter/services.dart';

import 'gemini_nano_android_platform_interface.dart';

/// A Flutter plugin for accessing the Gemini Nano model on Android devices.
///
/// This plugin enables interaction with the on-device generative AI capabilities provided by
/// Google's Gemini Nano model via the Android AICore.
class GeminiNanoAndroid {
  /// Returns the model version used.
  Future<String?> getModelVersion() {
    return GeminiNanoAndroidPlatform.instance.getModelVersion();
  }

  /// Checks if the device supports Gemini Nano via AICore.
  ///
  /// Returns `true` if the model is available and ready for use, `false` otherwise.
  Future<bool> isAvailable() {
    return GeminiNanoAndroidPlatform.instance.isAvailable();
  }

  /// Generates a list of strings based on a prompt using the on-device model.
  ///
  /// Throws a [PlatformException] if the model is not downloaded or fails.
  ///
  /// [prompt]: The input text to generate content from.
  /// [temperature]: Controls the randomness of the output. Lower values make the output more deterministic, while higher values make it more creative.
  /// [seed]: The seed for the random number generator.
  /// [topK]: The number of most likely tokens to consider at each step.
  /// [candidateCount]: The number of candidate responses to generate.
  /// [maxOutputTokens]: The maximum number of tokens to generate.
  Future<List<String>> generate({
    required String prompt,
    double? temperature,
    int? seed,
    int? topK,
    int? candidateCount,
    int? maxOutputTokens,
  }) {
    return GeminiNanoAndroidPlatform.instance.generate(
      prompt: prompt,
      temperature: temperature,
      seed: seed,
      topK: topK,
      candidateCount: candidateCount,
      maxOutputTokens: maxOutputTokens,
    );
  }
}
