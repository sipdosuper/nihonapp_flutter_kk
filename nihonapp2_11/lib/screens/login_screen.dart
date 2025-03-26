import 'package:flutter/material.dart';
import 'package:duandemo/service/AuthService.dart';
import 'level_selection_screen.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
import 'admin_dashboard_screen.dart';
import 'package:duandemo/main(chinh).dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  String _errorMessage = '';

  Future<void> _login() async {
  String username = _usernameController.text;
  String password = _passwordController.text;

  int userId = await _authService.signIn(username, password);

  setState(() {
    if (userId != 10) {
      if (userId == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
        );
      } else {
        // Đăng nhập thành công, chuyển sang MainScreen với Level mặc định là N5 (level: 5)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(level: 5)),
        );
      }
    } else {
      _errorMessage =
          'Đăng nhập thất bại. Vui lòng kiểm tra thông tin đăng nhập.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _errorMessage,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.white, // Nền trắng
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                CircleAvatar(
                  radius: 150,
                  backgroundImage: AssetImage('assets/logo.png'),
                ),
                SizedBox(height: 30),
                // Title
                Text(
                  'Chào mừng bạn!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Màu đen
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Vui lòng đăng nhập để tiếp tục !',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                SizedBox(height: 30),
                // Username Input
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Color(0xFFE57373)),
                    labelText: 'Tên đăng nhập',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFFE57373)),
                    ),
                    labelStyle: TextStyle(color: Color(0xFFE57373)),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                // Password Input
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: Color(0xFFE57373)),
                    labelText: 'Mật khẩu',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFFE57373)),
                    ),
                    labelStyle: TextStyle(color: Color(0xFFE57373)),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                // Login Button
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 50.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Color(0xFFE57373), // Màu đỏ nhẹ
                  ),
                  child: Text(
                    'Đăng nhập',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(height: 20),
                // Forgot Password
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen()),
                    );
                  },
                  child: Text(
                    'Quên mật khẩu?',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                // Register
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text(
                    'Đăng ký tài khoản',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
