import 'package:flutter/material.dart';
import 'package:duandemo/model/TeacherRegistrationForm.dart';

class TeacherRegistrationDetailScreen extends StatelessWidget {
  final TeacherRegistrationForm teacher;

  const TeacherRegistrationDetailScreen({Key? key, required this.teacher})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chi tiết giáo viên")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tên: ${teacher.name}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Email: ${teacher.email}"),
            Text("Số điện thoại: ${teacher.phone}"),
            Text("Ngày sinh: ${teacher.birthDay}"),
            Text("Giới thiệu: ${teacher.introduce}"),
            Text("Ngày đăng ký: ${teacher.regisDay}"),
            Text("Cấp độ: ${teacher.level_id}"),
            Text("Thời gian làm việc: ${teacher.workingTime_id}"),
            SizedBox(height: 12),

            // Hiển thị hình ảnh minh chứng
            teacher.proof.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Minh chứng:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Image.network(
                        teacher.proof,
                        width: 300,
                        height: 500,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Text("Lỗi tải ảnh");
                        },
                      ),
                    ],
                  )
                : Text("Chưa có minh chứng",
                    style: TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
