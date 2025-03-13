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
  
  // Danh sách cho Dropdown
  List<Level> levels = [];
  List<Teacher> teachers = [];
  List<Time> times = [];
  Level? selectedLevel;
  Teacher? selectedTeacher;
  Time? selectedTime;
  
  // Các biến đánh dấu lỗi cho validation
  bool _nameError = false;
  bool _descriptionError = false;
  bool _slMaxError = false;
  bool _priceError = false;
  bool _startDayError = false;
  bool _endDayError = false;
  bool _selectedLevelError = false;
  bool _selectedTeacherError = false;
  bool _selectedTimeError = false;
  bool _imageError = false;

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
      _isUploading = false;
      // Sau khi upload thành công, cập nhật imageUrl và xóa preview ảnh đã chọn
      if (url != null) {
        imageUrl = url;
        _isImageSelected = false;
        _imageFile = null;
        _imageBytes = null;
      }
      _imageError = url == null;
    });
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Upload ảnh thất bại!"),
            backgroundColor: Colors.redAccent),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Ảnh đã được tải lên thành công!"),
            backgroundColor: Colors.green),
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
    setState(() {
      _nameError = nameController.text.isEmpty;
      _descriptionError = descriptionController.text.isEmpty;
      _slMaxError = slMaxController.text.isEmpty;
      _priceError = priceController.text.isEmpty;
      _startDayError = _startDayController.text.isEmpty;
      _endDayError = _endDayController.text.isEmpty;
      _selectedLevelError = selectedLevel == null;
      _selectedTeacherError = selectedTeacher == null;
      _selectedTimeError = selectedTime == null;
      _imageError = imageUrl == null;
    });

    if (_nameError ||
        _descriptionError ||
        _slMaxError ||
        _priceError ||
        _startDayError ||
        _endDayError ||
        _selectedLevelError ||
        _selectedTeacherError ||
        _selectedTimeError ||
        _imageError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Vui lòng điền đầy đủ thông tin!"),
          backgroundColor: Colors.redAccent,
        ),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Tạo lớp học thành công!"),
          backgroundColor: Colors.green,
        ),
      );
      print("Tạo lớp học thành công!");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Có lỗi xảy ra khi tạo lớp học!"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color mainColor = Color(0xFFE57373);
    return Scaffold(
      appBar: AppBar(
        title: Text("Tạo Lớp Học"),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên lớp học
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Tên lớp học",
                      errorText:
                          _nameError ? "Vui lòng điền đầy đủ thông tin" : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Dropdown Level
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: _selectedLevelError
                                  ? Colors.red
                                  : Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<Level>(
                          hint: Text("Chọn Level"),
                          value: selectedLevel,
                          isExpanded: true,
                          underline: SizedBox(),
                          items: levels
                              .map((level) => DropdownMenuItem(
                                  value: level, child: Text(level.name)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedLevel = value;
                              _selectedLevelError = false;
                            });
                          },
                        ),
                      ),
                      if (_selectedLevelError)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, left: 12),
                          child: Text(
                            "Vui lòng điền đầy đủ thông tin",
                            style:
                                TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Mô tả
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: "Mô tả",
                      errorText: _descriptionError
                          ? "Vui lòng điền đầy đủ thông tin"
                          : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Số lượng tối đa
                  TextField(
                    controller: slMaxController,
                    decoration: InputDecoration(
                      labelText: "Số lượng tối đa",
                      errorText: _slMaxError
                          ? "Vui lòng điền đầy đủ thông tin"
                          : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Giá
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(
                      labelText: "Giá",
                      errorText:
                          _priceError ? "Vui lòng điền đầy đủ thông tin" : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Dropdown Thời gian
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: _selectedTimeError
                                  ? Colors.red
                                  : Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<Time>(
                          hint: Text("Chọn thời gian"),
                          value: selectedTime,
                          isExpanded: true,
                          underline: SizedBox(),
                          items: times
                              .map((time) => DropdownMenuItem(
                                  value: time, child: Text(time.time)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedTime = value;
                              _selectedTimeError = false;
                            });
                          },
                        ),
                      ),
                      if (_selectedTimeError)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, left: 12),
                          child: Text(
                            "Vui lòng điền đầy đủ thông tin",
                            style:
                                TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Dropdown Giáo viên
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: _selectedTeacherError
                                  ? Colors.red
                                  : Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<Teacher>(
                          hint: Text("Chọn giáo viên"),
                          value: selectedTeacher,
                          isExpanded: true,
                          underline: SizedBox(),
                          items: teachers
                              .map((teacher) => DropdownMenuItem(
                                  value: teacher,
                                  child: Text(
                                      "${teacher.username} - ${teacher.email}")))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedTeacher = value;
                              _selectedTeacherError = false;
                            });
                          },
                        ),
                      ),
                      if (_selectedTeacherError)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, left: 12),
                          child: Text(
                            "Vui lòng điền đầy đủ thông tin",
                            style:
                                TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Ngày bắt đầu
                  TextField(
                    controller: _startDayController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Ngày bắt đầu",
                      errorText: _startDayError
                          ? "Vui lòng điền đầy đủ thông tin"
                          : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onTap: () => selectDate(context, true),
                  ),
                  SizedBox(height: 16),
                  // Ngày kết thúc
                  TextField(
                    controller: _endDayController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Ngày kết thúc",
                      errorText: _endDayError
                          ? "Vui lòng điền đầy đủ thông tin"
                          : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onTap: () => selectDate(context, false),
                  ),
                  SizedBox(height: 16),
                  // Phần hiển thị ảnh:
                  // 1. Ảnh đã upload (nếu có)
                  if (imageUrl != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ảnh đã tải lên:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 16),
                  // 2. Preview ảnh mới được chọn (chưa upload)
                  if (_isImageSelected)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ảnh mới chọn:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        _imageBytes != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  _imageBytes!,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : _imageFile != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      _imageFile!,
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(),
                      ],
                    ),
                  if (_isImageSelected && _imageError)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                      child: Text(
                        "Vui lòng tải lên ảnh",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  SizedBox(height: 20),
                  // Nút "Chọn ảnh" luôn hiển thị
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text("Chọn ảnh"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Nút "Upload ảnh" chỉ xuất hiện nếu có ảnh mới được chọn (chưa upload)
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
                        backgroundColor: mainColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  SizedBox(height: 10),
                  // Nút tạo lớp học
                  ElevatedButton(
                    onPressed: createClassroom,
                    child: Text("Tạo lớp học"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
