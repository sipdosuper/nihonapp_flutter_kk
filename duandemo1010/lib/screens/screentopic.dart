import 'dart:convert';

import 'package:duandemo/model/Topic.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Topic>> fetchTopics() async {
  // Thay URL bằng địa chỉ API của bạn
  final response = await http.get(Uri.parse('http://localhost:8080/api/topic'));

  if (response.statusCode == 200) {
    print(response.body);
    // Parse JSON từ response
    List<dynamic> body = json.decode(response.body);
    List<Topic> topics =
        body.map((dynamic item) => Topic.fromJson(item)).toList();
    return topics;
  } else {
    // Nếu response thất bại
    throw Exception('Failed to load topics');
  }
}

class TopicsScreen extends StatefulWidget {
  @override
  _TopicsScreenState createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  late Future<List<Topic>> futureTopics;

  @override
  void initState() {
    super.initState();
    futureTopics = fetchTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topics'),
      ),
      body: FutureBuilder<List<Topic>>(
        future: futureTopics,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Topic>? topics = snapshot.data;
            return ListView.builder(
              itemCount: topics!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(topics[index].name),
                );
              },
            );
          } else {
            return Center(child: Text('No topics found'));
          }
        },
      ),
    );
  }
}
