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
  _StudentRegistrationScreenState createState() =>
      _StudentRegistrationScreenState();
}

class _StudentRegistrationScreenState extends State<StudentRegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _imageFile;
  Uint8List? _imageBytes;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Chọn ảnh trên Web
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        setState(() {
          _imageBytes = result.files.first.bytes; // Web
          _imageFile = null; // Reset cho Mobile
        });
      }
    } else {
      // Chọn ảnh trên Mobile
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        setState(() {
          _imageFile = File(result.files.single.path!); // Mobile
          _imageBytes = null; // Reset cho Web
        });
      }
    }
  }

  Future<void> _submitRegistration() async {
    setState(() => _isLoading = true);

    // 1️⃣ Upload ảnh lên Cloudinary
    String? billUrl =
        await CloudinaryService.uploadImage(_imageFile, _imageBytes);

    if (billUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lỗi khi upload ảnh!")),
      );
      setState(() => _isLoading = false);
      return;
    }

    // 2️⃣ Tạo object `StudentRegistration`
    StudentRegistration registration = StudentRegistration(
      nameAndSdt: _nameController.text,
      regisDay: DateTime.now(),
      bill: billUrl,
      email: _emailController.text,
      classRoomId: widget.classRoomId,
    );

    // 3️⃣ Gửi API đăng ký
    try {
      print(registration.classRoomId);
      final response = await http.post(
        Uri.parse(Wordval().api + 'studentRegistration'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(registration.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gửi đơn thành công!")),
        );
      } else {
        throw Exception("Lỗi đăng ký");
      }
    } catch (error) {
      print("Lỗi gửi đơn: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lỗi khi gửi đơn!")),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký khóa học")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Tên & SĐT"),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 10),
            _imageBytes != null
                ? Image.memory(_imageBytes!, height: 100) // Web
                : _imageFile != null
                    ? Image.file(_imageFile!, height: 100) // Mobile
                    : ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text("Chọn ảnh hóa đơn"),
                      ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitRegistration,
                    child: const Text("Gửi đơn"),
                  ),
          ],
        ),
      ),
    );
  }
}
