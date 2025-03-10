import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:duandemo/model/HomeWork.dart';
import 'package:duandemo/word_val.dart';

class AddHomeWorkScreen extends StatefulWidget {
  final int classRoomId;
  AddHomeWorkScreen({required this.classRoomId});
  @override
  _AddHomeWorkScreenState createState() =>
      _AddHomeWorkScreenState(classRoomId: classRoomId);
}

class _AddHomeWorkScreenState extends State<AddHomeWorkScreen> {
  final int classRoomId;
  _AddHomeWorkScreenState({required this.classRoomId});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  int? _selectedClassRoomId;
  bool _isLoading = false;

  Future<void> _submitHomeWork() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    HomeWork homework = HomeWork(
      id: 0,
      name: _nameController.text,
      question: _questionController.text,
      classRoomId: classRoomId,
      userHomeWorks: [],
    );

    final response = await http.post(
      Uri.parse(Wordval().api + "homework"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(homework.toJson()),
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Thêm bài tập thành công!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm Bài Tập"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Tên bài tập"),
                validator: (value) =>
                    value!.isEmpty ? "Nhập tên bài tập" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(labelText: "Câu hỏi"),
                validator: (value) => value!.isEmpty ? "Nhập câu hỏi" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitHomeWork,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Thêm bài tập"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
