import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:duandemo/model/TeacherRegistrationForm.dart';
import 'package:duandemo/service/CloudinaryService.dart';
import 'package:duandemo/word_val.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

class AddTeacherFormScreen extends StatefulWidget {
  @override
  _AddTeacherFormScreenState createState() => _AddTeacherFormScreenState();
}

class _AddTeacherFormScreenState extends State<AddTeacherFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _birthDayController = TextEditingController();

  String name = "", email = "", phone = "", introduce = "";
  String birthDay = "";
  String regisDay = DateFormat('yyyy-MM-dd').format(DateTime.now());
  int level_id = 1, workingTime_id = 1;
  String? proofUrl = "";
  File? _imageFile;
  Uint8List? _imageBytes;
  bool _isUploading = false;
  bool _isImageSelected = false;
  bool _isImageUploaded = false;

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final input = html.FileUploadInputElement()..accept = 'image/*';
      input.click();
      input.onChange.listen((_) {
        final file = input.files!.first;
        final reader = html.FileReader()..readAsArrayBuffer(file);
        reader.onLoadEnd.listen((_) {
          setState(() {
            _imageBytes = reader.result as Uint8List;
            _imageFile = null;
            _isImageSelected = true; // Đánh dấu ảnh đã được chọn
          });
        });
      });
    } else {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _imageBytes = null;
          _isImageSelected = true; // Đánh dấu ảnh đã được chọn
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null && _imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng chọn ảnh trước!")),
      );
      return;
    }

    setState(() => _isUploading = true);
    final url = await CloudinaryService.uploadImage(_imageFile, _imageBytes);
    setState(() {
      proofUrl = url;
      _isUploading = false;
      _isImageUploaded = true; // Đánh dấu ảnh đã được upload thành công
    });

    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload ảnh thất bại!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ảnh đã được tải lên thành công!")),
      );
    }
  }

  Future<void> _selectBirthDay() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        birthDay = DateFormat('yyyy-MM-dd').format(picked);
        _birthDayController.text = birthDay;
      });
    }
  }

  Future<void> _submitForm() async {
    // Kiểm tra nếu các trường thông tin không hợp lệ
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng điền đầy đủ thông tin!")),
      );
      return;
    }

    // Kiểm tra nếu chưa chọn ảnh và upload ảnh
    if (_imageFile == null && _imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng chọn ảnh và upload ảnh!")),
      );
      return;
    }

    // Kiểm tra nếu ảnh đã chọn nhưng chưa upload
    if (proofUrl == null && (_imageFile != null || _imageBytes != null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng upload ảnh!")),
      );
      return;
    }

    final newTeacher = TeacherRegistrationForm(
      id: 0,
      name: name,
      email: email,
      phone: phone,
      birthDay: birthDay,
      proof: proofUrl!,
      introduce: introduce,
      regisDay: regisDay,
      level_id: level_id,
      workingTime_id: workingTime_id,
    );

    final response = await http.post(
        Uri.parse(Wordval().api + "teacherRegistration"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(newTeacher.toJson()));

    // Kiểm tra phản hồi từ API
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Thêm giáo viên thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Thêm giáo viên thành công!")),
      );
      Navigator.pop(context); // Quay lại màn hình trước
    } else {
      // Hiển thị lỗi nếu thêm thất bại
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Thêm AppBar với màu đỏ nhạt làm chủ đạo
      appBar: AppBar(
        title: Text("Đăng ký giáo viên", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[200],
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.red[50],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Gộp tất cả trường nhập vào trong 1 Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Đổi bo góc
                ),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Tên giáo viên
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Tên giáo viên",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Vui lòng nhập tên" : null,
                        onChanged: (value) => name = value,
                      ),
                      SizedBox(height: 12),
                      // Email
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Vui lòng nhập email" : null,
                        onChanged: (value) => email = value,
                      ),
                      SizedBox(height: 12),
                      // Mô tả
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Mô tả",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Vui lòng nhập mô tả" : null,
                        onChanged: (value) => introduce = value,
                      ),
                      SizedBox(height: 12),
                      // Số điện thoại
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Số điện thoại",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                        ),
                        validator: (value) => value!.isEmpty
                            ? "Vui lòng nhập số điện thoại"
                            : null,
                        onChanged: (value) => phone = value,
                      ),
                      SizedBox(height: 12),
                      // Ngày sinh
                      TextFormField(
                        controller: _birthDayController,
                        decoration: InputDecoration(
                          labelText: "Ngày sinh",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                        ),
                        readOnly: true,
                        onTap: _selectBirthDay,
                        validator: (value) =>
                            value!.isEmpty ? "Vui lòng chọn ngày sinh" : null,
                      ),
                      SizedBox(height: 12),
                      // Chọn cấp độ
                      DropdownButtonFormField<int>(
                        value: level_id,
                        decoration: InputDecoration(
                          labelText: "Chọn cấp độ",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                        ),
                        items: List.generate(5, (index) => index + 1)
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text("N$e")))
                            .toList(),
                        onChanged: (value) => setState(() => level_id = value!),
                      ),
                      SizedBox(height: 12),
                      // Chọn thời gian làm việc
                      DropdownButtonFormField<int>(
                        value: workingTime_id,
                        decoration: InputDecoration(
                          labelText: "Chọn thời gian làm việc",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                        ),
                        items: List.generate(5, (index) => index + 1)
                            .map((e) => DropdownMenuItem(
                                value: e, child: Text("Ca $e")))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => workingTime_id = value!),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Hiển thị ảnh (nếu có)
              _isImageUploaded
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(proofUrl!,
                          width: 200, height: 200, fit: BoxFit.cover),
                    )
                  : _imageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(_imageBytes!,
                              width: 200, height: 200, fit: BoxFit.cover),
                        )
                      : _imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(_imageFile!,
                                  width: 200, height: 200, fit: BoxFit.cover),
                            )
                          : Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Icon(Icons.image,
                                    size: 50, color: Colors.redAccent),
                              ),
                            ),
              SizedBox(height: 10),
              // Button chọn ảnh
              ElevatedButton(
                onPressed: _pickImage,
                child: Text("Chọn ảnh"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              SizedBox(height: 10),
              // Button upload ảnh (hiển thị khi có ảnh được chọn)
              if (_isImageSelected)
                ElevatedButton(
                  onPressed: _isUploading ? null : _uploadImage,
                  child: _isUploading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text("Upload ảnh"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              SizedBox(height: 20),
              // Button submit form (hiển thị khi ảnh đã được upload thành công)
              if (_isImageUploaded)
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Thêm giáo viên"),
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
