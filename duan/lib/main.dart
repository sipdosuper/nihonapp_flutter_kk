import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Gọi màn hình đăng nhập


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login to Dashboard App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(), // Khởi động với màn hình đăng nhập
    );
  }
}
