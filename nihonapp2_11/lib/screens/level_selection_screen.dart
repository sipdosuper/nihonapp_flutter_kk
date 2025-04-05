import 'dart:convert';

import 'package:duandemo/word_val.dart';
import 'package:flutter/material.dart';
import 'package:duandemo/main(chinh).dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LevelSelectionScreen extends StatefulWidget {
  @override
  _LevelSelectionScreenState createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  void _navigateToMainScreen(int level) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Lưu giá trị level vào SharedPreferences với key 'vl'
    await prefs.setInt('vl', level);
    // Gọi API để cập nhật level
    bool updateSuccess = await updateUserLevel(level);
    if (updateSuccess) {
      // Chuyển sang MainScreen nếu API thành công
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(level: level)),
      );
    } else {
      // Hiển thị thông báo lỗi nếu API thất bại
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể cập nhật cấp độ. Vui lòng thử lại.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> updateUserLevel(int level) async {
    try {
      // Lấy email từ SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');

      if (email == null || email.isEmpty) {
        print('Không tìm thấy email trong SharedPreferences');
        return false;
      }

      // URL API
      String updateUrl = Wordval().api + 'user/update';

      // Tạo JSON body
      final Map<String, String> body = {
        'email': email,
        'level_id': level.toString(),
      };

      // Gửi yêu cầu POST
      final response = await http.post(
        Uri.parse(updateUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      // Kiểm tra phản hồi
      if (response.statusCode == 200) {
        print('Cập nhật level thành công: ${response.body}');
        return true;
      } else {
        print(
            'Cập nhật level thất bại: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Lỗi khi gọi API update: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE57373), // Màu đỏ nhạt
        title: Text(
          'Chọn Cấp Độ',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white, // Nền trắng
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildLevelItem('N5', 5, Icons.directions_walk, 'Khởi đầu dễ dàng'),
            _buildLevelItem(
                'N4', 4, Icons.directions_bike, 'Tiến bộ nhanh chóng'),
            _buildLevelItem('N3', 3, Icons.motorcycle, 'Thách thức bắt đầu'),
            _buildLevelItem(
                'N2', 2, Icons.directions_car, 'Vượt qua thử thách'),
            _buildLevelItem('N1', 1, Icons.flight, 'Đạt đến đỉnh cao'),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelItem(
      String title, int level, IconData icon, String subtitle) {
    return GestureDetector(
      onTap: () => _navigateToMainScreen(level),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFE57373), width: 1), // Viền đỏ nhẹ
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Biểu tượng lớn
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFFE57373).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 30,
                color: Color(0xFFE57373),
              ),
            ),
            SizedBox(width: 20),
            // Nội dung tiêu đề và mô tả
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            // Nút điều hướng
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Color(0xFFE57373),
            ),
          ],
        ),
      ),
    );
  }
}
