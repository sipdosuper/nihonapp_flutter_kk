import 'dart:convert';
import 'package:duandemo/word_val.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'lesson_list_screen.dart';
import 'package:duandemo/model/Topic.dart';

class TopicScreen2 extends StatefulWidget {
  final int level;

  TopicScreen2({required this.level});

  @override
  _TopicScreenState createState() => _TopicScreenState(level: this.level);
}

class _TopicScreenState extends State<TopicScreen2> {
  final int level;
  late Future<List<Topic>> futureTopics;
  bool showLessons = false; // Trạng thái hiển thị bài học

  _TopicScreenState({required this.level});

  @override
  void initState() {
    super.initState();
    futureTopics = fetchTopics();
  }

  Future<List<Topic>> fetchTopics() async {
    final response =
        await http.get(Uri.parse(Wordval().api + 'topic/getByLevel/$level'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => Topic.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load topics');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Đổi màu nền thành trắng
        child: FutureBuilder<List<Topic>>(
          future: futureTopics,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Lỗi: ${snapshot.error}',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'Không có chủ đề nào.',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              );
            } else {
              List<Topic> topics = snapshot.data!;
              final topic =
                  topics[0]; // Chọn Topic đầu tiên cho "Phần 1, Cửa 1"
              final lessons = topic.lessons;

              return Column(
                children: [
                  // Thanh tiêu đề
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.blue, // Màu xanh cho tiêu đề
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showLessons = !showLessons; // Toggle trạng thái
                            });
                          },
                          child: Icon(
                            showLessons
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Phần ${widget.level}, Cửa 1 - ${topic.name}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Danh sách bài học
                  if (showLessons)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: lessons.asMap().entries.map((entry) {
                            int index = entry.key;
                            final lesson = entry.value;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LessonListScreen(
                                      topic: topic,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Container(
                                  margin:
                                      EdgeInsets.only(left: 50.0 * (index % 2)),
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      lesson.title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
