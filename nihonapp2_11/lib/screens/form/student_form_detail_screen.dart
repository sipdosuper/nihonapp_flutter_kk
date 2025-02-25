import 'package:flutter/material.dart';
import 'package:duandemo/model/StudentRegistration.dart';
import 'package:intl/intl.dart'; // Đảm bảo bạn đã import intl

class StudentFormDetailScreen extends StatelessWidget {
  final StudentRegistration student;

  StudentFormDetailScreen({required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết sinh viên',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xFFE57373), // Màu chủ đạo
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
                // Hiển thị các thông tin chi tiết
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
                SizedBox(height: 20), // Khoảng cách dưới ảnh hóa đơn

                // Nếu bill là URL của hình ảnh, hiển thị hình ảnh
                if (student.bill.isNotEmpty &&
                    Uri.tryParse(student.bill)?.hasAbsolutePath == true)
                  Image.network(student.bill,
                      height: 200, width: double.infinity, fit: BoxFit.cover),

                SizedBox(height: 20), // Khoảng cách dưới hình ảnh hóa đơn

                // Thêm nút Gửi Email
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Chức năng gửi email sẽ được thêm sau
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Chức năng gửi sẽ có sau")),
                      );
                    },
                    child: Text("Gửi"),
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

  // Hàm chi tiết cho mỗi dòng (row)
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
