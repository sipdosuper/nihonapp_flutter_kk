import 'package:flutter/material.dart';
import 'package:duandemo/model/StudentRegistration.dart';

class StudentFormListItem extends StatelessWidget {
  final StudentRegistration student;

  const StudentFormListItem({Key? key, required this.student})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            student.nameAndSdt,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 5),
          Text("Email: ${student.email}", style: TextStyle(fontSize: 16)),
          Text("Ngày đăng ký: ${student.regisDay.toLocal()}".split(' ')[0],
              style: TextStyle(fontSize: 16)),
          Text("Lớp học ID: ${student.classRoomId}",
              style: TextStyle(fontSize: 16)),

          SizedBox(height: 10),

          // Hiển thị hình ảnh bill từ Cloudinary
          student.bill.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hóa đơn:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        student.bill,
                        width: double.infinity,
                        height: 200,
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
                  ],
                )
              : Text("Chưa có hóa đơn",
                  style: TextStyle(fontStyle: FontStyle.italic)),

          SizedBox(height: 12),

          // Nút xác nhận trạng thái
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                color: student.bankCheck
                    ? Colors.green
                    : Colors.red, // Xanh nếu đã xác nhận, đỏ nếu chưa
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  student.bankCheck ? "Đã xác nhận" : "Chưa xác nhận",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
