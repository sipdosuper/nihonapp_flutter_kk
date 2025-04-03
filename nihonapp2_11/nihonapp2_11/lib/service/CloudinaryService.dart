import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // Kiểm tra nền tảng
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = 'dyxkqeqp1';
  static const String uploadPreset = 'gv_minh_chung';

  // Upload ảnh lên Cloudinary (GIỮ NGUYÊN)
  static Future<String?> uploadImage(File? file, Uint8List? imageBytes) async {
    final url =
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    var request = http.MultipartRequest("POST", url);
    request.fields["upload_preset"] = uploadPreset;

    if (kIsWeb && imageBytes != null) {
      // Nếu chạy trên Web
      request.files.add(http.MultipartFile.fromBytes("file", imageBytes,
          filename: "upload.jpg"));
    } else if (file != null) {
      // Nếu chạy trên Mobile
      request.files.add(await http.MultipartFile.fromPath("file", file.path));
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonData = json.decode(responseBody);
      return jsonData["secure_url"];
    } else {
      print("Upload failed: ${response.reasonPhrase}");
      return null;
    }
  }

  // Upload audio lên Cloudinary (MỚI)
  static Future<String?> uploadAudio(File? file, Uint8List? audioBytes) async {
    final url =
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/video/upload");

    var request = http.MultipartRequest("POST", url);
    request.fields["upload_preset"] = uploadPreset;

    if (kIsWeb && audioBytes != null) {
      // Nếu chạy trên Web
      request.files.add(http.MultipartFile.fromBytes("file", audioBytes,
          filename: "upload.mp3"));
    } else if (file != null) {
      // Nếu chạy trên Mobile
      request.files.add(await http.MultipartFile.fromPath("file", file.path));
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonData = json.decode(responseBody);
      return jsonData["secure_url"];
    } else {
      print("Upload failed: ${response.reasonPhrase}");
      return null;
    }
  }
}
