import 'package:duandemo/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHomescreen extends StatefulWidget {
  @override
  _ChatHomescreenState createState() => _ChatHomescreenState();
}

class _ChatHomescreenState extends State<ChatHomescreen> {
  final TextEditingController _receiverIdController = TextEditingController();
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername(); // Gọi hàm để lấy username khi màn hình được khởi tạo
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ??
          'khoa'; // Default là 'khoa' nếu không tìm thấy
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trang chính')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _receiverIdController,
              decoration: InputDecoration(
                labelText: 'Nhập ID của người nhận',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String receiverId = _receiverIdController.text.trim();
                if (receiverId.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatId:
                            '${_username}_$receiverId', // Sử dụng username từ SharedPreferences
                        currentUserId: _username, // Gửi username hiện tại
                        receiverId: receiverId,
                      ),
                    ),
                  );
                }
              },
              child: Text('Bắt đầu trò chuyện'),
            ),
          ],
        ),
      ),
    );
  }
}
