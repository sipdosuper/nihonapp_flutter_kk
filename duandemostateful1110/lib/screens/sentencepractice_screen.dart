import 'package:flutter/material.dart';

class SentencePracticeScreen extends StatelessWidget {
  final String sentence;
  final String missingWord;
  final String translation;

  SentencePracticeScreen({required this.sentence, required this.missingWord, required this.translation});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _answerController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Luyện Tập Câu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              sentence.replaceFirst('______', '______'), // Hiển thị câu với từ thiếu
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Dịch nghĩa: $translation',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                labelText: 'Nhập từ còn thiếu',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_answerController.text.trim() == missingWord) {
                  // Hiển thị thông báo đúng
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Chúc mừng! Bạn đã trả lời đúng.')),
                  );
                } else {
                  // Hiển thị thông báo sai
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Xin thử lại!')),
                  );
                }
              },
              child: Text('Kiểm tra'),
            ),
          ],
        ),
      ),
    );
  }
}
