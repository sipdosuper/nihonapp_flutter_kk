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

  File? audioFile;        
  String? audioUrl;       
  File? uploadedFile;     
  String? uploadedFileUrl;

  bool _isLeftPanelExpanded = true; // Điều khiển panel bên trái

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
      setState(() {
        audioFile = File(result.files.single.path!);
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
    final Color mainColor = Color(0xFFE57373);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double leftPanelExpandedWidth = screenWidth * 0.25;
    final double leftPanelCollapsedWidth = 50.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text("Homework Screen"),
      ),
      // QUAN TRỌNG: Đặt crossAxisAlignment: CrossAxisAlignment.start để nội dung nằm sát trên
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Panel bên trái
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: _isLeftPanelExpanded
                ? leftPanelExpandedWidth
                : leftPanelCollapsedWidth,
            decoration: BoxDecoration(
              color: Color(0xFFFFCDD2),
              border: Border(
                right: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Column(
              children: [
                // Nút thu/mở
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      _isLeftPanelExpanded
                          ? Icons.arrow_back_ios
                          : Icons.arrow_forward_ios,
                      color: mainColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _isLeftPanelExpanded = !_isLeftPanelExpanded;
                      });
                    },
                  ),
                ),
                // Danh sách bài tập
                _isLeftPanelExpanded
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: homeworks.length,
                          itemBuilder: (context, index) {
                            final bool isSelected = (selectedHomework != null &&
                                selectedHomework!['id'] ==
                                    homeworks[index]['id']);

                            return Container(
                              color: isSelected
                                  ? mainColor.withOpacity(0.3)
                                  : Colors.transparent,
                              child: ListTile(
                                title: Text(
                                  homeworks[index]["name"],
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedHomework = homeworks[index];
                                    // Reset form
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
                      )
                    : Container(),
              ],
            ),
          ),
          // Panel bên phải
          Expanded(
            child: buildHomeworkDetail(mainColor),
          ),
        ],
      ),
    );
  }

  Widget buildHomeworkDetail(Color mainColor) {
    if (selectedHomework == null) {
      // Chưa chọn bài tập
      return Padding(
        padding: const EdgeInsets.all(16.0),
        // Align top-left nếu muốn chữ nằm góc trên trái
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Chọn bài tập để làm",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    // Đã chọn bài tập
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Dính lên trên
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tên bài tập
            Text(
              selectedHomework!["name"] ?? "Không có tên bài tập",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Câu hỏi
            Text(
              "Câu hỏi:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              selectedHomework!["question"] ?? "Không có câu hỏi",
              style: TextStyle(fontSize: 16),
            ),
            Divider(thickness: 1, height: 20),

            // Ô nhập câu trả lời
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
      ),
    );
  }
}
