import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final String? translation; // Thêm trường bản dịch
  final bool isUser;
  final VoidCallback? onTranslate; // Hàm callback khi nhấn dịch

  const ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
    this.translation,
    this.onTranslate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUser ? Colors.blue[200] : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(text, style: const TextStyle(fontSize: 16)),
        ),
        // Nếu có bản dịch thì hiển thị
        if (translation != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              translation!,
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              ),
            ),
          ),
        // Nút dịch chỉ hiện nếu chưa có bản dịch
        if (onTranslate != null && translation == null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4),
            child: TextButton(
              onPressed: onTranslate,
              child: const Text('Dịch sang Tiếng Việt'),
            ),
          ),
      ],
    );
  }
}
