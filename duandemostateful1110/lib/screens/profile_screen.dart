import 'package:flutter/material.dart';
import 'login_screen.dart'; // Đảm bảo đường dẫn đúng

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông Tin Cá Nhân'),
        automaticallyImplyLeading: false, // Ẩn nút quay lại
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Xử lý thông báo
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Chưa có thông báo mới!')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh đại diện
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Thay thế bằng URL hình ảnh thật
              ),
            ),
            SizedBox(height: 16),
            // Tên tài khoản
            Text(
              'Tên tài khoản: admin',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Email
            Text(
              'Email: admin@example.com',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            // Tiến độ học
            Text(
              'Tiến độ học: 75%', // Bạn có thể thay đổi giá trị này theo tiến độ thực tế
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            // Nút cập nhật thông tin
            ElevatedButton(
              onPressed: () {
                // Hiển thị thông báo cập nhật thông tin chưa được triển khai
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Chức năng cập nhật thông tin chưa được triển khai!')),
                );
              },
              child: Text('Cập nhật thông tin'),
            ),
            SizedBox(height: 10),
            // Nút đăng xuất
            ElevatedButton(
              onPressed: () {
                // Đăng xuất và xóa toàn bộ stack màn hình, quay về màn hình đăng nhập
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false, // Xóa tất cả các route trước đó
                );
              },
              child: Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }
}
