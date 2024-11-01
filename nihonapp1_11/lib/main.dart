import 'package:duandemo/screens/level_selection_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Màn hình đăng nhập

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login to Dashboard App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LevelSelectionScreen(), // Khởi động với màn hình đăng nhập
    );
  }
}
