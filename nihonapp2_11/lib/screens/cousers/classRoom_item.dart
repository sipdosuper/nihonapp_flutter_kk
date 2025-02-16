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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              classroom.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              "Ngày bắt đầu: ${classroom.start.toLocal()}".split(' ')[0],
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              "Ngày kết thúc: ${classroom.end.toLocal()}".split(' ')[0],
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              "Số lượng: ${classroom.slMax}",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              "Giá: ${classroom.price} VND",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Chuyển đến màn hình mô tả khóa học
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CourseDescriptionScreen(classroom: classroom),
                      ),
                    );
                  },
                  child: Text("Xem chi tiết"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Thêm logic mua khóa học tại đây
                  },
                  child: Text("Mua ngay"),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
