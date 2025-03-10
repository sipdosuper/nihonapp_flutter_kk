import 'package:audioplayers/audioplayers.dart';
import 'package:duandemo/model/User_HomeWork.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeworkDetailScreen extends StatefulWidget {
  final UserHomeWork userHomeWork;

  const HomeworkDetailScreen({Key? key, required this.userHomeWork})
      : super(key: key);

  @override
  _HomeworkDetailScreenState createState() => _HomeworkDetailScreenState();
}

class _HomeworkDetailScreenState extends State<HomeworkDetailScreen> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _pointController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _audioUrl;

  @override
  void initState() {
    super.initState();
    _audioUrl = widget.userHomeWork.audio; // Lấy file từ Cloudinary nếu có
  }

  // Gửi đánh giá bài tập lên server
  Future<void> _submitGrading() async {
    double? point = double.tryParse(_pointController.text);
    if (point == null || point < 0 || point > 10) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Điểm phải từ 0 đến 10")));
      return;
    }

    Map<String, dynamic> gradingData = {
      "answer_id": widget.userHomeWork.id,
      "teacher_note": _noteController.text,
      "point": point
    };

    try {
      final response = await http.post(
        Uri.parse("http://localhost:8080/api/answer/grading"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(gradingData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Chấm điểm thành công!")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Lỗi khi gửi dữ liệu")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Không thể kết nối đến server")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chi tiết bài tập")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📌 Student ID: ${widget.userHomeWork.studentId}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("✏️ Câu trả lời: ${widget.userHomeWork.studentAnswer}"),
            const SizedBox(height: 10),

            // Hiển thị file âm thanh từ Cloudinary nếu có
            if (_audioUrl != null && _audioUrl!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("🎧 File âm thanh từ Cloudinary:"),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.play_arrow,
                            size: 30, color: Colors.blue),
                        onPressed: () async {
                          await _audioPlayer.play(UrlSource(_audioUrl!));
                        },
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _audioUrl!,
                          style: const TextStyle(color: Colors.blue),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
              const Text("❌ Không có file âm thanh",
                  style: TextStyle(color: Colors.red)),

            const SizedBox(height: 20),

            // Ô nhập ghi chú của giáo viên
            TextField(
              controller: _noteController,
              decoration:
                  const InputDecoration(labelText: "Nhập ghi chú cho học sinh"),
              maxLines: 3,
            ),

            const SizedBox(height: 10),

            // Ô nhập điểm
            TextField(
              controller: _pointController,
              decoration:
                  const InputDecoration(labelText: "Nhập điểm (0 - 10)"),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            // Nút gửi điểm
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitGrading,
                child: const Text("Gửi điểm"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
