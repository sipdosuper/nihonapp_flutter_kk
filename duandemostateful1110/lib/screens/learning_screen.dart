import 'package:flutter/material.dart';

class LearningScreen extends StatefulWidget {
  final String lessonTitle;
  final List<Map<String, String>> sentences;

  LearningScreen({required this.lessonTitle, required this.sentences});

  @override
  _LearningScreenState createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  int currentSentenceIndex = 0;
  String userAnswer = '';
  String feedbackMessage = ''; // Biến để chứa thông báo phản hồi
  bool isCorrect = false;

  @override
  Widget build(BuildContext context) {
    final sentence = widget.sentences[currentSentenceIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lessonTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card hiển thị câu tiếng Nhật và ô nhập từ thiếu
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sentence['japanese']!.replaceAll(sentence['missingWord']!, '____'), // Hiển thị câu với từ bị thiếu
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 10),
                    Text('Nghĩa: ${sentence['vietnamese']}'),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(labelText: 'Nhập từ thiếu'),
                      onChanged: (value) {
                        userAnswer = value;
                      },
                      controller: TextEditingController(text: userAnswer),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isCorrect = userAnswer == sentence['missingWord'];
                  // Cập nhật thông báo phản hồi
                  feedbackMessage = isCorrect ? 'Đúng rồi!' : 'Bạn đã nhập sai, vui lòng nhập lại!';
                });
              },
              child: Text('Kiểm tra'),
            ),
            if (feedbackMessage.isNotEmpty) ...[
              Text(feedbackMessage, style: TextStyle(color: isCorrect ? Colors.green : Colors.red)),
              SizedBox(height: 20),
            ],
            if (isCorrect) ...[
              // Card hiển thị từ vựng và ngữ pháp
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Từ vựng: ${sentence['vocabulary']}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text('Ngữ pháp: ${sentence['grammar']}', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (currentSentenceIndex < widget.sentences.length - 1) {
                    // Nếu còn câu, chuyển sang câu tiếp theo
                    setState(() {
                      currentSentenceIndex++;
                      userAnswer = ''; // Reset câu trả lời
                      feedbackMessage = ''; // Reset thông báo phản hồi
                      isCorrect = false; // Reset trạng thái
                    });
                  } else {
                    // Nếu đã hết câu, quay lại màn hình "Học"
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  currentSentenceIndex < widget.sentences.length - 1 ? 'Câu tiếp theo' : 'Hoàn thành',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
