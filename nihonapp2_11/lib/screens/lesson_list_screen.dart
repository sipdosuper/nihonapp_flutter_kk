import 'package:flutter/material.dart';
import 'learning_screen.dart'; // Màn hình hiển thị chi tiết bài học
import 'package:duandemo/model/Topic.dart';

class LessonListScreen extends StatelessWidget {
  final Topic topic;

  LessonListScreen({required this.topic});

  @override
  Widget build(BuildContext context) {
    final lessons = topic.lessons; // Lấy danh sách bài học từ chủ đề

    return Scaffold(
      backgroundColor: Colors.teal.shade100, // Màu nền giống màn hình đầu tiên
      appBar: AppBar(
        backgroundColor:
            Colors.teal.shade700, // Màu nền AppBar giống màn hình chủ đề
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
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];

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
                  color: Colors.teal.shade800, // Màu của biểu tượng
                  size: 30,
                ),
                title: Text(
                  'Bài học: ${lesson.title}', // Hiển thị tiêu đề bài học
                  style: TextStyle(
                    color: Colors.teal.shade900, // Màu chữ của tiêu đề bài học
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  // Chuyển đến màn hình chi tiết bài học khi chọn một bài học
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LearningScreen(
                        lessonTitle: lesson.title, // Truyền tiêu đề bài học
                        sentences: lesson
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
