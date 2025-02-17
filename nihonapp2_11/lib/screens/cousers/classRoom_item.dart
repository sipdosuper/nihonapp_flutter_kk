import 'package:duandemo/screens/cousers/couser_decription_screen.dart';
import 'package:flutter/material.dart';
import 'package:duandemo/model/ClassRoom.dart';

class ClassroomItem extends StatelessWidget {
  final Classroom classroom;

  ClassroomItem({required this.classroom});

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
              classroom.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Cấp độ: ${classroom.level}"),
            Text("Giá: ${classroom.price} VNĐ"),
            Text("Giáo viên: ${classroom.teacher}"),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CourseDescriptionScreen(classroom: classroom),
                    ),
                  );
                },
                child: Text("Chi tiết"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
