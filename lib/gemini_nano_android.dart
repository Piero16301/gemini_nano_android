/// The main library for the Gemini Nano Android plugin.
library;

import 'package:flutter/services.dart';

import 'gemini_nano_android_platform_interface.dart';

/// A Flutter plugin for accessing the Gemini Nano model on Android devices.
///
/// This plugin enables interaction with the on-device generative AI capabilities provided by
/// Google's Gemini Nano model via the Android AICore.
class GeminiNanoAndroid {
  /// Creates a new instance of [GeminiNanoAndroid].
  GeminiNanoAndroid();

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
  ///
  /// [temperature]: Controls the randomness of the output. 0.0 - 1.0 (0.0 is default)
  ///
  /// [seed]: The seed for the random number generator. 0 - n (0 is default)
  ///
  /// [topK]: The number of most likely tokens to consider at each step. 1 - 40 (3 is default)
  ///
  /// [candidateCount]: The number of candidate responses to generate. 1 - 8 (1 is default)
  ///
  /// [maxOutputTokens]: The maximum number of tokens to generate. 1 - 256 (256 is default)
  Future<List<String>> generate({
    required String prompt,
    double temperature = 0,
    int seed = 0,
    int topK = 3,
    int candidateCount = 1,
    int maxOutputTokens = 256,
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
