import 'package:flutter/material.dart';

class CommunicationLessonsScreen extends StatelessWidget {
  final List<Map<String, String>> lessons = [
    {
      "title": "Chủ đề 1",
      "description": "Học cách chào hỏi",
    },
    {
      "title": "Chủ đề 2",
      "description": "Học cách hỏi đường",
    },
    // Thêm nhiều chủ đề hơn ở đây
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Các Bài Học Giao Tiếp"),
      ),
      body: ListView.builder(
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(lessons[index]['title']!),
            subtitle: Text(lessons[index]['description']!),
            onTap: () {
              // Điều hướng đến màn hình chi tiết bài học nếu cần
            },
          );
        },
      ),
    );
  }
}
