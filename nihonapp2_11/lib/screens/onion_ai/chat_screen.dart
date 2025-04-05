import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive/hive.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:duandemo/service/gemini_service.dart';

class ChatScreen extends StatefulWidget {
  final String initialMessage;
  final String userCharacter;
  final String userGender;
  final String aiCharacter;
  final String aiGender;
  final String description;
  final List<Map<String, dynamic>>? previousMessages;

  const ChatScreen({
    super.key,
    required this.initialMessage,
    required this.userCharacter,
    required this.userGender,
    required this.aiCharacter,
    required this.aiGender,
    required this.description,
    this.previousMessages,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final GeminiService _service = GeminiService();
  final FlutterTts _flutterTts = FlutterTts();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  List<String> _suggestedReplies = [];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initConversationContext();

    if (widget.previousMessages != null &&
        widget.previousMessages!.isNotEmpty) {
      _messages.addAll(widget.previousMessages!);

      final lastAiMessage = widget.previousMessages!.lastWhere(
        (m) => m['sender'] == 'AI',
        orElse: () => {'text': widget.initialMessage},
      );

      _speakJapanese(lastAiMessage['text']);
      _generateSuggestions(lastAiMessage['text']);
    } else {
      _messages.add({
        "text": widget.initialMessage,
        "sender": "AI",
        "translation": null,
      });
      _speakJapanese(widget.initialMessage);
      _generateSuggestions(widget.initialMessage);
    }
  }

  void _initConversationContext() async {
    await _service.generateScenario(
      userCharacter: widget.userCharacter,
      userGender: widget.userGender,
      aiCharacter: widget.aiCharacter,
      aiGender: widget.aiGender,
      description: widget.description,
    );
  }

  Future<void> _speakJapanese(String text) async {
    await _flutterTts.setLanguage("ja-JP");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.9);
    await _flutterTts.speak(text);
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) {
        if (val == 'done') {
          _speech.stop();
          setState(() => _isListening = false);
          if (_controller.text.trim().isNotEmpty) _sendMessage();
        }
      },
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) =>
            setState(() => _controller.text = val.recognizedWords),
        localeId: "ja_JP",
      );
    }
  }

  void _sendMessage([String? message]) async {
    final userMessage = message ?? _controller.text.trim();
    if (userMessage.isEmpty) return;
    _controller.clear();
    _speech.stop();
    setState(() => _isListening = false);

    setState(() => _messages
        .add({"text": userMessage, "sender": "User", "translation": null}));

    try {
      final aiResponse = await _service.chatWithAI(_messages);
      setState(() => _messages
          .add({"text": aiResponse, "sender": "AI", "translation": null}));
      await _speakJapanese(aiResponse);
      _generateSuggestions(aiResponse);
    } catch (e) {
      print('Lỗi gửi tin nhắn: $e');
    }
  }

  void _generateSuggestions(String aiMessage) async {
    try {
      final suggestions = await _service.generateSuggestions(aiMessage);
      setState(() => _suggestedReplies = suggestions);
    } catch (e) {
      print('Lỗi gợi ý: $e');
    }
  }

  void _translateMessage(int index) async {
    final message = _messages[index];
    final originalText = message['text'];
    try {
      final translation = await _service.translateToVietnamese(originalText);
      setState(() => _messages[index]['translation'] = translation);
    } catch (e) {
      print('Lỗi dịch: $e');
    }
  }

  void _replayMessage(String text) => _speakJapanese(text);

  // ✅ Cập nhật: Lưu cuộc trò chuyện kèm timestamp
  void _endAndSaveConversation() async {
    final nameController =
        TextEditingController(); // ❌ KHÔNG tự động điền tên mặc định

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Lưu cuộc trò chuyện"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: "Nhập tên cuộc trò chuyện",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () async {
              final chatName = nameController.text.trim();
              if (chatName.isEmpty) return;

              final box = await Hive.openBox('saved_chats');
              final exists = box.containsKey(chatName);

              final isContinuing = widget.previousMessages != null;

              // ❌ Nếu tạo mới & tên đã tồn tại → báo lỗi
              // ✅ Nếu đang tiếp tục, cho phép ghi đè (kể cả đổi tên)
              if (!isContinuing && exists) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Tên cuộc trò chuyện đã tồn tại. Vui lòng chọn tên khác.",
                    ),
                  ),
                );
                return;
              }

              final timestamp = DateTime.now().toIso8601String();
              await box.put(chatName, {
                'messages': _messages,
                'timestamp': timestamp,
              });

              Navigator.pop(context); // đóng dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isContinuing && exists
                      ? "Đã cập nhật cuộc trò chuyện \"$chatName\""
                      : "Đã lưu cuộc trò chuyện \"$chatName\""),
                ),
              );
              Navigator.pop(context); // thoát màn hình Chat
            },
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(Map<String, dynamic> msg, int index) {
    final bool isUser = msg['sender'] == 'User';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 280),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? Colors.blueAccent : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                msg['text'],
                style: TextStyle(
                    color: isUser ? Colors.white : Colors.black87,
                    fontSize: 16),
              ),
            ),
            if (msg['translation'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
                child: Text(msg['translation'],
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.black87)),
              ),
            Row(
              mainAxisAlignment:
                  isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () => _translateMessage(index),
                  child: const Text('Dịch', style: TextStyle(fontSize: 13)),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up, size: 20),
                  onPressed: () => _replayMessage(msg['text']),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trò chuyện', style: TextStyle(fontSize: 18)),
        elevation: 1,
        actions: [
          IconButton(
            onPressed: _endAndSaveConversation,
            icon: const Icon(Icons.save_alt),
            tooltip: "Kết thúc & Lưu",
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msgIndex = _messages.length - 1 - index;
                return _buildChatBubble(_messages[msgIndex], msgIndex);
              },
            ),
          ),
          if (_suggestedReplies.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _suggestedReplies.map((reply) {
                  return ActionChip(
                    label: Text(reply),
                    onPressed: () => _sendMessage(reply),
                    backgroundColor: Colors.blue[50],
                    labelStyle: const TextStyle(color: Colors.blue),
                  );
                }).toList(),
              ),
            ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Nhập hoặc nói...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.blueAccent),
                  onPressed: _isListening ? null : _startListening,
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
