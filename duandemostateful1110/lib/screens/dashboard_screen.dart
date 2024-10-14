import 'package:flutter/material.dart';
import 'learning_screen.dart';

class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> topics;
  final int index;

  DashboardScreen({required this.topics, required this.index});

  @override
  Widget build(BuildContext context) {
    final lessons = topics[index]['lessons'] as List<Map<String, dynamic>>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: ListView.builder(
        itemCount: lessons.length,
        itemBuilder: (context, lessonIndex) {
          return Card(
            child: ListTile(
              title: Text(lessons[lessonIndex]['title']),
              onTap: () {
                // Thay pushReplacement bằng push để giữ DashboardScreen trong stack
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LearningScreen(
                      lessonTitle: lessons[lessonIndex]['title'],
                      sentences: lessons[lessonIndex]['sentences'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
