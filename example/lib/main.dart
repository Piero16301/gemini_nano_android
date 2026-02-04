import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:gemini_nano_android/gemini_nano_android.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _modelVersion = 'Unknown';
  bool? _isAvailable;
  String _generatedText = '';
  double? _executionTime;
  bool _isGenerating = false;
  final _promptController = TextEditingController();
  final _geminiNanoAndroidPlugin = GeminiNanoAndroid();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String modelVersion;
    bool? isAvailable;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      modelVersion =
          await _geminiNanoAndroidPlugin.getModelVersion() ??
          'Unknown model version';
    } on PlatformException {
      modelVersion = 'Failed to get model version.';
    }

    try {
      isAvailable = await _geminiNanoAndroidPlugin.isAvailable();
    } on PlatformException {
      isAvailable = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _modelVersion = modelVersion;
      _isAvailable = isAvailable;
    });
  }

  Future<void> _generateText() async {
    if (_promptController.text.isEmpty) return;

    setState(() {
      _executionTime = null;
      _isGenerating = true;
    });

    final stopwatch = Stopwatch()..start();

    try {
      final result = await _geminiNanoAndroidPlugin.generate(
        _promptController.text,
      );
      stopwatch.stop();
      if (!mounted) return;
      setState(() {
        _generatedText = result;
        _executionTime = stopwatch.elapsedMilliseconds / 1000.0;
        _isGenerating = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _generatedText = 'Error: $e';
        _executionTime = null;
        _isGenerating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Gemini Nano Example')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                Text('Model version: $_modelVersion'),
                Text.rich(
                  TextSpan(
                    text: 'Gemini Nano Available: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: _isAvailable == true
                            ? 'AVAILABLE'
                            : 'UNAVAILABLE',
                        style: TextStyle(
                          color: _isAvailable == true
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: _promptController,
                  decoration: const InputDecoration(
                    labelText: 'Enter prompt',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                ElevatedButton(
                  onPressed: _isAvailable == true && !_isGenerating
                      ? _generateText
                      : null,
                  child: Text(_isGenerating ? 'Generating...' : 'Generate'),
                ),
                if (_executionTime != null) ...[
                  Text(
                    'Execution time: ${_executionTime!.toStringAsFixed(2)}s',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
                if (_generatedText.isNotEmpty && !_isGenerating) ...[
                  const Text(
                    'GENERATED TEXT',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: SingleChildScrollView(child: Text(_generatedText)),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
