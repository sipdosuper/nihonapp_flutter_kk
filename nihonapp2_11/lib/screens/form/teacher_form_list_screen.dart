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
  late Future<List<TeacherRegistrationForm>> _TeacherRegistrationForms;

  Future<List<TeacherRegistrationForm>> fetchTeacherRegistrationForms() async {
    final response = await http
        .get(Uri.parse('http://localhost:8080/api/teacherRegistration'));

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      try {
        List<dynamic> data = json.decode(response.body);

        print("Decoded data: ${jsonEncode(data)}"); // In ra dữ liệu để kiểm tra

        return data.map((json) {
          try {
            return TeacherRegistrationForm.fromJson(json);
          } catch (e) {
            print("Error parsing JSON: $json | Error: $e");
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
        print("Error decoding JSON: $e");
        return [];
      }
    } else {
      throw Exception('Failed to load teacher forms');
    }
  }

  @override
  void initState() {
    super.initState();
    _TeacherRegistrationForms = fetchTeacherRegistrationForms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách giáo viên')),
      body: FutureBuilder<List<TeacherRegistrationForm>>(
        future: _TeacherRegistrationForms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có dữ liệu'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final form = snapshot.data![index];
              return Card(
                child: ListTile(
                  title: Text(form.name),
                  subtitle: Text(
                    'Level ID: ${form.level_id} | Ngày ĐK: ${form.regisDay} | WorkingTime ID: ${form.workingTime_id}',
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TeacherFormDetailScreen(form: form),
                        ),
                      );
                    },
                    child: Text('Chi tiết'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
