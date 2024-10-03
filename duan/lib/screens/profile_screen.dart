import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  // Fake data for demonstration
  final String userId = '001'; // User ID
  final String username = 'Trần Duy Khánh'; // User's name
  final int lessonsLearned = 1; // Number of lessons learned
  final String status = 'Đang học'; // Status of learning

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin cá nhân'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://example.com/profile_picture.png', // Add a placeholder image URL
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                username,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),

            // User ID
            Text(
              'ID người dùng: $userId',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),

            // User's name
            Text(
              'Tên tài khoản: $username',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),

            // Lessons learned
            Text(
              'Số bài học đã học: $lessonsLearned',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),

            // Learning status
            Text(
              'Trạng thái: $status',
              style: TextStyle(fontSize: 18, color: Colors.blue),
            ),
            SizedBox(height: 30),

            // Future buttons, for example, updating profile or logging out
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // You can add a function here
                },
                child: Text('Cập nhật thông tin'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
