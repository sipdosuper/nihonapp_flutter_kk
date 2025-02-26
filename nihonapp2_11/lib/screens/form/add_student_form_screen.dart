import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:duandemo/model/StudentRegistration.dart';
import 'package:duandemo/model/Classroom.dart';
import 'package:duandemo/service/CloudinaryService.dart';
import 'package:duandemo/word_val.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

class AddStudentFormScreen extends StatefulWidget {
  @override
  _AddStudentFormScreenState createState() => _AddStudentFormScreenState();
}

class _AddStudentFormScreenState extends State<AddStudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _regisDayController = TextEditingController();

  String nameAndSdt = "", email = "";
  String regisDay = DateFormat('yyyy-MM-dd').format(DateTime.now());
  int? classRoomId;
  int id = 0;
  String? bill = "";
  File? _imageFile;
  Uint8List? _imageBytes;
  bool _isUploading = false;
  bool _isImageSelected = false;
  bool _isImageUploaded = false;
  List<Classroom> _classrooms = [];

  @override
  void initState() {
    super.initState();
    _fetchClassrooms();
    _regisDayController.text = regisDay; // Gán ngày hiện tại cho controller
  }

  Future<void> _fetchClassrooms() async {
    try {
      final response = await http.get(Uri.parse(Wordval().api + "classroom"));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _classrooms = data.map((json) => Classroom.fromJson(json)).toList();
          if (_classrooms.isNotEmpty) {
            classRoomId = _classrooms.first.id;
          }
        });
      } else {
        throw Exception("Lỗi khi tải danh sách lớp học");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không thể tải danh sách lớp học!")),
      );
    }
  }

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
            _isImageSelected = true;
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
          _isImageSelected = true;
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
      bill = url;
      _isUploading = false;
      _isImageUploaded = true;
      bill = url ?? ""; // Gán URL ảnh cho trường bill
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || classRoomId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng điền đầy đủ thông tin!")),
      );
      return;
    }

    if (bill == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng upload ảnh!")),
      );
      return;
    }

    final newStudent = StudentRegistration(
        id: id,
        nameAndSdt: nameAndSdt,
        regisDay: DateTime.parse(regisDay),
        bill: bill!,
        email: email,
        classRoomId: classRoomId!,
        bankCheck: false,
        status: false);

    final response = await http.post(
      Uri.parse(Wordval().api + "studentRegistration"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(newStudent.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Thêm học viên thành công!")),
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
        title: Text("Đăng ký học viên", style: TextStyle(color: Colors.white)),
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
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Tên học viên và SĐT",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                        ),
                        onChanged: (value) => nameAndSdt = value,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                        ),
                        onChanged: (value) => email = value,
                      ),
                      // Loại bỏ TextFormField cho trường bill
                      SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        value: classRoomId,
                        decoration: InputDecoration(
                          labelText: "Chọn lớp",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                        ),
                        items: _classrooms.map((classroom) {
                          return DropdownMenuItem<int>(
                            value: classroom.id,
                            child: Text(classroom.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            classRoomId = value!;
                          });
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _regisDayController,
                        decoration: InputDecoration(
                          labelText: "Ngày đăng ký",
                          border: OutlineInputBorder(),focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                        ),
                        readOnly: true, // Đặt readOnly thành true
                        // Loại bỏ onTap ở đây
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              _isImageUploaded
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(bill!,
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
              if (_isImageUploaded)
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Thêm học viên"),
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