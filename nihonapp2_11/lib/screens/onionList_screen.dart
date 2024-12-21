import 'package:duandemo/model/Onion.dart';
import 'package:duandemo/screens/onion_screen.dart';
import 'package:flutter/material.dart';
import 'learning_screen.dart'; // Màn hình hiển thị chi tiết bài học
import 'package:duandemo/model/Topic.dart';

class OnionlistScreen extends StatelessWidget {
  final Topic topic;

  OnionlistScreen({required this.topic});

  @override
  Widget build(BuildContext context) {
    final onions = topic.onions; // Lấy danh sách bài học từ chủ đề

    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 255, 255, 255), // Màu nền giống màn hình đầu tiên
      appBar: AppBar(
        backgroundColor:
            Color(0xFFE57373), // Màu nền AppBar giống màn hình chủ đề
        title: Text(
          'Chủ đề: ${topic.name}', // Hiển thị tên của chủ đề
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: onions.length,
        itemBuilder: (context, index) {
          final onion = onions[index];

          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              color: Colors.white.withOpacity(0.9), // Nền của mỗi Card bài học
              elevation: 4, // Độ nổi của Card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Bo góc của Card
              ),
              child: ListTile(
                leading: Icon(
                  Icons.library_books,
                  color: Color(0xFFE57373), // Màu của biểu tượng
                  size: 30,
                ),
                title: Text(
                  'Bài học: ${onion.title}', // Hiển thị tiêu đề bài học
                  style: TextStyle(
                    color: const Color.fromARGB(
                        255, 0, 0, 0), // Màu chữ của tiêu đề bài học
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  // Chuyển đến màn hình chi tiết bài học khi chọn một bài học
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OnionScreen(
                        onionTitle: onion.title,
                        sentences: onion
                            .sentence, // Truyền danh sách câu trong bài học (có thể cập nhật sau)
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
