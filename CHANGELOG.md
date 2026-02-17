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
