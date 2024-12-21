import 'dart:convert';
import 'package:duandemo/screens/onionList_screen.dart';
import 'package:duandemo/word_val.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'lesson_list_screen.dart'; // Import LessonListScreen
import 'package:duandemo/model/Topic.dart'; // Import Topic model

class OnionTopicScreen extends StatefulWidget {
  final int level;

  OnionTopicScreen({required this.level});

  @override
  _TopicScreenState createState() => _TopicScreenState(level: this.level);
}

class _TopicScreenState extends State<OnionTopicScreen> {
  final int level;
  late Future<List<Topic>> futureTopics;

  _TopicScreenState({required this.level});

  @override
  void initState() {
    super.initState();
    futureTopics = fetchTopics(); // Gọi hàm lấy dữ liệu khi khởi tạo
  }

  // Hàm gọi API để lấy danh sách các chủ đề
  Future<List<Topic>> fetchTopics() async {
    final response =
        await http.get(Uri.parse(Wordval().api + 'topic/getByLevel/$level'));
    //10.50.150.165
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      List<Topic> topics =
          body.map((dynamic item) => Topic.fromJson(item)).toList();
      return topics; // Trả về danh sách các chủ đề
    } else {
      throw Exception('Failed to load topics');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sử dụng nền với gradient để giao diện sinh động hơn
      body: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
        child: Column(
          children: [
            // AppBar với kiểu gradient sinh động
            AppBar(
              backgroundColor:
                  Color(0xFFE57373), // Nền trong suốt để hiện gradient
              elevation: 0, // Không đổ bóng
              title: Text(
                'Chủ đề N${widget.level}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            Expanded(
              child: FutureBuilder<List<Topic>>(
                future: futureTopics,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(color: Colors.white));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Lỗi: ${snapshot.error}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'Không có chủ đề nào.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    );
                  } else {
                    List<Topic> topics = snapshot.data!;
                    return ListView.builder(
                      itemCount: topics.length,
                      itemBuilder: (context, index) {
                        final topic = topics[index]; // Lấy topic từ danh sách

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              // Khi chọn chủ đề, chuyển sang màn hình danh sách bài học của chủ đề đó
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OnionlistScreen(
                                      topic: topic), // Truyền topic đã chọn
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                leading: Icon(
                                  Icons.menu_book,
                                  color: Color(0xFFE57373),
                                  size: 36,
                                ),
                                title: Text(
                                  topic.name,
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
