import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String apiUrl =
      'http://localhost:8080/api/user/signIn'; // Thay bằng API của bạn

  // Hàm đăng nhập
  Future<bool> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Parse response body to get the token
      print(response.body);
      // var jsonResponse = jsonDecode(response.body);
      String? token = parseJwt(response.body);
      // print("json:" + jsonResponse.toString());
      // String token = jsonResponse['sub'];
      print(token);
      // Lưu token vào SharedPreferences
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setString('token', token);

      return true;
    } else {
      return false;
    }
  }

  String? parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    // Giải mã Base64 phần payload
    final payload = base64Url.decode(base64Url.normalize(parts[1]));

    // Chuyển từ JSON thành Map
    final payloadMap = json.decode(utf8.decode(payload));

    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('Invalid payload');
    }

    // Lấy giá trị của 'sub'
    return payloadMap['sub'];
  }

  // Hàm để lấy token từ SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Hàm để kiểm tra xem token có còn hợp lệ không
  Future<bool> isLoggedIn() async {
    String? token = await getToken();
    if (token != null) {
      // Kiểm tra token ở đây nếu cần, ví dụ bằng cách gọi API validate token
      return true;
    } else {
      return false;
    }
  }

  // Hàm để đăng xuất và xoá token
  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
