import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  MessageBubble({required this.message, required this.isMe});

  final FlutterTts _flutterTts = FlutterTts();

  void _speak() async {
    await _flutterTts.setLanguage("ja-JP");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(message);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: isMe ? Colors.white : Colors.black),
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.volume_up,
                  color: isMe ? Colors.white : Colors.black),
              onPressed: _speak,
            ),
          ],
        ),
      ),
    );
  }
}
