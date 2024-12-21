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
      backgroundColor: Colors.white, // Nền trắng
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tên chủ đề
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Color(0xFFE57373), // Màu đỏ nhạt
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(
              'Chủ đề: ${topic.name}', // Hiển thị tên của chủ đề
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20),
          // Danh sách bài học
          Expanded(
            child: ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      // Chuyển đến màn hình chi tiết bài học
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LearningScreen(
                            lessonTitle: lesson.title,
                            sentences: lesson.sentence,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Nền trắng
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Color(0xFFE57373), // Viền đỏ nhạt
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Biểu tượng
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFFE57373).withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.library_books,
                              color: Color(0xFFE57373),
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 16),
                          // Nội dung
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bài học: ${lesson.title}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Nhấp để xem chi tiết',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Color(0xFFE57373),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
