import 'dart:io';
import 'dart:typed_data';
import 'package:duandemo/service/CloudinaryService.dart';
import 'package:flutter/foundation.dart'; // Kiểm tra nền tảng
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:html' as html; // Chỉ dành cho Web

class UploadImageScreen extends StatefulWidget {
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _selectedFile;
  Uint8List? _imageBytes;
  String? _uploadedImageUrl;
  bool _isUploading = false;

  // Chọn ảnh trên Mobile (File) & Web (Uint8List)
  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Nếu là Web, dùng HtmlInputElement để chọn file
      final html.FileUploadInputElement input = html.FileUploadInputElement();
      input.accept = 'image/*';
      input.click(); // Mở hộp thoại chọn ảnh

      input.onChange.listen((event) {
        final file = input.files!.first;
        final reader = html.FileReader();

        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((event) {
          setState(() {
            _imageBytes = reader.result as Uint8List;
            _selectedFile = null; // Xóa giá trị File (Mobile)
          });
        });
      });
    } else {
      // Nếu là Mobile, dùng image_picker
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedFile = File(pickedFile.path);
          _imageBytes = null; // Xóa giá trị Uint8List (Web)
        });
      }
    }
  }

  // Upload ảnh lên Cloudinary
  Future<void> _uploadImage() async {
    if (_selectedFile == null && _imageBytes == null) return;

    setState(() => _isUploading = true);

    final url = await CloudinaryService.uploadImage(_selectedFile, _imageBytes);

    setState(() {
      _uploadedImageUrl = url;
      _isUploading = false;
    });

    if (url != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload thành công!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload thất bại!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Image to Cloudinary")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị ảnh đã chọn
            _imageBytes != null
                ? Image.memory(_imageBytes!,
                    width: 200, height: 200, fit: BoxFit.cover)
                : _selectedFile != null
                    ? Image.file(_selectedFile!,
                        width: 200, height: 200, fit: BoxFit.cover)
                    : Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey[300],
                        child: Icon(Icons.image, size: 100, color: Colors.grey),
                      ),
            SizedBox(height: 20),

            // Nút chọn ảnh
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Chọn ảnh"),
            ),

            SizedBox(height: 20),

            // Nút Accept để tải lên Cloudinary
            _selectedFile != null || _imageBytes != null
                ? ElevatedButton(
                    onPressed: _isUploading ? null : _uploadImage,
                    child: _isUploading
                        ? CircularProgressIndicator()
                        : Text("Accept"),
                  )
                : Container(),

            SizedBox(height: 20),

            // Hiển thị ảnh đã upload thành công
            _uploadedImageUrl != null
                ? Column(
                    children: [
                      Text("Ảnh đã tải lên:"),
                      SizedBox(height: 10),
                      Image.network(_uploadedImageUrl!,
                          width: 200, height: 200, fit: BoxFit.cover),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
