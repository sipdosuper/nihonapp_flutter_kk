import 'dart:convert';
import 'package:duandemo/screens/email/sendMail_screen.dart';
import 'package:duandemo/word_val.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<bool> _loginToSendMail(
    String email, String password, BuildContext context) async {
  print("${email}, ${password}");
  final response = await http.post(
    Uri.parse(Wordval().api + 'email/update'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

  if (response.body == "Cập nhật email gửi thành công!") {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Đăng nhập thành công!")),
    );
    return true;
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Đăng nhập thất bại: ${response.body}")),
    );
    return false;
  }
}

void showLoginToSendMailDialog(BuildContext context) {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false, // Không cho phép đóng cửa sổ khi nhấn bên ngoài
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Đăng nhập để gửi email"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Mật khẩu"),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () async {
              bool loginSuccess = await _loginToSendMail(
                emailController.text,
                passwordController.text,
                context,
              );
              if (loginSuccess) {
                Navigator.pop(context); // Đóng hộp thoại
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SendMailScreen()),
                );
              }
            },
            child: Text("Đăng nhập"),
          ),
        ],
      );
    },
  );
}
