import 'dart:convert';
import 'package:duandemo/model/TeacherRegistrationForm.dart';
import 'package:duandemo/screens/form/teacher_form_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TeacherRegistrationFormListScreen extends StatefulWidget {
  @override
  _TeacherRegistrationFormListScreenState createState() =>
      _TeacherRegistrationFormListScreenState();
}

class _TeacherRegistrationFormListScreenState
    extends State<TeacherRegistrationFormListScreen> {
  late Future<List<TeacherRegistrationForm>> _teacherRegistrationForms;

  Future<List<TeacherRegistrationForm>> fetchTeacherRegistrationForms() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/teacherRegistration'));

    if (response.statusCode == 200) {
      try {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) {
          try {
            return TeacherRegistrationForm.fromJson(json);
          } catch (e) {
            return TeacherRegistrationForm(
              name: 'Unknown',
              email: 'Unknown',
              phone: 'Unknown',
              birthDay: 'Unknown',
              proof: '',
              introduce: 'Unknown',
              regisDay: 'Unknown',
              level_id: 0,
              workingTime_id: 0,
            );
          }
        }).toList();
      } catch (e) {
        return [];
      }
    } else {
      throw Exception('Failed to load teacher forms');
    }
  }

  @override
  void initState() {
    super.initState();
    _teacherRegistrationForms = fetchTeacherRegistrationForms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách giáo viên', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xFFE57373), // Màu chủ đạo
      ),
      body: FutureBuilder<List<TeacherRegistrationForm>>(
        future: _teacherRegistrationForms,
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
              final form = snapshot.data![index];
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
                            form.name,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Text('Cấp độ: ${form.level_id}'),
                          Text('Ngày ĐK: ${form.regisDay}'),
                          Text('Thời gian làm việc: ${form.workingTime_id}'),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFE57373),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeacherFormDetailScreen(form: form),
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
