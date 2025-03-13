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
  bool _isLeftPanelExpanded = true; // Điều khiển trạng thái panel trái

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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double leftPanelExpandedWidth = screenWidth * 0.25;
    final double leftPanelCollapsedWidth = 50.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text("Danh sách bài tập"),
      ),
      body: Row(
        children: [
          // Panel bên trái với AnimatedContainer thay đổi chiều rộng
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: _isLeftPanelExpanded ? leftPanelExpandedWidth : leftPanelCollapsedWidth,
            decoration: BoxDecoration(
              color: Color(0xFFFFCDD2), // sắc thái nhạt của màu chủ đạo
              border: Border(
                right: BorderSide(width: 1, color: Colors.grey.shade300),
              ),
            ),
            child: Column(
              children: [
                // Nút thu/mở panel luôn hiển thị
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      _isLeftPanelExpanded ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                      color: mainColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _isLeftPanelExpanded = !_isLeftPanelExpanded;
                      });
                    },
                  ),
                ),
                // Khi panel mở rộng hiển thị danh sách bài tập và nút "Thêm Bài Tập"
                _isLeftPanelExpanded
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: homeworks.length,
                          itemBuilder: (context, index) {
                            bool isSelected = selectedHomework != null &&
                                selectedHomework!['id'] == homeworks[index]['id'];
                            return Container(
                              decoration: BoxDecoration(
                                color: isSelected ? mainColor.withOpacity(0.3) : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: ListTile(
                                title: Text(
                                  homeworks[index]["name"],
                                  style: TextStyle(fontSize: 14), // Kích cỡ chữ nhỏ hơn
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedHomework = homeworks[index];
                                  });
                                  fetchUserHomeworks(homeworks[index]['id']);
                                },
                              ),
                            );
                          },
                        ),
                      )
                    : Container(),
                _isLeftPanelExpanded
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Chức năng thêm bài tập
                          },
                          child: Text("Thêm Bài", style: TextStyle(fontSize: 14)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            foregroundColor: Colors.black, // Màu chữ là đen
                            minimumSize: Size(140, 36), // Đảm bảo đủ rộng & cao để chữ không bị xuống dòng
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          // Panel bên phải chiếm phần còn lại của màn hình
          Expanded(
            child: Container(
              color: Colors.white,
              child: selectedHomework == null
                  ? Center(child: Text("Chọn bài tập để xem chi tiết"))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Câu hỏi:",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            selectedHomework!["question"] ?? "Không có câu hỏi",
                            style: TextStyle(fontSize: 16),
                          ),
                          Divider(),
                          Text(
                            "Danh sách bài làm:",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: userHomeworks.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    title: Text("Học sinh: ${userHomeworks[index].studentId}"),
                                    subtitle: Text(
                                      "Điểm: ${userHomeworks[index].point == 0 ? "0/10" : "${userHomeworks[index].point}/10"}",
                                    ),
                                    trailing: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeworkDetailScreen(
                                                userHomeWork: userHomeworks[index]),
                                          ),
                                        );
                                      },
                                      child: const Text("Xem bài tập"),
                                      style: ElevatedButton.styleFrom(backgroundColor: mainColor),
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
          ),
        ],
      ),
    );
  }
}
