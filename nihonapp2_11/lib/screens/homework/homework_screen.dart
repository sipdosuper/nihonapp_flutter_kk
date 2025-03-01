import 'dart:io';
import 'dart:typed_data';
import 'package:duandemo/service/CloudinaryService.dart';
import 'package:duandemo/word_val.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeworkScreen extends StatefulWidget {
  @override
  _HomeworkScreenState createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  String api = Wordval().api;
  List<dynamic> homeworks = [];
  Map<String, dynamic>? selectedHomework;
  TextEditingController answerController = TextEditingController();
  File? audioFile; // File âm thanh được chọn
  String? audioUrl; // URL sau khi tải lên Cloudinary
  File? uploadedFile; // File khác (nếu có)
  String? uploadedFileUrl;

  @override
  void initState() {
    super.initState();
    fetchHomeworks();
  }

  Future<void> fetchHomeworks() async {
    final response = await http.get(Uri.parse('${api}homework'));
    if (response.statusCode == 200) {
      setState(() {
        homeworks = json.decode(response.body);
      });
    } else {
      print("Lỗi khi tải danh sách bài tập");
    }
  }

  // Chọn file âm thanh (chỉ chọn, không tự động upload)
  Future<void> pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio, // Chỉ chọn file âm thanh (mp3, aac, v.v.)
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        audioFile = file;
      });
      // Không gọi uploadAudio() ở đây nữa
    }
  }

  // Tải file âm thanh lên Cloudinary (gọi thủ công khi bấm nút)
  Future<void> uploadAudio() async {
    if (audioFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng chọn file âm thanh trước!")),
      );
      return;
    }
    String? url = await CloudinaryService.uploadAudio(audioFile, null);
    if (url != null) {
      setState(() {
        audioUrl = url;
      });
    } else {
      print("Lỗi tải lên Cloudinary");
    }
  }

  // Chọn file khác (ảnh, tài liệu, v.v.)
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        uploadedFile = file;
      });

      String? url = await CloudinaryService.uploadImage(file, null);
      if (url != null) {
        setState(() {
          uploadedFileUrl = url;
        });
      } else {
        print("Lỗi tải lên Cloudinary");
      }
    }
  }

  Future<void> submitHomework() async {
    if (selectedHomework == null) return;

    Map<String, dynamic> userHomework = {
      "homework_id": selectedHomework!['id'],
      "student_answer": answerController.text,
      "audio": audioUrl ?? "",
      "file_url": uploadedFileUrl ?? "",
    };

    final response = await http.post(
      Uri.parse('${api}homework'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(userHomework),
    );

    if (response.statusCode == 200) {
      print("Nộp bài thành công");
    } else {
      print("Lỗi khi nộp bài");
    }
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Homework Screen")),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: homeworks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(homeworks[index]["name"]),
                  onTap: () {
                    setState(() {
                      selectedHomework = homeworks[index];
                      answerController.clear();
                      audioFile = null;
                      uploadedFile = null;
                      audioUrl = null;
                      uploadedFileUrl = null;
                    });
                  },
                );
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: selectedHomework == null
                ? Center(child: Text("Chọn bài tập để làm"))
                : Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Câu hỏi:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          selectedHomework!["question"] ?? "Không có câu hỏi",
                          style: TextStyle(fontSize: 18),
                        ),
                        Divider(thickness: 1, height: 20),
                        TextField(
                          controller: answerController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Nhập câu trả lời của bạn",
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: pickAudioFile,
                              child: Text("Chọn File Âm Thanh"),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed:
                                  uploadAudio, // Chỉ upload khi bấm nút này
                              child: Text("Tải âm thanh lên"),
                            ),
                          ],
                        ),
                        if (audioFile != null)
                          Text(
                              "File đã chọn: ${audioFile!.path.split('/').last}"),
                        if (audioUrl != null) Text("Đã tải lên: $audioUrl"),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: pickFile,
                              child: Text("Chọn File Khác"),
                            ),
                          ],
                        ),
                        if (uploadedFileUrl != null)
                          Text("Đã tải lên: $uploadedFileUrl"),
                        Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: submitHomework,
                            child: Text("Nộp bài"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(15),
                              textStyle: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
