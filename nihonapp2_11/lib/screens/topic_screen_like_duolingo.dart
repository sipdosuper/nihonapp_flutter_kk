import 'dart:convert';
import 'package:duandemo/word_val.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:duandemo/model/Topic.dart';
import 'package:duandemo/model/Sentence.dart';
import 'learning_screen.dart'; // Import màn hình LearningScreen
import 'package:duandemo/service/ToppicService.dart';

class TopicScreen2 extends StatefulWidget {
  final int level;

  TopicScreen2({required this.level});

  @override
  _TopicScreenState createState() => _TopicScreenState(level: this.level);
}

class _TopicScreenState extends State<TopicScreen2> {
  final int level;
  late Future<List<Topic>> futureTopics;
  bool showDropdown = false; // Trạng thái hiển thị menu dropdown
  int selectedTopicIndex = 0; // Chủ đề được chọn

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
      // Thay đổi từ màu trắng sang gradient để có nền mềm mại hơn
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade100, Colors.red.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<Topic>>(
          future: futureTopics,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.red),
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
              final topic = topics[selectedTopicIndex];
              final lessons = topic.lessons;

              return Column(
                children: [
                  // Thanh tiêu đề được thiết kế lại với gradient và shadow mềm mại
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      // Code cũ: color: Color(0xFFE57373),
                      // Thay bằng gradient:
                      gradient: LinearGradient(
                        colors: [Colors.red.shade400, Colors.red.shade700],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showDropdown = !showDropdown; // Toggle dropdown
                            });
                          },
                          child: Icon(
                            showDropdown
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'N${widget.level}, Chủ đề ${selectedTopicIndex + 1} - ${topic.name}',
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
                  // Combobox hiển thị danh sách chủ đề với thiết kế mềm mại
                  if (showDropdown)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: topics.asMap().entries.map((entry) {
                          int index = entry.key;
                          final topic = entry.value;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTopicIndex = index;
                                showDropdown = false; // Ẩn menu sau khi chọn
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: selectedTopicIndex == index
                                    ? Colors.red.shade100
                                    : Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.topic,
                                    color: selectedTopicIndex == index
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Chủ đề ${index + 1} - ${topic.name}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: selectedTopicIndex == index
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  SizedBox(height: 20),
                  // Danh sách bài học được thiết kế với hiệu ứng bo tròn và shadow
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
                                  builder: (context) => LearningScreen(
                                    lessonTitle: lesson.title,
                                    sentences: lesson.sentence,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Container(
                                margin: EdgeInsets.only(left: 50.0 * (index % 2)),
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.red,
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
