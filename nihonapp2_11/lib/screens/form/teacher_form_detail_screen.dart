import 'dart:convert';
import 'package:duandemo/model/Teacher.dart';
import 'package:duandemo/model/TeacherRegistrationForm.dart';
import 'package:duandemo/screens/email/logIn_to_send_mail.dart';
import 'package:duandemo/service/AuthService.dart';
import 'package:duandemo/word_val.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TeacherFormDetailScreen extends StatelessWidget {
  final TeacherRegistrationForm form;
  final AuthService _authService = AuthService();

  TeacherFormDetailScreen({required this.form});

  Future<void> _regist(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(Wordval().api + 'teacher'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': 0,
          'email': form.email,
          'username': form.name,
          'level_id': form.level_id,
          'sex': true,
          'password': 'giaovienmoi',
          'rePassword': 'giaovienmoi',
          'role_id': 3,
          'type_id': 1,
        }),
      );
      if (response.body == 'Tao thanh cong teacher') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Tạo tài khoản giáo viên mới thành công!"),
              backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.body), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Không thể kết nối tới máy chủ!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteTeacherRequest(BuildContext context, int id) async {
    final String apiUrl = Wordval().api + 'teacherRegistration/${id}';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Xóa thành công!"), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true); // Trả về true khi xóa thành công
      } else {
        print("Lỗi khi xóa: ${response.body}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Xóa thất bại!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Lỗi kết nối API: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Không thể kết nối tới máy chủ!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết giáo viên',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xFFE57373),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: Color(0xFFE57373), size: 30),
                    SizedBox(width: 10),
                    Text(form.name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Divider(),
                detailRow(Icons.email, 'Email', form.email),
                detailRow(Icons.phone, 'Số liên lạc', form.phone),
                detailRow(Icons.cake, 'Ngày sinh', form.birthDay),
                detailRow(Icons.info, 'Giới thiệu', form.introduce),
                detailRow(Icons.school, 'Cấp độ', form.level_id.toString()),
                detailRow(Icons.date_range, 'Ngày đăng ký', form.regisDay),
                SizedBox(height: 20),
                form.proof.isNotEmpty
                    ? Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(form.proof,
                              height: 200, fit: BoxFit.cover),
                        ),
                      )
                    : Center(
                        child: Text('Không có ảnh minh chứng',
                            style: TextStyle(color: Colors.grey))),
                SizedBox(height: 20), // Để thêm khoảng cách dưới ảnh minh chứng

                // Thêm nút Gửi Email
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showLoginToSendMailDialog(context);
                        },
                        child: Text("Gửi Email"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color(0xFFE57373), // Màu nền nút nổi bật
                          foregroundColor: Colors.black, // Màu chữ đen đậm
                          padding: EdgeInsets.symmetric(vertical: 16),
                          minimumSize: Size(200, 50), // Kích thước nút
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _regist(context);
                        },
                        child: Text("Tạo tài khoản giáo viên"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color(0xFFE57373), // Màu nền nút nổi bật
                          foregroundColor: Colors.black, // Màu chữ đen đậm
                          padding: EdgeInsets.symmetric(vertical: 16),
                          minimumSize: Size(200, 50), // Kích thước nút
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 20), // Khoảng cách giữa hai nút
                      ElevatedButton(
                        onPressed: () {
                          _deleteTeacherRequest(context, form.id);
                        },
                        child: Text("Xóa Yêu cầu"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color(0xFFE57373), // Màu nền nút nổi bật
                          foregroundColor: Colors.black, // Màu chữ đen đậm
                          padding: EdgeInsets.symmetric(vertical: 16),
                          minimumSize: Size(200, 50), // Kích thước nút
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFFE57373)),
          SizedBox(width: 10),
          Text('$label: ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(
            child: Text(value,
                style: TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
