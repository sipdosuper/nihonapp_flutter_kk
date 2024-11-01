import 'package:flutter/material.dart';

class SentencePracticeScreen extends StatefulWidget {
  @override
  _SentencePracticeScreenState createState() => _SentencePracticeScreenState();
}

class _SentencePracticeScreenState extends State<SentencePracticeScreen> {
  final List<Map<String, String>> _sentences = [
    {
      'japanese': '私は学生です。',
      'vietnamese': 'Tôi là sinh viên.',
      'missingWord': '学生',
      'vocabulary': '学生 (がくせい): Sinh viên',
      'grammar': 'です: Dùng để diễn đạt sự xác nhận về một sự thật.',
    },
    {
      'japanese': '彼は先生です。',
      'vietnamese': 'Anh ấy là giáo viên.',
      'missingWord': '先生',
      'vocabulary': '先生 (せんせい): Giáo viên',
      'grammar': 'です: Cấu trúc khẳng định.',
    },
  ];

  int _currentSentenceIndex = 0;
  String _userInput = '';

  void _checkAnswer() {
    if (_userInput.trim() == _sentences[_currentSentenceIndex]['missingWord']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đúng rồi!')),
      );
      _nextSentence();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sai rồi, hãy thử lại!')),
      );
    }
  }

  void _nextSentence() {
    setState(() {
      if (_currentSentenceIndex < _sentences.length - 1) {
        _currentSentenceIndex++;
        _userInput = ''; // Reset input khi chuyển câu
      } else {
        // Kết thúc bài học
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentSentence = _sentences[_currentSentenceIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Thực Hành Câu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentSentence['japanese']!.replaceAll('______', '______'), // Hiển thị câu với từ thiếu
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Dịch nghĩa: ${currentSentence['vietnamese']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nhập từ còn thiếu',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _userInput = value; // Cập nhật giá trị nhập từ người dùng
                });
              },
              onSubmitted: (_) {
                _checkAnswer(); // Kiểm tra câu trả lời khi người dùng nhấn Enter
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAnswer,
              child: Text('Kiểm tra'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _nextSentence,
              child: Text('Câu tiếp theo'),
            ),
          ],
        ),
      ),
    );
  }
}
