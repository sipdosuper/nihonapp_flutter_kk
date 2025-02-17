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
      appBar: AppBar(title: Text("Danh sách khóa học")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : classrooms.isEmpty
              ? Center(child: Text("Không có khóa học nào!"))
              : GridView.builder(
                  padding: EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: classrooms.length,
                  itemBuilder: (context, index) {
                    return ClassroomItem(classroom: classrooms[index]);
                  },
                ),
    );
  }
}
