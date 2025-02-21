import 'dart:convert';
import 'package:duandemo/screens/form/student_registration_form_item.dart';
import 'package:duandemo/word_val.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:duandemo/model/StudentRegistration.dart';

class StudentRegistrationListScreen extends StatefulWidget {
  @override
  _StudentRegistrationListScreenState createState() =>
      _StudentRegistrationListScreenState();
}

class _StudentRegistrationListScreenState
    extends State<StudentRegistrationListScreen> {
  List<StudentRegistration> studentList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudentRegistrations();
  }

  Future<void> fetchStudentRegistrations() async {
    try {
      final response =
          await http.get(Uri.parse(Wordval().api + 'studentRegistration'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          studentList =
              data.map((json) => StudentRegistration.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load student registrations');
      }
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách học viên đăng ký')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : studentList.isEmpty
              ? Center(child: Text('Không có học viên nào đăng ký'))
              : ListView.builder(
                  itemCount: studentList.length,
                  itemBuilder: (context, index) {
                    return StudentRegistrationFormItem(
                        student: studentList[index]);
                  },
                ),
    );
  }
}
