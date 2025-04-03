import 'package:flutter/material.dart';
import 'package:duandemo/model/StudentRegistration.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentFormDetailScreen extends StatelessWidget {
  final StudentRegistration student;

  StudentFormDetailScreen({required this.student});

  Future<void> acceptForm(BuildContext context) async {
    final apiUrl = 'http://localhost:8080/api/studentRegistration/addStudent';
    final body = jsonEncode({
      "email": student.email,
      "classRoom_id": student.classRoomId,
      "regisForm_id": student.id
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.body)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gửi email thất bại: ${response.body}')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi: $error')));
    }
  }

  Future<void> deleteForm(BuildContext context) async {
    final apiUrl =
        'http://localhost:8080/api/studentRegistration/${student.id}';
    try {
      final response = await http.delete(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Xóa yêu cầu thành công')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Xóa yêu cầu thất bại')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết sinh viên',
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
                    Text(student.nameAndSdt,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Divider(),
                detailRow(Icons.email, 'Email', student.email.toString()),
                detailRow(Icons.date_range, 'Ngày đăng ký',
                    DateFormat('yyyy-MM-dd').format(student.regisDay)),
                detailRow(
                    Icons.class_, 'Lớp học ID', student.classRoomId.toString()),
                detailRow(
                    Icons.attach_money,
                    'Hóa đơn',
                    student.bill.isNotEmpty
                        ? student.bill
                        : 'Không có hóa đơn'),
                SizedBox(height: 20),
                if (student.bill.isNotEmpty &&
                    Uri.tryParse(student.bill)?.hasAbsolutePath == true)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        student.bill,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Text("Không thể tải ảnh",
                              style: TextStyle(color: Colors.red));
                        },
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () => acceptForm(context),
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
                      SizedBox(height: 20), // Khoảng cách giữa hai nút
                      ElevatedButton(
                        onPressed: () => deleteForm(context),
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
