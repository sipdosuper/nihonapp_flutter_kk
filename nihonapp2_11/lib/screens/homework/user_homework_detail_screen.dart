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
    _audioUrl = widget.userHomeWork.audio;
  }

  Future<void> _submitGrading() async {
    double? point = double.tryParse(_pointController.text);
    if (point == null || point < 0 || point > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Điểm phải từ 0 đến 10")),
      );
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

      // Giải mã phản hồi sử dụng UTF-8
      final decodedResponse = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Chấm điểm thành công!")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Lỗi khi gửi dữ liệu: $decodedResponse")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Không thể kết nối đến server")));
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFE57373);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết bài tập"),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student ID
                Text(
                  "📌 Mã học sinh: ${widget.userHomeWork.studentId}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 12),

                // Student Answer
                Text(
                  "✏️ Câu trả lời:",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.userHomeWork.studentAnswer,
                  style: const TextStyle(fontSize: 15),
                ),

                const SizedBox(height: 20),

                // Audio file
                if (_audioUrl != null && _audioUrl!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("🎧 File âm thanh:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.play_arrow,
                                size: 32, color: primaryColor),
                            onPressed: () async {
                              await _audioPlayer.play(UrlSource(_audioUrl!));
                            },
                          ),
                          Expanded(
                            child: Text(
                              _audioUrl!,
                              style: const TextStyle(
                                  color: Colors.blueAccent, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  const Text(
                    "❌ Không có file âm thanh",
                    style: TextStyle(color: Colors.redAccent),
                  ),

                const SizedBox(height: 24),

                // Note field
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "📝 Ghi chú cho học sinh",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Point field
                TextField(
                  controller: _pointController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "⭐ Nhập điểm (0 - 10)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _submitGrading,
                    icon: const Icon(Icons.send),
                    label: const Text("Gửi điểm"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
