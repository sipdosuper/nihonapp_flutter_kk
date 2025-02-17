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
    if (!_formKey.currentState!.validate() || proofUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Vui lòng điền đầy đủ thông tin và upload ảnh!")),
      );
      return;
    }

    final newTeacher = TeacherRegistrationForm(
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
    print(newTeacher.proof);

    final response = await http.post(
        Uri.parse("http://localhost:8080/api/teacherRegistration"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(newTeacher.toJson()));

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Thêm giáo viên thành công!")),
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
      appBar: AppBar(title: Text("Thêm giáo viên")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Tên giáo viên"),
                validator: (value) =>
                    value!.isEmpty ? "Vui lòng nhập tên" : null,
                onChanged: (value) => name = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) =>
                    value!.isEmpty ? "Vui lòng nhập email" : null,
                onChanged: (value) => email = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "introduce"),
                validator: (value) =>
                    value!.isEmpty ? "Vui lòng nhập introduce" : null,
                onChanged: (value) => introduce = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Số điện thoại"),
                validator: (value) =>
                    value!.isEmpty ? "Vui lòng nhập số điện thoại" : null,
                onChanged: (value) => phone = value,
              ),
              TextFormField(
                controller: _birthDayController,
                decoration: InputDecoration(labelText: "Ngày sinh"),
                readOnly: true,
                onTap: _selectBirthDay,
                validator: (value) =>
                    value!.isEmpty ? "Vui lòng chọn ngày sinh" : null,
              ),
              DropdownButtonFormField<int>(
                value: level_id,
                decoration: InputDecoration(labelText: "Chọn cấp độ"),
                items: List.generate(5, (index) => index + 1)
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text("Level $e")))
                    .toList(),
                onChanged: (value) => setState(() => level_id = value!),
              ),
              DropdownButtonFormField<int>(
                value: workingTime_id,
                decoration:
                    InputDecoration(labelText: "Chọn thời gian làm việc"),
                items: List.generate(5, (index) => index + 1)
                    .map(
                        (e) => DropdownMenuItem(value: e, child: Text("Ca $e")))
                    .toList(),
                onChanged: (value) => setState(() => workingTime_id = value!),
              ),
              SizedBox(height: 20),
              proofUrl != null
                  ? Image.network(proofUrl!,
                      width: 200, height: 200, fit: BoxFit.cover)
                  : _imageBytes != null
                      ? Image.memory(_imageBytes!,
                          width: 200, height: 200, fit: BoxFit.cover)
                      : _imageFile != null
                          ? Image.file(_imageFile!,
                              width: 200, height: 200, fit: BoxFit.cover)
                          : Container(),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text("Chọn ảnh"),
              ),
              if (_imageFile != null || _imageBytes != null)
                ElevatedButton(
                  onPressed: _isUploading ? null : _uploadImage,
                  child: _isUploading
                      ? CircularProgressIndicator()
                      : Text("Upload ảnh"),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Thêm giáo viên"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
