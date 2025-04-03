import 'package:duandemo/screens/form/teacher_registration_form_delta_screen.dart';
import 'package:flutter/material.dart';
import 'package:duandemo/model/TeacherRegistrationForm.dart';

class TeacherRegistrationFormItem extends StatelessWidget {
  final TeacherRegistrationForm teacher;

  const TeacherRegistrationFormItem({Key? key, required this.teacher})
      : super(key: key);

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
              teacher.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Cấp độ: ${teacher.level_id}"),
            Text("Ngày đăng ký: ${teacher.regisDay}"),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TeacherRegistrationDetailScreen(teacher: teacher),
                    ),
                  );
                },
                child: Text("Xem chi tiết"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
