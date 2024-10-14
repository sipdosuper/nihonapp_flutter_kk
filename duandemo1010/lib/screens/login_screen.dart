import 'package:duandemo/screens/CreateTopicScreen.dart';
import 'package:duandemo/screens/screentopic.dart';
import 'package:duandemo/screens/topic_screen.dart';
import 'package:flutter/material.dart';
import 'level_selection_screen.dart'; // Đảm bảo đường dẫn đúng
import 'register_screen.dart'; // Thêm màn hình Tạo tài khoản
import 'forgot_password_screen.dart'; // Thêm màn hình Quên mật khẩu

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng Nhập'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Tên đăng nhập'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Kiểm tra thông tin đăng nhập
                if (_usernameController.text == 'admin' &&
                    _passwordController.text == '123') {
                  // Chuyển sang màn hình chọn level
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LevelSelectionScreen()),
                  );
                } else {
                  // Hiển thị thông báo đăng nhập thất bại
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Thông tin đăng nhập không đúng!')),
                  );
                }
              },
              child: Text('Đăng Nhập'),
            ),
            SizedBox(height: 10),
            // Nút tạo tài khoản
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('Tạo tài khoản'),
            ),
            // Nút quên mật khẩu
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ForgotPasswordScreen()),
                );
              },
              child: Text('Quên mật khẩu?'),
            ),
          ],
        ),
      ),
    );
  }
}
