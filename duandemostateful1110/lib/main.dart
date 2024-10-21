import 'package:duandemo/screens/LoginPage.dart';
import 'package:duandemo/screens/WordChainGame.dart';
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
      title: 'Login to Dashboard App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: LoginScreen(), // Khởi động với màn hình đăng nhập
      // home: LoginPage(),
      home: WordChainGame(),
    );
  }
}
