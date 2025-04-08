import 'package:duandemo/word_val.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(WordChainGame());
}

class WordChainGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  List<String> wordList = [];
  Set<String> usedWords = {};
  String currentWord = '';
  int userScore = 0;
  int systemScore = 0;
  bool isUserTurn = false;
  final int targetScore = 40;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  Timer? countdownTimer;
  int timeLeft = 1000;

  @override
  void initState() {
    super.initState();
    loadVocabularies();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Nối Từ'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isUser = messages[index]["isUser"];
                return Row(
                  mainAxisAlignment:
                      isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    if (isUser)
                      Text(
                        "Điểm: ${messages[index]["score"] ?? ""} ",
                        style: TextStyle(color: Colors.blue),
                      ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      margin: EdgeInsets.symmetric(vertical: 4),
                      constraints: BoxConstraints(maxWidth: 200),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue[100] : Colors.green[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            messages[index]["text"], // Từ Kanji hoặc chữ thường
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          if (!isUser && messages[index]["hiragana"] != null)
                            Text(
                              "(${messages[index]["hiragana"]})", // Cách đọc Hiragana
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Thời gian còn lại: $timeLeft giây",
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nhập từ tiếp theo',
                        ),
                        onSubmitted: (value) => _submitWord(),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _submitWord,
                      child: Text('Gửi'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadVocabularies() async {
    try {
      final response = await http.get(Uri.parse(Wordval().api + 'vocabulary'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          wordList = data
              .map((vocab) => vocab['transcription'].toString().toLowerCase())
              .toList();

          String randomWord = wordList[Random().nextInt(wordList.length)];
          _setSystemWord(randomWord);
        });

        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            isUserTurn = true;
            startCountdown();
          });
        });
      } else {
        setState(() {
          messages.add({
            "text":
                "Lỗi: Không thể tải danh sách từ vựng (Mã lỗi: ${response.statusCode})",
            "isUser": false
          });
        });
      }
    } catch (e) {
      setState(() {
        messages.add(
            {"text": "Lỗi: Không thể kết nối đến máy chủ.", "isUser": false});
      });
      print('Error: $e');
    }
  }

  Future<void> _setSystemWord(String word) async {
    String systemWord = word;
    String hiragana = word;

    if (_containsKanji(word)) {
      hiragana = await _translateToHiragana(word);
    }

    setState(() {
      currentWord = systemWord;
      usedWords.add(systemWord);
      messages.add(
          {"text": systemWord, "transcription": hiragana, "isUser": false});
    });
  }

  bool _containsKanji(String word) {
    final kanjiRegex = RegExp(r'[\u4E00-\u9FFF]');
    return kanjiRegex.hasMatch(word);
  }

  Future<String> _translateToHiragana(String kanjiWord) async {
    try {
      final response = await http.post(
        Uri.parse(Wordval().api + 'translate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': kanjiWord, 'to': 'transcription'}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['transcription'] ?? kanjiWord;
      } else {
        print("API Error: ${response.statusCode}");
        return kanjiWord;
      }
    } catch (e) {
      print("Translation error: $e");
      return kanjiWord;
    }
  }

  void startCountdown() {
    countdownTimer?.cancel();
    setState(() {
      timeLeft = 10;
    });
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
      });
      if (timeLeft <= 0) {
        timer.cancel();
        _timeOut();
      }
    });
  }

  void _timeOut() {
    if (isUserTurn) {
      countdownTimer?.cancel();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Hết giờ'),
            content: Text('Bạn đã thua vì không nhập từ kịp thời.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    isUserTurn = false;
                  });
                },
                child: Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetGame();
                },
                child: Text('Chơi lại'),
              ),
            ],
          );
        },
      );
    }
  }

  void _resetGame() {
    setState(() {
      wordList.clear();
      usedWords.clear();
      currentWord = '';
      userScore = 0;
      systemScore = 0;
      messages.clear();
      timeLeft = 10;
      isUserTurn = false;
      loadVocabularies();
    });
  }

  void _submitWord() {
    if (isUserTurn) {
      String userInput = _controller.text.toLowerCase();
      _controller.clear();

      if (userInput.isEmpty) {
        setState(() {
          messages.add({
            "text": "Vui lòng nhập một từ.",
            "isUser": true,
            "score": userScore
          });
        });
        return;
      }

      if (userInput[0] != currentWord[currentWord.length - 1]) {
        setState(() {
          messages.add({
            "text":
                "Từ phải bắt đầu bằng chữ '${currentWord[currentWord.length - 1]}'.",
            "isUser": true,
            "score": userScore
          });
        });
        return;
      }

      if (!wordList.contains(userInput) || usedWords.contains(userInput)) {
        setState(() {
          messages.add({
            "text": "Từ này không hợp lệ hoặc đã được sử dụng.",
            "isUser": true,
            "score": userScore
          });
        });
        return;
      }

      _ifItOk(userInput);

      if (userScore >= targetScore) {
        setState(() {
          messages.add({
            "text": "Chúc mừng! Bạn đã thắng với $userScore điểm!",
            "isUser": true,
            "score": userScore
          });
        });
        countdownTimer?.cancel();
        return;
      }

      Future.delayed(Duration(seconds: 1), _systemTurn);
    }
  }

  void _ifItOk(String input) {
    setState(() {
      userScore += input.length;
      currentWord = input;
      usedWords.add(input);
      messages.add({"text": input, "isUser": true, "score": userScore});
      isUserTurn = false;
    });
    countdownTimer?.cancel();
  }

  void _systemTurn() {
    if (!isUserTurn) {
      String lastChar = currentWord[currentWord.length - 1];
      List<String> validWords = wordList
          .where((word) =>
              word.startsWith(lastChar) &&
              word != currentWord &&
              !usedWords.contains(word))
          .toList();

      if (validWords.isEmpty) {
        setState(() {
          messages.add({
            "text": "Hệ thống không tìm thấy từ hợp lệ! Bạn đã thắng!",
            "isUser": false
          });
        });
        return;
      }

      String systemWord = validWords[Random().nextInt(validWords.length)];
      _setSystemWord(systemWord);

      if (systemScore >= targetScore) {
        setState(() {
          messages.add({
            "text": "Hệ thống đã thắng với $systemScore điểm!",
            "isUser": false
          });
        });
      } else {
        startCountdown();
      }
    }
  }
}
