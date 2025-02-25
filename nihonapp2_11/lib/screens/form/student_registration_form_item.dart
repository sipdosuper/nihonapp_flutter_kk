import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:duandemo/model/StudentRegistration.dart';
import 'package:duandemo/screens/form/student_form_detail_screen.dart';
import 'package:intl/intl.dart'; // Import intl để sử dụng DateFormat

class StudentRegistrationFormListScreen extends StatefulWidget {
  @override
  _StudentRegistrationFormListScreenState createState() =>
      _StudentRegistrationFormListScreenState();
}

class _StudentRegistrationFormListScreenState
    extends State<StudentRegistrationFormListScreen> {
  late Future<List<StudentRegistration>> _studentRegistrationForms;

  // Lấy dữ liệu sinh viên từ API
  Future<List<StudentRegistration>> fetchStudentRegistrationForms() async {
    final response = await http
        .get(Uri.parse('http://localhost:8080/api/studentRegistration'));

    if (response.statusCode == 200) {
      try {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) {
          try {
            return StudentRegistration.fromJson(
                json); // Chuyển JSON thành đối tượng StudentRegistration
          } catch (e) {
            print('Error parsing student: $e');
            return StudentRegistration(
                id: 0,
                nameAndSdt: 'Unknown',
                regisDay: DateTime.now(),
                bill: '',
                email: 'Unknown',
                classRoomId: 0,
                bankCheck: false);
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
        title: Text('Danh sách sinh viên',
            style: TextStyle(fontWeight: FontWeight.bold)),
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
              return StudentRegistrationFormItem(student: student);
            },
          );
        },
      ),
    );
  }
}

class StudentRegistrationFormItem extends StatelessWidget {
  final StudentRegistration student;

  StudentRegistrationFormItem({required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              student.nameAndSdt,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Email: ${student.email}"), // Hiển thị email
            Text(
                "Ngày đăng ký: ${DateFormat('yyyy-MM-dd').format(student.regisDay)}"),
            Text("Lớp học ID: ${student.classRoomId}"), // Hiển thị lớp học ID
            if (student.bill.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child:
                    Image.network(student.bill, height: 100, fit: BoxFit.cover),
              ),
            // Thêm nút chuyển đến màn hình chi tiết
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          StudentFormDetailScreen(student: student),
                    ),
                  );
                },
                child: Text('Xem chi tiết'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
