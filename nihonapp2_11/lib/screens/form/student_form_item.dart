import 'package:flutter/material.dart';
import 'package:duandemo/model/StudentRegistration.dart';
import 'package:duandemo/screens/form/student_form_detail_screen.dart';

class StudentFormListItem extends StatelessWidget {
  final StudentRegistration student;

  const StudentFormListItem({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = student.regisDay != null
        ? student.regisDay.toLocal().toString().split(' ')[0]
        : 'Ngày không hợp lệ';

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
          Text("Ngày đăng ký: $formattedDate", style: TextStyle(fontSize: 16)),
          Text("Lớp học ID: ${student.classRoomId}", style: TextStyle(fontSize: 16)),

          SizedBox(height: 10),

          // Loại bỏ phần hiển thị hóa đơn (bill) ở đây

          // Nút xác nhận trạng thái
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                color: student.bankCheck ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  student.bankCheck ? "Đã xác nhận" : "Chưa xác nhận",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          // Nút chi tiết
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentFormDetailScreen(student: student),
                  ),
                );
              },
              child: Text('Xem chi tiết'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE57373),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}