import 'dart:convert';
import 'package:duandemo/screens/homework/user_homework_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:duandemo/model/User_HomeWork.dart';
import 'package:duandemo/word_val.dart';

class ShowHomeworkByClass extends StatefulWidget {
  final int classId;
  ShowHomeworkByClass({required this.classId});

  @override
  _ShowHomeworkByClassState createState() => _ShowHomeworkByClassState();
}

class _ShowHomeworkByClassState extends State<ShowHomeworkByClass> {
  String api = Wordval().api;
  List<dynamic> homeworks = [];
  Map<String, dynamic>? selectedHomework;
  List<UserHomeWork> userHomeworks = [];

  @override
  void initState() {
    super.initState();
    fetchHomeworks();
  }

  Future<void> fetchHomeworks() async {
    final response =
        await http.get(Uri.parse('${api}homework/${widget.classId}'));
    if (response.statusCode == 200) {
      setState(() {
        homeworks = json.decode(response.body);
      });
    } else {
      print("Lỗi khi tải danh sách bài tập");
    }
  }

  Future<void> fetchUserHomeworks(int homeworkId) async {
    final response =
        await http.get(Uri.parse('${api}homework/dto/$homeworkId'));
    if (response.statusCode == 200) {
      setState(() {
        userHomeworks = (json.decode(response.body) as List)
            .map((item) => UserHomeWork.fromJson(item))
            .toList();
      });
      print(response.body);
    } else {
      print("Lỗi khi tải danh sách bài làm của học sinh");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color mainColor = Color(0xFFE57373);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text("Danh sách bài tập"),
      ),
      body: Row(
        children: [
          // Danh sách bài tập bên trái
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: homeworks.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedHomework != null &&
                          selectedHomework!['id'] == homeworks[index]['id'];
                      return ListTile(
                        tileColor:
                            isSelected ? mainColor.withOpacity(0.3) : null,
                        title: Text(homeworks[index]["name"]),
                        onTap: () {
                          setState(() {
                            selectedHomework = homeworks[index];
                          });
                          fetchUserHomeworks(homeworks[index]['id']);
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Chức năng thêm bài tập
                  },
                  child: Text("Thêm Bài Tập"),
                  style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                ),
              ],
            ),
          ),
          // Chi tiết bài tập và danh sách học sinh bên phải
          Expanded(
            flex: 2,
            child: selectedHomework == null
                ? Center(child: Text("Chọn bài tập để xem chi tiết"))
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Câu hỏi:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          selectedHomework!["question"] ?? "Không có câu hỏi",
                          style: TextStyle(fontSize: 16),
                        ),
                        Divider(),
                        Text(
                          "Danh sách bài làm:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: userHomeworks.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  title: Text(
                                      "Học sinh: ${userHomeworks[index].studentId}"),
                                  subtitle: Text(
                                      "Điểm: ${userHomeworks[index].point == 0 ? "0/10" : "${userHomeworks[index].point}/10"}"),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              HomeworkDetailScreen(
                                                  userHomeWork:
                                                      userHomeworks[index]),
                                        ),
                                      );
                                    },
                                    child: const Text("Xem bài tập"),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
