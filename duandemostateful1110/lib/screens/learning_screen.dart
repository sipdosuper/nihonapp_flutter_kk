import 'package:flutter/material.dart';

class LearningScreen extends StatefulWidget {
  final String lessonTitle;
  final List<Map<String, String>> sentences;

  LearningScreen({required this.lessonTitle, required this.sentences});

  @override
  _LearningScreenState createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  int _currentSentenceIndex = 0;
  String _userAnswer = '';
  String _feedback = '';
  bool _showCard = false;

  void _checkAnswer() {
    final currentSentence = widget.sentences[_currentSentenceIndex];
    if (_userAnswer == currentSentence['missingWord']) {
      setState(() {
        _feedback = 'Đúng rồi!';
        _showCard = true; // Hiển thị card thông tin khi đúng
      });
    } else {
      setState(() {
        _feedback = 'Sai rồi! Vui lòng nhập lại.';
        _showCard = false; // Không hiển thị card thông tin khi sai
      });
    }
  }

  void _nextSentence() {
    if (_currentSentenceIndex < widget.sentences.length - 1) {
      setState(() {
        _currentSentenceIndex++;
        _userAnswer = ''; // Xóa dữ liệu cũ khi chuyển câu
        _feedback = '';
        _showCard = false; // Ẩn card thông tin khi chuyển câu
      });
    }
  }

  void _completeLesson() {
    // Quay lại TopicScreen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentSentence = widget.sentences[_currentSentenceIndex];

    // Hiển thị câu với từ thiếu được thay thế bằng khoảng trắng
    String displaySentence = currentSentence['japanese']!.replaceAll(currentSentence['missingWord']!, '_____');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lessonTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Câu: $displaySentence',
              style: TextStyle(fontSize: 24),
            ),
            // Hiển thị nghĩa của câu
            Text(
              currentSentence['meaning']!,
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            TextField(
              onChanged: (value) {
                _userAnswer = value; // Cập nhật giá trị người dùng nhập
              },
              decoration: InputDecoration(
                hintText: 'Nhập từ còn thiếu...',
              ),
              controller: TextEditingController(text: _userAnswer), // Cập nhật ô nhập liệu
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAnswer,
              child: Text('Kiểm tra'),
            ),
            SizedBox(height: 20),
            Text(
              _feedback,
              style: TextStyle(color: _feedback == 'Đúng rồi!' ? Colors.green : Colors.red),
            ),
            if (_showCard) ...[
              Card(
                elevation: 4,
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Từ vựng: ${currentSentence['vocabulary']}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Ngữ pháp: ${currentSentence['grammar']}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      // Hiển thị nút hoàn thành hoặc câu tiếp theo
                      if (_currentSentenceIndex < widget.sentences.length - 1)
                        ElevatedButton(
                          onPressed: _nextSentence,
                          child: Text('Câu tiếp theo'),
                        )
                      else
                        ElevatedButton(
                          onPressed: _completeLesson,
                          child: Text('Hoàn thành'),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
