import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:duandemo/model/StudentRegistration.dart';
import 'package:duandemo/screens/form/student_form_detail_screen.dart';
import 'package:intl/intl.dart'; // Import intl để sử dụng DateFormat

class StudentRegistrationListScreen extends StatefulWidget {
  @override
  _StudentRegistrationFormListScreenState createState() =>
      _StudentRegistrationFormListScreenState();
}

class _StudentRegistrationFormListScreenState
    extends State<StudentRegistrationListScreen> {
  late Future<List<StudentRegistration>> _studentRegistrationForms;

  // Lấy dữ liệu sinh viên từ API
  Future<List<StudentRegistration>> fetchStudentRegistrationForms() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/studentRegistration'));

    if (response.statusCode == 200) {
      try {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) {
          try {
            return StudentRegistration.fromJson(json); // Chuyển JSON thành đối tượng StudentRegistration
          } catch (e) {
            print('Error parsing student: $e');
            return StudentRegistration(
              nameAndSdt: 'Unknown',
              regisDay: DateTime.now(),
              bill: '',
              email: 'Unknown',
              classRoomId: 0,
            );
          }
        }).toList();
      } catch (e) {
        print('Error decoding JSON: $e');
        return [];
      }
    } else {
      throw Exception('Failed to load student forms');
    }
  }

  @override
  void initState() {
    super.initState();
    _studentRegistrationForms = fetchStudentRegistrationForms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách sinh viên', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xFFE57373), // Màu chủ đạo
      ),
      body: FutureBuilder<List<StudentRegistration>>(
        future: _studentRegistrationForms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có dữ liệu'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final student = snapshot.data![index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: Offset(2, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.nameAndSdt,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Text('Email: ${student.email}'),
                          // Hiển thị ngày đăng ký trong định dạng yyyy-MM-dd
                          Text("Ngày đăng ký: ${DateFormat('yyyy-MM-dd').format(student.regisDay)}"),
                          Text('Lớp học ID: ${student.classRoomId}'),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFE57373),  // Sử dụng màu chủ đạo cho nút
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentFormDetailScreen(student: student),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
