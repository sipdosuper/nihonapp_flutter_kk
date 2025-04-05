import 'package:flutter/material.dart';
import 'package:duandemo/model/Sentence.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class OnionScreen extends StatefulWidget {
  final String onionTitle;
  final List<Sentence> sentences;

  OnionScreen({required this.onionTitle, required this.sentences});

  @override
  _OnionScreenState createState() => _OnionScreenState();
}

class _OnionScreenState extends State<OnionScreen> {
  late List<Sentence> sortedSentences;
  int currentIndex = 0;
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool isListening = false; // Trạng thái ghi âm
  String recognizedText = ""; // Văn bản đã ghi nhận

  @override
  void initState() {
    super.initState();
    sortedSentences = widget.sentences
        .map((sentence) => Sentence(
              id: sentence.id,
              word: sentence.word.replaceAll(" ", ""), // Loại bỏ khoảng trắng
              meaning: sentence.meaning,
              transcription: sentence.transcription,
              answer:
                  sentence.answer.replaceAll("　", ""), // Loại bỏ khoảng trắng
              vocabularies: sentence.vocabularies,
            ))
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id)); // Sắp xếp theo id
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    _flutterTts.setErrorHandler((message) {
      print("Lỗi TTS: $message");
    });

    try {
      bool isLanguageAvailable = await _flutterTts.isLanguageAvailable("ja-JP");
      if (isLanguageAvailable) {
        await _flutterTts.setLanguage("ja-JP");
      } else {
        print("Ngôn ngữ 'ja-JP' không được hỗ trợ.");
      }
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setPitch(1.0);
    } catch (e) {
      print("Lỗi khi khởi tạo TTS: $e");
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    try {
      await _flutterTts.speak(text);
    } catch (e) {
      print("Lỗi khi gọi TTS: $e");
    }
  }

  void _toggleListening() async {
    if (isListening) {
      _speech.stop();
      setState(() => isListening = false);
      _showResultDialog(); // Hiển thị popup sau khi dừng ghi âm
    } else {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );

      if (available) {
        setState(() {
          isListening = true;
          recognizedText = "";
        });

        _speech.listen(
          onResult: (val) {
            setState(() {
              recognizedText = val.recognizedWords;
            });
          },
          localeId: "ja-JP",
        );
      } else {
        print("Speech recognition không khả dụng.");
      }
    }
  }

  // Hàm tính tỷ lệ trùng khớp giữa hai chuỗi
  int calculateMatchPercentage(String answer, String response) {
    if (answer.isEmpty || response.isEmpty) return 0;

    // Chuyển chuỗi thành ký tự để so sánh chính xác
    final answerChars = answer.characters.toList();
    final responseChars = response.characters.toList();

    int matchCount = 0;
    int minLength = answerChars.length < responseChars.length
        ? answerChars.length
        : responseChars.length;

    for (int i = 0; i < minLength; i++) {
      if (answerChars[i] == responseChars[i]) {
        matchCount++;
      }
    }

    return ((matchCount / answerChars.length) * 100).round();
  }

// Cập nhật trong phần _showResultDialog()
  void _showResultDialog() {
    final currentSentence = sortedSentences[currentIndex];
    int matchPercentage =
        calculateMatchPercentage(currentSentence.answer, recognizedText);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Kết quả"),
          content: Text(
            "Bạn đã nói: \"$recognizedText\".\n\n"
            "Độ trùng khớp với đáp án: $matchPercentage%\n\n"
            "Bạn muốn làm gì tiếp theo?",
          ),
          actions: [
            TextButton(
              child: Text("Nói lại"),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng popup
              },
            ),
            TextButton(
              child: Text("Câu tiếp theo"),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng popup
                _goToNextSentence();
              },
            ),
          ],
        );
      },
    );
  }

  // void _showResultDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Kết quả"),
  //         content: Text(
  //           "Bạn đã nói: \"$recognizedText\".\nBạn muốn làm gì tiếp theo?",
  //         ),
  //         actions: [
  //           TextButton(
  //             child: Text("Nói lại"),
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Đóng popup
  //             },
  //           ),
  //           TextButton(
  //             child: Text("Câu tiếp theo"),
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Đóng popup
  //               _goToNextSentence();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _goToNextSentence() {
    if (currentIndex < sortedSentences.length - 1) {
      setState(() {
        currentIndex++;
        recognizedText = ""; // Reset văn bản ghi nhận
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Hoàn thành bài học"),
          content: Text("Chúc mừng! Bạn đã hoàn thành tất cả các câu."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Quay về màn hình trước
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentSentence = sortedSentences[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.onionTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              currentSentence.word,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _speak(currentSentence.word),
            child: Text("Nghe câu mẫu"),
          ),
          SizedBox(height: 32),
          Text(
            "Bạn đang nói:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              recognizedText,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _toggleListening,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isListening ? Colors.red : Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  isListening ? "Tạm dừng" : "Bắt đầu nói",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
