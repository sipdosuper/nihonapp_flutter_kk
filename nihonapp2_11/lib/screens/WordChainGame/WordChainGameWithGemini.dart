import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class WordChainGameWithGemini extends StatefulWidget {
  const WordChainGameWithGemini({super.key});

  @override
  State<WordChainGameWithGemini> createState() => _WordChainGameWithGemini();
}

class _WordChainGameWithGemini extends State<WordChainGameWithGemini> {
  late final GenerativeModel _model;
  late final ChatSession _chatSession;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: "gemini-pro",
      apiKey: const String.fromEnvironment("api_key"),
    );
    // GenerativeModel
    _chatSession = _model.startChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Build with Gemini'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                // ListView.builder
              },
            ),
          ),
          // Expanded
        ],
      ),
    );
  }
}
