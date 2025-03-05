import 'dart:io';
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

  // Chọn file âm thanh
  Future<void> pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        audioFile = file;
      });
    }
  }

  // Upload file âm thanh lên Cloudinary
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

  // Nộp bài
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Nộp bài thành công!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi nộp bài!")),
      );
    }
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Màu chủ đạo
    final Color mainColor = Color(0xFFE57373);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text("Homework Screen"),
      ),
      body: Container(
        color: Colors.white.withOpacity(0.95),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // MÀN HÌNH RỘNG (TABLET/WEB)
            if (constraints.maxWidth > 600) {
              return Row(
                children: [
                  // Cột trái: Danh sách bài tập
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: homeworks.length,
                        itemBuilder: (context, index) {
                          // THAY ĐỔI: Xác định item đang chọn
                          final isSelected = (selectedHomework != null &&
                              selectedHomework!['id'] == homeworks[index]['id']);

                          return Container(
                            // THAY ĐỔI: Dùng màu đậm hơn để phân biệt
                            color: isSelected
                                ? mainColor.withOpacity(0.7) // Đậm hơn
                                : Colors.transparent,
                            child: ListTile(
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
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Cột phải: Chi tiết bài tập + form
                  Expanded(
                    flex: 2,
                    child: buildHomeworkDetail(mainColor),
                  ),
                ],
              );
            } else {
              // MÀN HÌNH HẸP (MOBILE)
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Phần danh sách bài tập (dọc)
                    ListView.builder(
                      itemCount: homeworks.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        // THAY ĐỔI: Xác định item đang chọn
                        final isSelected = (selectedHomework != null &&
                            selectedHomework!['id'] == homeworks[index]['id']);

                        return Card(
                          margin: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          // THAY ĐỔI: Nếu item được chọn, dùng màu đậm hơn
                          color: isSelected
                              ? mainColor.withOpacity(0.7)
                              : mainColor.withOpacity(0.2),
                          child: ListTile(
                            title: Text(
                              homeworks[index]["name"],
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
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
                          ),
                        );
                      },
                    ),
                    // Phần chi tiết bài tập
                    buildHomeworkDetail(mainColor),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Widget riêng hiển thị chi tiết bài tập + form
  Widget buildHomeworkDetail(Color mainColor) {
    if (selectedHomework == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Chọn bài tập để làm",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Câu hỏi:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            selectedHomework!["question"] ?? "Không có câu hỏi",
            style: TextStyle(fontSize: 18),
          ),
          Divider(thickness: 1, height: 20),
          TextField(
            controller: answerController,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Nhập câu trả lời của bạn",
            ),
          ),
          SizedBox(height: 10),
          // Chọn + Upload âm thanh
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: pickAudioFile,
                  icon: Icon(Icons.audiotrack),
                  label: Text("Chọn Âm Thanh"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: uploadAudio,
                  icon: Icon(Icons.cloud_upload),
                  label: Text("Tải âm thanh lên"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (audioFile != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("File đã chọn: ${audioFile!.path.split('/').last}"),
            ),
          if (audioUrl != null) Text("Đã tải lên: $audioUrl"),
          SizedBox(height: 10),
          // Chọn file khác
          ElevatedButton.icon(
            onPressed: pickFile,
            icon: Icon(Icons.attach_file),
            label: Text("Chọn File Khác"),
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          if (uploadedFileUrl != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("Đã tải lên: $uploadedFileUrl"),
            ),
          SizedBox(height: 20),
          // Nút nộp bài
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: submitHomework,
              child: Text("Nộp bài"),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.all(15),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
