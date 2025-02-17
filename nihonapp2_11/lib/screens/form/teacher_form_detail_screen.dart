import 'dart:convert';
import 'package:duandemo/model/TeacherRegistrationForm.dart';
import 'package:flutter/material.dart';

class TeacherFormDetailScreen extends StatelessWidget {
  final TeacherRegistrationForm form;

  TeacherFormDetailScreen({required this.form});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết giáo viên')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tên: ${form.name}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Email: ${form.email}'),
            Text('SĐT: ${form.phone}'),
            Text('Ngày sinh: ${form.birthDay}'),
            Text('Giới thiệu: ${form.introduce}'),
            Text('Cấp độ: ${form.level_id}'),
            Text('Ngày đăng ký: ${form.regisDay}'),
            SizedBox(height: 20),
            form.proof.isNotEmpty
                ? Image.network(form.proof, height: 200, fit: BoxFit.cover)
                : Text('Không có ảnh minh chứng'),
          ],
        ),
      ),
    );
  }
}
