// lib/screens/course_list_screen.dart
import 'package:duandemo/model/ClassRoom.dart';
import 'package:duandemo/screens/cousers/classRoom_item.dart';
import 'package:duandemo/word_val.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CourseListScreen extends StatefulWidget {
  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  List<Classroom> classrooms = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      final response = await http.get(Uri.parse(Wordval().api + 'classroom'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          classrooms = data.map((json) => Classroom.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (error) {
      print("Error fetching courses: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Khóa học luyện thi")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6, // Tổng cộng 6 cột
                      childAspectRatio: 0.75, // Tỷ lệ chiều rộng / chiều cao
                      crossAxisSpacing: 16, // Khoảng cách ngang giữa các item
                      mainAxisSpacing: 16, // Khoảng cách dọc giữa các item
                    ),
                    itemCount: classrooms.length,
                    itemBuilder: (context, index) {
                      // Để trống 2 cột ngoài bằng cách dùng `Visibility`
                      if (index % 6 < 1 || index % 6 > 4) {
                        return Container(); // Cột rỗng
                      }
                      return ClassroomItem(classroom: classrooms[index]);
                    },
                  );
                },
              ),
            ),
    );
  }
}
