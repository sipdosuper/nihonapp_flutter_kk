import 'package:flutter/material.dart';
import 'level_selection_screen.dart'; // Màn hình chọn cấp độ cho người dùng
import 'forgot_password_screen.dart'; // Màn hình quên mật khẩu
import 'register_screen.dart'; // Màn hình đăng ký
import 'admin_dashboard_screen.dart'; // Màn hình quản trị Admin

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Hàm xử lý đăng nhập
  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Điều kiện đăng nhập admin
    if (username == 'admin' && password == '123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AdminDashboardScreen()), // Điều hướng đến màn hình Admin
      );
    }
    // Điều kiện cho người dùng thông thường
    else if (username == 'user' && password == '123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LevelSelectionScreen()), // Điều hướng đến màn hình người dùng
      );
    }
    // Trường hợp đăng nhập thất bại
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng nhập không thành công!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
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
              onPressed: _login,
              child: Text('Đăng nhập'),
            ),
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
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('Đăng ký tài khoản'),
            ),
          ],
        ),
      ),
    );
  }
}
