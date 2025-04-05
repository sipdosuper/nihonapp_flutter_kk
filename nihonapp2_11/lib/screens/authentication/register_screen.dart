import 'package:flutter/material.dart';
import 'package:duandemo/service/AuthService.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  int id = 0;
  String username = '';
  String email = '';
  bool sex = true;
  String password = '';
  String rePassword = '';
  int roleId = 1;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      bool success = await _authService.register(
        id: id,
        email: email,
        username: username,
        lv: 0,
        sex: sex,
        password: password,
        rePassword: rePassword,
        roleId: roleId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Đăng ký thành công!'
                : 'Đăng ký thất bại. Vui lòng thử lại!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: success ? Colors.green : Color(0xFFE57373),
        ),
      );

      if (success) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tạo tài khoản'),
        backgroundColor: Color(0xFFE57373), // Màu đỏ nhẹ cho AppBar
      ),
      body: Container(
        color: Colors.white, // Nền trắng
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'ID',
                  prefixIcon: Icon(Icons.badge, color: Color(0xFFE57373)),
                  labelStyle: TextStyle(color: Color(0xFFE57373)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFE57373)),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Vui lòng nhập ID' : null,
                onChanged: (value) => id = int.tryParse(value) ?? 0,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tên tài khoản',
                  prefixIcon: Icon(Icons.person, color: Color(0xFFE57373)),
                  labelStyle: TextStyle(color: Color(0xFFE57373)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFE57373)),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Vui lòng nhập tên tài khoản'
                    : null,
                onChanged: (value) => username = value,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Color(0xFFE57373)),
                  labelStyle: TextStyle(color: Color(0xFFE57373)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFE57373)),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty
                    ? 'Vui lòng nhập email'
                    : null,
                onChanged: (value) => email = value,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<bool>(
                decoration: InputDecoration(
                  labelText: 'Giới tính',
                  prefixIcon: Icon(Icons.transgender, color: Color(0xFFE57373)),
                  labelStyle: TextStyle(color: Color(0xFFE57373)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFE57373)),
                  ),
                ),
                value: sex,
                items: [
                  DropdownMenuItem(value: true, child: Text('Nam')),
                  DropdownMenuItem(value: false, child: Text('Nữ')),
                ],
                onChanged: (value) => setState(() => sex = value ?? true),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  prefixIcon: Icon(Icons.lock, color: Color(0xFFE57373)),
                  labelStyle: TextStyle(color: Color(0xFFE57373)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFE57373)),
                  ),
                ),
                obscureText: true,
                validator: (value) => value == null || value.length < 6
                    ? 'Mật khẩu phải dài ít nhất 6 ký tự'
                    : null,
                onChanged: (value) => password = value,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nhập lại mật khẩu',
                  prefixIcon:
                      Icon(Icons.lock_outline, color: Color(0xFFE57373)),
                  labelStyle: TextStyle(color: Color(0xFFE57373)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFE57373)),
                  ),
                ),
                obscureText: true,
                validator: (value) => value == null || value != password
                    ? 'Mật khẩu nhập lại không khớp'
                    : null,
                onChanged: (value) => rePassword = value,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Role ID',
                  prefixIcon:
                      Icon(Icons.assignment_ind, color: Color(0xFFE57373)),
                  labelStyle: TextStyle(color: Color(0xFFE57373)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFE57373)),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? 'Vui lòng nhập Role ID'
                    : null,
                onChanged: (value) => roleId = int.tryParse(value) ?? 1,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE57373), // Màu đỏ nhẹ cho nút
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Đăng ký',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
