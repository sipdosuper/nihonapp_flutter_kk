import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatInputField extends StatefulWidget {
  final Function(String) onSend;

  ChatInputField({required this.onSend});

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        setState(() {
          _controller.text = result.recognizedWords;
        });
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "Enter message"),
          ),
        ),
        IconButton(
          icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
          onPressed: () {
            if (_isListening) {
              _stopListening();
            } else {
              _startListening();
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              widget.onSend(_controller.text.trim());
              _controller.clear();
            }
          },
        ),
      ],
    );
  }
}
