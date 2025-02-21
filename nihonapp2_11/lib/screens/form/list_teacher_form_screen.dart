import 'dart:convert';
import 'package:duandemo/screens/form/teacher_form_item.dart';
import 'package:duandemo/word_val.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:duandemo/model/TeacherRegistrationForm.dart';

class TeacherRegistrationListScreen extends StatefulWidget {
  @override
  _TeacherRegistrationListScreenState createState() =>
      _TeacherRegistrationListScreenState();
}

class _TeacherRegistrationListScreenState
    extends State<TeacherRegistrationListScreen> {
  List<TeacherRegistrationForm> teacherList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTeacherRegistrations();
  }

  Future<void> fetchTeacherRegistrations() async {
    try {
      final response =
          await http.get(Uri.parse(Wordval().api + 'teacherRegistration'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          teacherList = data
              .map((json) => TeacherRegistrationForm.fromJson(json))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load teacher registrations');
      }
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách giáo viên đăng ký')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : teacherList.isEmpty
              ? Center(child: Text('Không có giáo viên nào đăng ký'))
              : ListView.builder(
                  itemCount: teacherList.length,
                  itemBuilder: (context, index) {
                    return TeacherRegistrationFormItem(
                        teacher: teacherList[index]);
                  },
                ),
    );
  }
}
