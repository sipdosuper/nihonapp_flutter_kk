import 'dart:convert';

import 'package:duandemo/model/Lesson.dart';
import 'package:duandemo/model/Sentence.dart';
import 'package:duandemo/model/Topic.dart';
import 'package:duandemo/screens/screentopic.dart';
import 'package:duandemo/service/ToppicService.dart';
import 'package:flutter/material.dart';
import 'learning_screen.dart';
import 'package:http/http.dart' as http; // Đừng quên import LearningScreen

class TopicScreen extends StatefulWidget {
  final int level;

  TopicScreen({required this.level});

  @override
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  late Future<List<Topic>> futureTopics;
  late List<Topic> lsttopic = [];
  late List<Lesson> lstLesson = [];
  late List<Sentence> lstSentence = [];
  final topicService = TopicService();
  late List<dynamic> body;
  @override
  void initState() {
    super.initState();
    futureTopics = fetchTopics();
    topicService.createTopic(2, "Hom nay toi nghi hoc");
  }

  Future<List<Topic>> fetchTopics() async {
    // Thay URL bằng địa chỉ API của bạn
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/topic'));

    if (response.statusCode == 200) {
      // Parse JSON từ response
      body = json.decode(response.body);
      print(body);
      List<Topic> topics =
          body.map((dynamic item) => Topic.fromJson(item)).toList();
      print(topics.length);
      List<Lesson> lessons = topics[0].lessons;
      // body.map((dynamic item) => Lesson.fromJson(item)).toList();
      print(lessons);
      List<Sentence> sentences = lessons[0].sentence;

      setState(() {
        lsttopic = topics;
        lstLesson = lessons;
        lstSentence = sentences;
      });
      return topics;
    } else {
      // Nếu response thất bại
      throw Exception('Failed to load topics');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final List<Topic> topics = lsttopic;
    // final List<Lesson> lessons = lstLesson;
    final List<Sentence> sentences = lstSentence;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chủ đề N${widget.level}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: sentences.length,
        itemBuilder: (context, index) {
          final lesson = sentences[index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    lesson.id.toString() + lesson.word,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
