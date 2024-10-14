import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String level;

  HomeScreen({required this.level}); // Tham số bắt buộc

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Màn hình chính - Level: $level'),
        automaticallyImplyLeading: false, // Ẩn nút quay lại
      ),
      body: Center(
        child: Text('Chào mừng đến với màn hình chính!'),
      ),
    );
  }
}
