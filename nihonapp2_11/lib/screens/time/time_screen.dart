import 'dart:convert';
import 'package:duandemo/model/Time.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TimeManagementScreen extends StatefulWidget {
  @override
  _TimeManagementScreenState createState() => _TimeManagementScreenState();
}

class _TimeManagementScreenState extends State<TimeManagementScreen> {
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  List<Time> _times = [];

  @override
  void initState() {
    super.initState();
    _fetchTimes();
  }

  Future<void> _fetchTimes() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/time'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _times = data.map((json) => Time.fromJson(json)).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi tải danh sách thời gian!")),
      );
    }
  }

  Future<void> _addTime() async {
    // Kiểm tra trường ID và Thời gian trống
    if (_idController.text.isEmpty || _timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Yêu cầu điền đầy đủ thông tin")),
      );
      return;
    }

    final newTime =
        Time(id: int.parse(_idController.text), time: _timeController.text);
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/time'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newTime.toJson()),
    );

    if (response.body == 'Tao time moi thanh cong') {
      // Báo thêm thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Thêm thời gian thành công")),
      );
      // Xoá các trường nhập
      _idController.clear();
      _timeController.clear();
      // Load lại danh sách
      _fetchTimes();
    } else if (response.body == 'id da ton tai') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ID đã tồn tại")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Thêm thời gian thất bại!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý Thời gian", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFFE57373),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card bọc 2 TextField cho input
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  children: [
                    TextField(
                      controller: _idController,
                      decoration: InputDecoration(
                        labelText:
                            "Nhập Thứ thời gian (khác với các Id được hiển thị ở dưới)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFFE57373)),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _timeController,
                      decoration: InputDecoration(
                        labelText: "Nhập thời gian",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFFE57373)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _addTime,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE57373), // Flutter 2.0+ => backgroundColor
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("Thêm Thời gian", style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _times.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFFE57373),
                        child: Text(
                          _times[index].id.toString(),
                          style: TextStyle(
                            color: Colors.white, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        _times[index].time,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
