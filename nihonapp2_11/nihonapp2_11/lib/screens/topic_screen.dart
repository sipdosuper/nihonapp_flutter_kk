import 'dart:convert';
import 'package:duandemo/word_val.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'lesson_list_screen.dart';
import 'package:duandemo/model/Topic.dart';

class TopicScreen extends StatefulWidget {
  final int level;

  TopicScreen({required this.level});

  @override
  _TopicScreenState createState() => _TopicScreenState(level: this.level);
}

class _TopicScreenState extends State<TopicScreen> {
  final int level;
  late Future<List<Topic>> futureTopics;

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
        color: Colors.white, // Nền trắng
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề màn hình
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255), // Màu đỏ nhẹ
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Text(
                'Chủ đề N${widget.level}',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Danh sách chủ đề
            Expanded(
              child: FutureBuilder<List<Topic>>(
                future: futureTopics,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFFE57373)),
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
                    return ListView.builder(
                      itemCount: topics.length,
                      itemBuilder: (context, index) {
                        final topic = topics[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LessonListScreen(topic: topic),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Color(0xFFE57373), // Viền đỏ nhẹ
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
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE57373).withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.menu_book,
                                    color: Color(0xFFE57373),
                                    size: 30,
                                  ),
                                ),
                                title: Text(
                                  topic.name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFFE57373),
                                  size: 20,
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
