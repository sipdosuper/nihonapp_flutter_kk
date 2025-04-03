import 'package:flutter/material.dart';
import 'chat_screen.dart'; // Đảm bảo đường dẫn đúng

class ViewSavedChatScreen extends StatelessWidget {
  final String chatName;
  final List<Map<String, dynamic>> messages;

  const ViewSavedChatScreen({
    super.key,
    required this.chatName,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatName),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          final isUser = message['sender'] == 'User';
          return Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(12),
              constraints: const BoxConstraints(maxWidth: 280),
              decoration: BoxDecoration(
                color: isUser ? Colors.blueAccent : Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['text'],
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  if (message['translation'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        message['translation'],
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final aiMsg = messages.firstWhere(
            (m) => m['sender'] == 'AI',
            orElse: () => {'text': 'Xin chào!'},
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                initialMessage: aiMsg['text'],
                userCharacter: 'Người học',
                userGender: 'Nam',
                aiCharacter: 'AI tiếng Nhật',
                aiGender: 'Nữ',
                description: 'Tiếp tục cuộc trò chuyện đã lưu',
                previousMessages: messages, // 👈 truyền danh sách đã lưu
              ),
            ),
          );
        },
        icon: const Icon(Icons.play_arrow),
        label: const Text("Tiếp tục trò chuyện"),
      ),
    );
  }
}
