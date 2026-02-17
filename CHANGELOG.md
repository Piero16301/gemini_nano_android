## 1.0.1

* **Fix:** Fixed the documentation and use of multimodal generation.

## 1.0.0

* **Feature:** Added support for **Multimodal Input (Text + Image)**. The `generate` method now accepts an optional `image` parameter (`Uint8List`).
* Updated Android implementation to handle image decoding and processing via `BitmapFactory`.
* Updated example app with an Image Picker to demonstrate multimodal capabilities.

## 0.1.3

* Updated `generate` method parameters to be non-nullable with default values.
* Adjusted default values for `temperature`, `topK`, `candidateCount`, and `maxOutputTokens`.
* Added documentation comments to the public API.

## 0.1.2

* Updated README documentation with screenshot table.
* Updated example app to support Markdown rendering.

## 0.1.1

* Added code coverage (Codecov) badge to README.
* Added GitHub Actions workflow for automated test coverage reporting.

## 0.1.0

* **Breaking Change:** The `generate` method now returns `Future<List<String>>` instead of `Future<String>` to support multiple candidate responses.
* Added optional generation parameters to `generate`: `temperature`, `seed`, `topK`, `candidateCount`, and `maxOutputTokens`.
* Updated example app to support configuring generation parameters.
* Documentation updates.

## 0.0.2

* Migrated from `com.google.ai.edge.aicore` to `com.google.mlkit:genai-prompt` API (v1.0.0-beta1).
* Refactored `isAvailable` logic in Android plugin.
* Added execution time display to the example application.

## 0.0.1

* Initial release. Support for text generation via Gemini Nano on Android.
* Added `GeminiNanoAndroid` class methods: `getPlatformVersion`, `isAvailable`, `generate`.
