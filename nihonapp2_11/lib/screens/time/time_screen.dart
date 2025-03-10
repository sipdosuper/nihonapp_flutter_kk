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
    if (_timeController.text.isEmpty) return;
    final newTime =
        Time(id: int.parse(_idController.text), time: _timeController.text);
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/time'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newTime.toJson()),
    );
    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   _timeController.clear();
    //   _fetchTimes();
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Thêm thời gian thất bại!")),
    //   );
    // }
    if (response.body == 'Tao time moi thanh cong') {
      _timeController.clear();
      _fetchTimes();
    } else if (response.body == 'id da ton tai') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("id da ton tai")),
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
      appBar: AppBar(title: Text("Quản lý Thời gian")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText:
                    "Nhập Thứ thời gian(khác với các Id được hiển thị ở dưới)",
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: "Nhập thời gian",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addTime,
              child: Text("Thêm Thời gian"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _times.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      // Hiển thị ID trong một ô tròn
                      backgroundColor: Colors.redAccent,
                      child: Text(
                        _times[index].id.toString(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(_times[index].time),
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
