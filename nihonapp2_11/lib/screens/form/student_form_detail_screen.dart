import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:duandemo/model/StudentRegistration.dart';

class StudentFormDetailScreen extends StatelessWidget {
  final StudentRegistration form;

  StudentFormDetailScreen({required this.form});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết học viên', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xFFE57373),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: Color(0xFFE57373), size: 30),
                    SizedBox(width: 10),
                    Text(form.nameAndSdt,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Divider(),
                detailRow(Icons.email, 'Email', form.email),
                detailRow(Icons.phone, 'SĐT', form.nameAndSdt),
                detailRow(Icons.date_range, 'Ngày đăng ký', form.regisDay.toIso8601String()),
                detailRow(Icons.receipt, 'Hóa đơn', form.bill),
                detailRow(Icons.class_, 'Mã lớp', form.classRoomId.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFFE57373)),
          SizedBox(width: 10),
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
