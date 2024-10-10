import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';

  // Hàm xử lý logic khôi phục mật khẩu (sau này có thể gọi API để xử lý)
  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      // Xử lý logic khôi phục mật khẩu sau khi tích hợp API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã gửi liên kết khôi phục mật khẩu tới email!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quên mật khẩu')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  return null;
                },
                onChanged: (value) {
                  email = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetPassword,
                child: Text('Khôi phục mật khẩu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
