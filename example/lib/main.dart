import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:gemini_nano_android/gemini_nano_android.dart';
import 'package:image_picker/image_picker.dart';

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
  List<String> _generatedResults = [];
  double? _executionTime;
  bool _isGenerating = false;
  final _promptController = TextEditingController();
  final _geminiNanoAndroidPlugin = GeminiNanoAndroid();
  Uint8List? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Configuration parameters
  double _temperature = 0.2;
  final _seedController = TextEditingController();
  final _topKController = TextEditingController();
  final _candidateCountController = TextEditingController();
  final _maxOutputTokensController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    _promptController.dispose();
    _seedController.dispose();
    _topKController.dispose();
    _candidateCountController.dispose();
    _maxOutputTokensController.dispose();
    super.dispose();
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
      _generatedResults = [];
    });

    final stopwatch = Stopwatch()..start();

    try {
      final result = await _geminiNanoAndroidPlugin.generate(
        prompt: _promptController.text,
        image: _selectedImage,
        temperature: _temperature,
        seed: int.tryParse(_seedController.text) ?? 0,
        topK: int.tryParse(_topKController.text) ?? 3,
        candidateCount: int.tryParse(_candidateCountController.text) ?? 1,
        maxOutputTokens: int.tryParse(_maxOutputTokensController.text) ?? 256,
      );
      stopwatch.stop();
      if (!mounted) return;
      setState(() {
        _generatedResults = result;
        _executionTime = stopwatch.elapsedMilliseconds / 1000.0;
        _isGenerating = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _generatedResults = ['Error: $e'];
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 16,
                      children: [
                        ..._buildModelDetails(),
                        TextField(
                          controller: _promptController,
                          decoration: const InputDecoration(
                            labelText: 'Enter prompt',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 4,
                        ),
                        ..._buildImagePicker(),
                        _buildModelSettings(),
                        ElevatedButton(
                          onPressed: _isAvailable == true && !_isGenerating
                              ? _generateText
                              : null,
                          child: Text(
                            _isGenerating ? 'Generating...' : 'Generate',
                          ),
                        ),
                        ..._buildModelResponse(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildModelDetails() {
    return [
      Text('Model version: $_modelVersion'),
      Text.rich(
        TextSpan(
          text: 'Gemini Nano Available: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: _isAvailable == true ? 'AVAILABLE' : 'UNAVAILABLE',
              style: TextStyle(
                color: _isAvailable == true ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildImagePicker() {
    if (_selectedImage != null) {
      return [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                _selectedImage!,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, fontWeight: FontWeight.bold),
                onPressed: () {
                  setState(() {
                    _selectedImage = null;
                  });
                },
              ),
            ),
          ],
        ),
      ];
    } else {
      return [
        ElevatedButton.icon(
          onPressed: _isGenerating ? null : _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Pick Image (Optional)'),
        ),
      ];
    }
  }

  Widget _buildModelSettings() {
    return ExpansionTile(
      title: const Text('Advanced Settings'),
      shape: const Border(),
      collapsedShape: const Border(),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            spacing: 16,
            children: [
              Row(
                children: [
                  const Text('Temperature: '),
                  Expanded(
                    child: Slider(
                      value: _temperature,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      label: (_temperature).toString(),
                      onChanged: _isGenerating
                          ? null
                          : (value) {
                              setState(() {
                                _temperature = value;
                              });
                            },
                    ),
                  ),
                  Text((_temperature).toStringAsFixed(1)),
                ],
              ),
              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _seedController,
                      enabled: !_isGenerating,
                      decoration: const InputDecoration(
                        labelText: 'Seed (Optional)',
                        hintText: 'Enter integer seed',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _topKController,
                      enabled: !_isGenerating,
                      decoration: const InputDecoration(
                        labelText: 'Top K (Optional)',
                        hintText: 'Enter integer Top K',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _candidateCountController,
                      enabled: !_isGenerating,
                      decoration: const InputDecoration(
                        labelText: 'Candidate Count (Optional)',
                        hintText: 'Enter integer',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _maxOutputTokensController,
                      enabled: !_isGenerating,
                      decoration: const InputDecoration(
                        labelText: 'Max Output Tokens (Optional)',
                        hintText: 'Enter integer',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildModelResponse() {
    final List<Widget> widgets = [];

    if (_executionTime != null) {
      widgets.add(
        Text(
          'Execution time: ${_executionTime!.toStringAsFixed(2)}s',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    if (_generatedResults.isNotEmpty && !_isGenerating) {
      widgets.add(
        const Text(
          'GENERATED RESULTS',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );
      widgets.addAll(
        _generatedResults.asMap().entries.map((entry) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_generatedResults.length > 1)
                    Text(
                      'Candidate ${entry.key + 1}:',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  MarkdownBody(data: entry.value),
                ],
              ),
            ),
          );
        }),
      );
    }
    return widgets;
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedImage = bytes;
      });
    }
  }
}
