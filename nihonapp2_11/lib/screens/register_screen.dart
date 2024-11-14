import 'package:flutter/material.dart';
import 'package:duandemo/service/AuthService.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  // Các biến lưu thông tin đăng ký
  int id = 0;
  String username = '';
  String email = '';
  bool sex = true;
  String password = '';
  String rePassword = '';
  int roleId = 1;

  // Hàm xử lý logic đăng ký
  void _register() async {
    if (_formKey.currentState!.validate()) {
      // Gọi API đăng ký
      bool success = await _authService.register(
        id: id,
        email: email,
        username: username,
        sex: sex,
        password: password,
        rePassword: rePassword,
        roleId: roleId,
      );

      // Hiển thị thông báo tùy thuộc vào kết quả đăng ký
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thất bại. Vui lòng thử lại!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thành công!')),
        );
        Navigator.pop(
            context); // Quay lại màn hình trước đó hoặc màn hình đăng nhập
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tạo tài khoản')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập ID';
                  }
                  return null;
                },
                onChanged: (value) {
                  id = int.tryParse(value) ?? 0;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Tên tài khoản'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên tài khoản';
                  }
                  return null;
                },
                onChanged: (value) {
                  username = value;
                },
              ),
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
              DropdownButtonFormField<bool>(
                decoration: InputDecoration(labelText: 'Giới tính'),
                value: sex,
                items: [
                  DropdownMenuItem(value: true, child: Text('Nam')),
                  DropdownMenuItem(value: false, child: Text('Nữ')),
                ],
                onChanged: (value) {
                  setState(() {
                    sex = value ?? true;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Mật khẩu phải dài ít nhất 6 ký tự';
                  }
                  return null;
                },
                onChanged: (value) {
                  password = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nhập lại mật khẩu'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value != password) {
                    return 'Mật khẩu nhập lại không khớp';
                  }
                  return null;
                },
                onChanged: (value) {
                  rePassword = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Role ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập Role ID';
                  }
                  return null;
                },
                onChanged: (value) {
                  roleId = int.tryParse(value) ?? 1;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text('Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
