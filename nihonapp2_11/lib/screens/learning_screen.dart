import 'dart:math'; // Import để dùng hàm random
import 'package:flutter/material.dart';
import 'package:duandemo/model/Sentence.dart';

class LearningScreen extends StatefulWidget {
  final String lessonTitle;
  final List<Sentence> sentences; // Danh sách các câu trong bài học

  LearningScreen({required this.lessonTitle, required this.sentences});

  @override
  _LearningScreenState createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  int _currentSentenceIndex = 0;
  String _userAnswer = '';
  String _feedback = '';
  bool _showCard = false;

  // Biến để lưu ký tự random được cắt ra trong câu
  late String _randomCharacter;

  // Sử dụng TextEditingController để điều khiển nội dung của ô nhập liệu
  TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Random ký tự đầu tiên khi màn hình load
    _randomizeSentence();
  }

  @override
  void dispose() {
    _answerController.dispose(); // Giải phóng controller khi màn hình bị hủy
    super.dispose();
  }

  // Hàm random ký tự ngẫu nhiên trong câu, không cắt dấu cách
  void _randomizeSentence() {
    final currentSentence = widget.sentences[_currentSentenceIndex];

    // Xóa tất cả khoảng trắng trong câu trước khi hiển thị (nếu có)
    String sentence = currentSentence.word;

    // Random chọn một ký tự từ câu, bỏ qua dấu cách
    final random = Random();
    List<int> validIndices = [];

    // Tạo danh sách các vị trí hợp lệ (không phải dấu cách)
    for (int i = 0; i < sentence.length; i++) {
      if (sentence[i] != '　') {
        validIndices.add(i);
      }
    }

    // Chọn ngẫu nhiên một chỉ mục từ danh sách các chỉ mục hợp lệ
    int randomIndex = validIndices[random.nextInt(validIndices.length)];

    // Lưu ký tự đã random vào biến _randomCharacter
    _randomCharacter = sentence[randomIndex];

    // Thay thế ký tự random trong câu bằng '_____'
    setState(() {
      sentence = sentence.replaceRange(randomIndex, randomIndex + 1, '_____');
    });

    // Câu sau khi thay thế sẽ được hiển thị
    displaySentence = sentence;
  }

  // Biến để lưu câu với ký tự bị thiếu
  late String displaySentence;

  // Hàm kiểm tra đáp án
  void _checkAnswer() {
    if (_userAnswer.trim() == _randomCharacter.trim()) {
      setState(() {
        _feedback = 'Đúng rồi!';
        _showCard = true;
      });
    } else {
      setState(() {
        _feedback = 'Sai rồi! Vui lòng nhập lại.';
        _showCard = false;
      });
    }
  }

  // Hàm chuyển sang câu tiếp theo
  void _nextSentence() {
    if (_currentSentenceIndex < widget.sentences.length - 1) {
      setState(() {
        _currentSentenceIndex++;
        _userAnswer = '';
        _feedback = '';
        _showCard = false;
        _answerController
            .clear(); // Xóa nội dung trong ô nhập liệu khi chuyển sang câu mới

        // Random ký tự cho câu tiếp theo
        _randomizeSentence();
      });
    } else {
      _completeLesson();
    }
  }

  // Hàm hoàn thành bài học
  void _completeLesson() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hoàn thành'),
        content: Text('Bạn đã hoàn thành bài học!'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Đóng dialog
              Navigator.pop(context); // Quay lại màn hình trước
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentSentence = widget.sentences[_currentSentenceIndex];

    return Scaffold(
      backgroundColor: Colors.teal.shade100, // Màu nền cho màn hình
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700, // Màu nền AppBar
        title: Text(widget.lessonTitle, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 5, // Độ nổi của AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị câu hỏi
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade300, Colors.teal.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.shade400.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.question_mark_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '$displaySentence',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Hiển thị gợi ý (phiên âm của câu)
            Text(
              'Ý nghĩa: ${currentSentence.meaning}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20),
            // Ô nhập liệu cho người dùng
            TextField(
              controller:
                  _answerController, // Sử dụng controller để điều khiển nội dung của ô nhập liệu
              onChanged: (value) {
                _userAnswer = value;
              },
              decoration: InputDecoration(
                hintText: 'Nhập ký tự còn thiếu...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.teal.shade300),
                ),
                filled: true,
                fillColor: Colors.white, // Nền trắng cho ô nhập liệu
              ),
            ),
            SizedBox(height: 20),
            // Nút kiểm tra đáp án
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.teal.shade500, // Nền nút
                  elevation: 5, // Bóng nổi của nút
                ),
                onPressed: _checkAnswer,
                child: Text('Kiểm tra',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
            // Hiển thị phản hồi cho người dùng
            Text(
              _feedback,
              style: TextStyle(
                fontSize: 18,
                color: _feedback == 'Đúng rồi!' ? Colors.green : Colors.red,
              ),
            ),
            if (_showCard) ...[
              SizedBox(height: 10),
              // Hiển thị card thông tin khi câu trả lời đúng
              Card(
                elevation: 4,
                margin: EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đáp án đúng: $_randomCharacter',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Dịch: ${currentSentence.transcription}', // Hiển thị nghĩa của câu
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Hiển thị nút 'Câu tiếp theo' hoặc 'Hoàn thành'
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.teal.shade600, // Nền nút tiếp theo
                    elevation: 5, // Bóng nổi của nút
                  ),
                  onPressed: _nextSentence,
                  child: Text(
                    _currentSentenceIndex < widget.sentences.length - 1
                        ? 'Câu tiếp theo'
                        : 'Hoàn thành',
                    style: TextStyle(
                        fontSize: 16, color: Colors.white), // Màu chữ trắng
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
