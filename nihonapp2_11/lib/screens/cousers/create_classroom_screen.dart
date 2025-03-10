import 'dart:convert';
import 'dart:io';
import 'package:duandemo/model/Level.dart';
import 'package:duandemo/model/Teacher.dart';
import 'package:duandemo/model/Time.dart';
import 'package:duandemo/service/CloudinaryService.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';

class CreateClassroomScreen extends StatefulWidget {
  @override
  _CreateClassroomScreenState createState() => _CreateClassroomScreenState();
}

class _CreateClassroomScreenState extends State<CreateClassroomScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController slMaxController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController _startDayController = TextEditingController();
  final TextEditingController _endDayController = TextEditingController();
  String? imageUrl;
  File? _imageFile;
  Uint8List? _imageBytes;
  bool _isUploading = false;
  bool _isImageSelected = false;
  bool _isImageUploaded = false;
  List<Level> levels = [];
  List<Teacher> teachers = [];
  List<Time> times = [];
  Level? selectedLevel;
  Teacher? selectedTeacher;
  Time? selectedTime;

  @override
  void initState() {
    super.initState();
    fetchLevels();
    fetchTeachers();
    fetchTimes();
  }

  Future<void> fetchLevels() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/level'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        levels = data.map((json) => Level.fromJson(json)).toList();
      });
    }
  }

  Future<void> fetchTeachers() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/teacher'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        teachers = data.map((json) => Teacher.fromJson(json)).toList();
      });
    }
  }

  Future<void> fetchTimes() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/time'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        times = data.map((json) => Time.fromJson(json)).toList();
      });
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
      imageUrl = url;
      _isUploading = false;
      _isImageUploaded = true;
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

  Future<void> selectDate(BuildContext context, bool isStart) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDayController.text = DateFormat('yyyy-MM-dd').format(picked);
        } else {
          _endDayController.text = DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

  Future<void> createClassroom() async {
    if (selectedLevel == null ||
        selectedTeacher == null ||
        selectedTime == null ||
        imageUrl == null) {
      return;
    }
    Map<String, dynamic> classroomData = {
      "name": nameController.text,
      "level_id": selectedLevel!.id,
      "description": descriptionController.text,
      "sl_max": int.parse(slMaxController.text),
      "link_giaotrinh": imageUrl,
      "start": _startDayController.text,
      "end": _endDayController.text,
      "price": double.parse(priceController.text),
      "time_id": selectedTime!.id,
      "teacher_id": selectedTeacher!.id,
    };
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/classroom'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(classroomData),
    );
    if (response.statusCode == 200) {
      print("Tạo lớp học thành công!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tạo Lớp Học")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Tên lớp học")),
              DropdownButton<Level>(
                hint: Text("Chọn Level"),
                value: selectedLevel,
                isExpanded: true,
                items: levels.map((level) {
                  return DropdownMenuItem(
                      value: level, child: Text(level.name));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLevel = value;
                  });
                },
              ),
              TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: "Mô tả")),
              TextField(
                  controller: slMaxController,
                  decoration: InputDecoration(labelText: "Số lượng tối đa")),
              TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: "Giá")),
              DropdownButton<Time>(
                hint: Text("Chọn thời gian"),
                value: selectedTime,
                isExpanded: true,
                items: times.map((time) {
                  return DropdownMenuItem(value: time, child: Text(time.time));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTime = value;
                  });
                },
              ),
              DropdownButton<Teacher>(
                hint: Text("Chọn giáo viên"),
                value: selectedTeacher,
                isExpanded: true,
                items: teachers.map((teacher) {
                  return DropdownMenuItem(
                      value: teacher,
                      child: Text("${teacher.username} - ${teacher.email}"));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTeacher = value;
                  });
                },
              ),
              TextField(
                  controller: _startDayController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "Ngày bắt đầu"),
                  onTap: () => selectDate(context, true)),
              TextField(
                  controller: _endDayController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "Ngày kết thúc"),
                  onTap: () => selectDate(context, false)),
              if (imageUrl != null) Image.network(imageUrl!),
              SizedBox(height: 20),
              _isImageUploaded
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(imageUrl!,
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
              ElevatedButton(
                  onPressed: createClassroom, child: Text("Tạo lớp học")),
            ],
          ),
        ),
      ),
    );
  }
}
