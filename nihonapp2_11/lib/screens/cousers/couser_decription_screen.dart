import 'package:duandemo/model/ClassRoom.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CourseDescriptionScreen extends StatelessWidget {
  final Classroom classroom;

  const CourseDescriptionScreen({super.key, required this.classroom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gói combo ${classroom.name}')),
      body: Padding(
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
                  Text('Thời gian: ${classroom.time}'),
                  Text('Số lượng tối đa: ${classroom.slMax}'),
                  Text(
                      'Bắt đầu: ${DateFormat('dd/MM/yyyy').format(classroom.start)}'),
                  Text(
                      'Kết thúc: ${DateFormat('dd/MM/yyyy').format(classroom.end)}'),
                  Text('Giáo viên: ${classroom.teacher}'),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Xem chi tiết',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ý kiến học viên',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const Divider(),
            Text(classroom.description),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
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
