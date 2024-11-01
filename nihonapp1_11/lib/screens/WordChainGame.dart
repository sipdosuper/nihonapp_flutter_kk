import 'package:flutter/material.dart';

void main() {
  runApp(WordChainGame());
}

class WordChainGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Nối Từ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> wordList = [
    'apple',
    'elephant',
    'tiger',
    'rabbit',
    'tortoise',
    'eagle'
  ];
  String currentWord = 'apple'; // Từ bắt đầu
  int score = 0;
  final int targetScore = 40;
  final TextEditingController _controller = TextEditingController();
  String message = '';

  void _submitWord() {
    String userInput = _controller.text.toLowerCase();
    _controller.clear(); // Clear input after submission

    // Kiểm tra từ nhập vào có hợp lệ không
    if (userInput.isEmpty) {
      setState(() {
        message = "Vui lòng nhập một từ.";
      });
      return;
    }

    if (userInput[0] != currentWord[currentWord.length - 1]) {
      setState(() {
        message =
            "Từ phải bắt đầu bằng chữ '${currentWord[currentWord.length - 1]}'.";
      });
      return;
    }

    if (!wordList.contains(userInput)) {
      setState(() {
        message = "Từ này không có trong danh sách từ hợp lệ.";
      });
      return;
    }

    // Cộng điểm dựa vào số ký tự của từ
    setState(() {
      score += userInput.length;
      currentWord = userInput;
      message = "Điểm hiện tại: $score";
    });

    if (score >= targetScore) {
      setState(() {
        message = "Chúc mừng! Bạn đã thắng với $score điểm!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Nối Từ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Từ hiện tại: $currentWord',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nhập từ tiếp theo',
              ),
              onSubmitted: (value) => _submitWord(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitWord,
              child: Text('Gửi'),
            ),
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
            SizedBox(height: 20),
            Text(
              'Điểm: $score',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
