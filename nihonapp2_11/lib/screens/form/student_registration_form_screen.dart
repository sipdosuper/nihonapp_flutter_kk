import 'dart:io';
import 'dart:typed_data';
import 'package:duandemo/model/StudentRegistration.dart';
import 'package:duandemo/service/CloudinaryService.dart';
import 'package:duandemo/word_val.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentRegistrationScreen extends StatefulWidget {
  final int classRoomId;

  const StudentRegistrationScreen({super.key, required this.classRoomId});

  @override
  _StudentRegistrationScreenState createState() => _StudentRegistrationScreenState();
}

class _StudentRegistrationScreenState extends State<StudentRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _imageFile;
  Uint8List? _imageBytes;
  bool _isLoading = false;
  bool _imageUploaded = false;

  Future<void> _pickImage() async {
    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        setState(() {
          _imageBytes = result.files.first.bytes;
          _imageFile = null;
          _imageUploaded = false;
        });
      }
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        setState(() {
          _imageFile = File(result.files.single.path!);
          _imageBytes = null;
          _imageUploaded = false;
        });
      }
    }
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate() || (_imageFile == null && _imageBytes == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng điền đầy đủ thông tin và tải ảnh lên!")),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    String? billUrl = await CloudinaryService.uploadImage(_imageFile, _imageBytes);
    if (billUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lỗi khi upload ảnh!")));
      setState(() => _isLoading = false);
      return;
    }
    
    StudentRegistration registration = StudentRegistration(
      nameAndSdt: _nameController.text,
      regisDay: DateTime.now(),
      bill: billUrl,
      email: _emailController.text,
      classRoomId: widget.classRoomId,
    );

    try {
      final response = await http.post(
        Uri.parse(Wordval().api + 'studentRegistration'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(registration.toJson()),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.statusCode == 200 || response.statusCode == 201 ? "Gửi đơn thành công!" : "Lỗi đăng ký")),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lỗi khi gửi đơn!")));
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký khóa học"), backgroundColor: Colors.red[300]),
      backgroundColor: Colors.red[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField("Tên & SĐT", _nameController),
                    _buildTextField("Email", _emailController),
                    const SizedBox(height: 10),
                    _imageBytes != null
                        ? Image.memory(_imageBytes!, height: 100)
                        : _imageFile != null
                            ? Image.file(_imageFile!, height: 100)
                            : const SizedBox.shrink(),
                    if (!_imageUploaded)
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text("Chọn ảnh hóa đơn"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red[300]),
                      ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _submitRegistration,
                            child: const Text("Gửi đơn"),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[300]),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        validator: (value) => value!.isEmpty ? "Vui lòng nhập $label" : null,
      ),
    );
  }
}
