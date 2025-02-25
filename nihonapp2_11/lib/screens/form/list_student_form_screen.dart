import 'dart:convert';
import 'package:duandemo/screens/form/student_form_item.dart';
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
  late Future<List<StudentRegistration>> _studentRegistrations;
  String _filterStatus = ""; // Biến tạm lưu trạng thái lọc

  Future<List<StudentRegistration>> fetchStudentRegistrations() async {
    final response = await http
        .get(Uri.parse('http://localhost:8080/api/studentRegistration'));

    if (response.statusCode == 200) {
      try {
        List<dynamic> data = json.decode(response.body);
        List<StudentRegistration> students =
            data.map((json) => StudentRegistration.fromJson(json)).toList();

        // Áp dụng bộ lọc theo _filterStatus
        if (_filterStatus == "1") {
          students = students.where((s) => s.bankCheck == true).toList();
        } else if (_filterStatus == "2") {
          students = students.where((s) => s.bankCheck == false).toList();
        }
        return students;
      } catch (e) {
        print("Lỗi parse JSON: $e");
        return [];
      }
    } else {
      throw Exception("Lỗi khi tải danh sách sinh viên");
    }
  }

  @override
  void initState() {
    super.initState();
    _studentRegistrations = fetchStudentRegistrations();
  }

  void _updateFilter(String status) {
    setState(() {
      _filterStatus = status;
      _studentRegistrations = fetchStudentRegistrations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách đăng ký sinh viên'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _updateFilter("1"),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text("Đã thanh toán"),
                ),
                ElevatedButton(
                  onPressed: () => _updateFilter("2"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Chưa thanh toán"),
                ),
                ElevatedButton(
                  onPressed: () => _updateFilter(""),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: Text("Tất cả"),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<StudentRegistration>>(
              future: _studentRegistrations,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Không có dữ liệu sinh viên.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final student = snapshot.data![index];
                    return StudentFormListItem(student: student);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
