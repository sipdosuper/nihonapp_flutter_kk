import 'package:flutter/material.dart';
import 'package:duandemo/model/StudentRegistration.dart';

class StudentRegistrationFormItem extends StatelessWidget {
  final StudentRegistration student;

  StudentRegistrationFormItem({required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              student.nameAndSdt,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Email: ${student.email}"),
            Text("Ngày đăng ký: ${student.regisDay.toLocal()}".split(' ')[0]),
            Text("Lớp học ID: ${student.classRoomId}"),
            if (student.bill.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child:
                    Image.network(student.bill, height: 100, fit: BoxFit.cover),
              ),
          ],
        ),
      ),
    );
  }
}
