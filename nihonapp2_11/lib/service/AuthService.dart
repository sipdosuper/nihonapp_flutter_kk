import 'dart:convert';
import 'package:duandemo/word_val.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String signInUrl = Wordval().api + 'user/signIn';
  final String registerUrl = Wordval().api + 'user'; // URL đăng ký

  // Hàm đăng nhập
  Future<int> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse(signInUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      print(response.body);

      // Lấy token từ phản hồi
      String? token = parseJwt(response.body);
      print("Token: $token");
      Map<String, dynamic>? jsonPayload = getJsonFromToken(response.body);
      print("Payload JSON: $jsonPayload");

      if (jsonPayload != null) {
        Map<String, dynamic>? userJson = getUserFromJsonPayload(jsonPayload);
        print("Thông tin user: $userJson");

        if (userJson != null) {
          print('Role: ${userJson['role']}');
          print('Email: ${userJson['email']}');
          print('Username: ${userJson['username']}');

          // Lưu thông tin người dùng vào SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token ?? '');
          await prefs.setString('email', userJson['email']);
          await prefs.setString('username', userJson['username']);
          await prefs.setInt("vl", userJson['lv']);

          return userJson['role'];
        } else {
          print('Không thể lấy thông tin user.');
        }
      }
    } else {
      print('Đăng nhập thất bại: ${response.body}');
    }
    // Trả về 10 trong trường hợp bất kỳ lỗi nào
    return 10;
  }

  // Hàm đăng ký tài khoản
  Future<bool> register({
    required int id,
    required String email,
    required String username,
    required int lv,
    required bool sex,
    required String password,
    required String rePassword,
    required int roleId,
  }) async {
    final response = await http.post(
      Uri.parse(registerUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'email': email,
        'username': username,
        'level_id': lv,
        'sex': sex,
        'password': password,
        'rePassword': rePassword,
        'role_id': roleId,
      }),
    );

    // Kiểm tra phản hồi từ server
    if (response.statusCode == 201) {
      // 201 Created
      print('Đăng ký thành công');
      return true;
    } else {
      print('Đăng ký thất bại: ${response.body}');
      return false;
    }
  }

  /// Hàm lấy thông tin user từ jsonPayload
  Map<String, dynamic>? getUserFromJsonPayload(
      Map<String, dynamic> jsonPayload) {
    try {
      // Lấy chuỗi 'sub' từ jsonPayload
      final String? userJsonString = jsonPayload['sub']?.toString();
      if (userJsonString == null || userJsonString.isEmpty) {
        print('Chuỗi sub rỗng hoặc không tồn tại');
        return null;
      }

      print("Chuỗi gốc: $userJsonString");

      // Chuẩn hóa chuỗi thành JSON hợp lệ
      String normalizedJson = userJsonString;

      // Thay thế '=' thành ':' để giống cú pháp JSON
      normalizedJson = normalizedJson.replaceAll('=', ':');

      // Thêm dấu ngoặc nhọn nếu chưa có
      if (!normalizedJson.startsWith('{')) {
        normalizedJson = '{' + normalizedJson + '}';
      }

      // Thêm dấu nháy kép quanh key
      normalizedJson = normalizedJson.replaceAllMapped(RegExp(r'([^{,\s]+)(:)'),
          (match) => '"${match.group(1)}"${match.group(2)}');

      // Thêm dấu nháy kép quanh value, trừ số, boolean, null
      normalizedJson = normalizedJson
          .replaceAllMapped(RegExp(r'(:)\s*([^,{}]+)([,\}])'), (match) {
        String value = match.group(2)!.trim();
        // Nếu giá trị là số, boolean hoặc null, giữ nguyên
        if (RegExp(r'^-?\d+(\.\d+)?$').hasMatch(value) ||
            value == 'true' ||
            value == 'false' ||
            value == 'null') {
          return '${match.group(1)}$value${match.group(3)}';
        }
        // Nếu không, thêm dấu nháy kép (bao gồm cả chuỗi có khoảng trắng)
        return '${match.group(1)}"$value"${match.group(3)}';
      });

      print("Chuỗi JSON đã chuẩn hóa: $normalizedJson");

      // Decode chuỗi thành Map<String, dynamic>
      final Map<String, dynamic> userJson = json.decode(normalizedJson);
      print("userJson: ${userJson.toString()}");

      return userJson;
    } catch (e) {
      print('Lỗi khi lấy thông tin user: $e');
      return null;
    }
  }

  Map<String, dynamic>? getJsonFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Token không hợp lệ');
      }

      final payload = parts[1];
      final normalizedPayload = base64Url.normalize(payload);
      final decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));

      return json.decode(decodedPayload);
    } catch (e) {
      print('Lỗi khi giải mã token: $e');
      return null;
    }
  }

  String? parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = base64Url.decode(base64Url.normalize(parts[1]));
    final payloadMap = json.decode(utf8.decode(payload));

    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('Invalid payload');
    }

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
    return token != null;
  }

  // Hàm để đăng xuất và xoá token
  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    await prefs.remove('username');
  }
}
