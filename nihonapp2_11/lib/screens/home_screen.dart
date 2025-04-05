import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String level;

  HomeScreen({required this.level}); // Tham số bắt buộc

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Màn hình chính - Level: ${widget.level}'), // Sử dụng widget.level để truy cập giá trị
        automaticallyImplyLeading: false, // Ẩn nút quay lại
      ),
      body: Center(
        child: Text('Chào mừng đến với màn hình chính!'),
      ),
    );
  }
}
