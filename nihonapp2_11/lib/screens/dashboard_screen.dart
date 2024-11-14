import 'package:flutter/material.dart';
import 'learning_screen.dart';

class DashboardScreen extends StatefulWidget {
  final List<Map<String, dynamic>> topics;
  final int index;

  DashboardScreen({required this.topics, required this.index});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final lessons = widget.topics[widget.index]['lessons'] as List<Map<String, dynamic>>;

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
