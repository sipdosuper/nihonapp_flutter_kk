import 'package:duandemo/model/ClassRoom.dart';
import 'package:duandemo/screens/form/add_student_form_screen.dart'; // THAY ĐỔI: Import màn hình đăng ký học viên mới
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CourseDescriptionScreen extends StatelessWidget {
  final Classroom classroom;

  const CourseDescriptionScreen({super.key, required this.classroom});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFE57373);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gói combo ${classroom.name}'),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề khóa học
            Text(
              classroom.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            // Card chứa thông tin chi tiết
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.grey[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailRow(
                      icon: Icons.grade,
                      label: 'Cấp độ',
                      value: classroom.level ?? 'N/A',
                    ),
                    const SizedBox(height: 8),
                    DetailRow(
                      icon: Icons.description,
                      label: 'Mô tả',
                      value: classroom.description ?? 'Không có mô tả',
                    ),
                    const SizedBox(height: 8),
                    DetailRow(
                      icon: Icons.people,
                      label: 'Số lượng tối đa',
                      value: classroom.slMax?.toString() ?? 'N/A',
                    ),
                    const SizedBox(height: 8),
                    DetailRow(
                      icon: Icons.attach_money,
                      label: 'Giá',
                      value: '${classroom.price} VNĐ',
                    ),
                    const SizedBox(height: 8),
                    DetailRow(
                      icon: Icons.access_time,
                      label: 'Thời gian học',
                      value: classroom.time ?? '',
                    ),
                    const SizedBox(height: 8),
                    DetailRow(
                      icon: Icons.person,
                      label: 'Giáo viên',
                      value: classroom.teacher ?? 'Không có',
                    ),
                    const SizedBox(height: 8),
                    DetailRow(
                      icon: Icons.date_range,
                      label: 'Bắt đầu',
                      value: DateFormat('dd/MM/yyyy').format(classroom.start),
                    ),
                    const SizedBox(height: 8),
                    DetailRow(
                      icon: Icons.date_range,
                      label: 'Kết thúc',
                      value: DateFormat('dd/MM/yyyy').format(classroom.end),
                    ),
                    const SizedBox(height: 12),
                    // Nút "Xem giáo trình"
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Thêm chức năng xem giáo trình nếu cần
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Xem giáo trình',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Nút "Mua combo"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // THAY ĐỔI: Chuyển qua AddStudentFormScreen thay vì StudentRegistrationScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddStudentFormScreen(
                        classRoomId: classroom.id,
                        className: classroom.name,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Mua combo',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Nút "Xem thêm các khóa học khác" với màu xanh biển nhạt, khi bấm sẽ quay lại CourseListScreen
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightBlue[100],
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Xem thêm các khóa học khác',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget helper để hiển thị từng dòng thông tin với icon
class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
