import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:duandemo/model/SendMail.dart';
import 'package:duandemo/word_val.dart';

class SendMailScreen extends StatefulWidget {
  @override
  _SendMailScreenState createState() => _SendMailScreenState();
}

class _SendMailScreenState extends State<SendMailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  
  bool _isLoading = false;

  Future<void> _submitSendMail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Tạo object SendMail từ dữ liệu form
    SendMail sendMail = SendMail(
      from: _fromController.text,
      to: _toController.text,
      subject: _subjectController.text,
      text: _textController.text,
    );

    try {
      final response = await http.post(
        // Gọi đúng endpoint: /api/email/send
        Uri.parse(Wordval().api + "email/send"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(sendMail.toJson()),
      );

      setState(() => _isLoading = false);

      // Nếu thành công (status code 200 hoặc 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Gửi mail thành công!",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      } else {
        // Nếu có lỗi từ server, hiển thị nội dung
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi: ${response.body}")),
        );
      }
    } catch (error) {
      // Bắt lỗi kết nối, timeout, v.v.
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFFE57373);
    return Scaffold(
      appBar: AppBar(
        title: Text("Gửi Mail"),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Nhập email người gửi
                TextFormField(
                  controller: _fromController,
                  decoration: InputDecoration(
                    labelText: "Từ (Email người gửi)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Nhập email người gửi" : null,
                ),
                SizedBox(height: 16),
                // Nhập email người nhận
                TextFormField(
                  controller: _toController,
                  decoration: InputDecoration(
                    labelText: "Đến (Email người nhận)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Nhập email người nhận" : null,
                ),
                SizedBox(height: 16),
                // Nhập tiêu đề email
                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    labelText: "Tiêu đề",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Nhập tiêu đề" : null,
                ),
                SizedBox(height: 16),
                // Nhập nội dung email
                TextFormField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: "Nội dung",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Nhập nội dung" : null,
                  maxLines: 5,
                ),
                SizedBox(height: 24),
                // Button gửi mail
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitSendMail,
                    child: _isLoading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black87),
                          )
                        : Text("Gửi Mail"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.black87,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
