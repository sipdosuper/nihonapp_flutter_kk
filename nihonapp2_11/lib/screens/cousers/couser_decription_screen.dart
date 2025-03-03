import 'package:duandemo/model/ClassRoom.dart';
import 'package:duandemo/screens/form/student_registration_form_screen.dart';
import 'package:duandemo/screens/form/student_registration_form_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CourseDescriptionScreen extends StatelessWidget {
  final Classroom classroom;

  const CourseDescriptionScreen({super.key, required this.classroom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gói combo ${classroom.name}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              classroom.name,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cấp độ: ${classroom.level}'),
                  Text('Mô tả: ${classroom.description}'),
                  Text('Số lượng tối đa: ${classroom.slMax}'),
                  Text('Giá: ${classroom.price} VNĐ'),
                  Text('Thời gian học: ${classroom.time}'),
                  Text('Giáo viên: ${classroom.teacher}'),
                  Text(
                      'Bắt đầu: ${DateFormat('dd/MM/yyyy').format(classroom.start)}'),
                  Text(
                      'Kết thúc: ${DateFormat('dd/MM/yyyy').format(classroom.end)}'),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Xem giáo trình',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StudentRegistrationScreen(classRoomId: classroom.id),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Mua combo',
                  style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Xem thêm các khóa học khác',
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
