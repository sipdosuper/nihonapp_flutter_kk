import 'dart:convert';
import 'package:duandemo/model/TeacherRegistrationForm.dart';
import 'package:duandemo/screens/email/logIn_to_send_mail.dart';
import 'package:flutter/material.dart';

class TeacherFormDetailScreen extends StatelessWidget {
  final TeacherRegistrationForm form;

  TeacherFormDetailScreen({required this.form});

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
                  child: ElevatedButton(
                    onPressed: () {
                      showLoginToSendMailDialog(context);
                    },
                    child: Text("Gửi Email"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE57373), // Màu nền nút nổi bật
                      foregroundColor: Colors.black, // Màu chữ đen đậm
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(200, 50), // Kích thước nút
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
