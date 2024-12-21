import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class ChatScreen extends StatefulWidget {
  String chatId;
  final String currentUserId;
  final String receiverId;

  ChatScreen({
    required this.chatId,
    required this.currentUserId,
    required this.receiverId,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  late stt.SpeechToText _speechToText;
  bool _isListening = false;

  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
    // Kiểm tra sự tồn tại của chatId
    _checkAndSetChatId();
  }

  Future<void> _checkAndSetChatId() async {
    final chatDoc = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .get();

    if (!chatDoc.exists) {
      setState(() {
        widget.chatId = '${widget.receiverId}_${widget.currentUserId}';
      });

      // Tạo chatId mới trong Firestore nếu cần
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .set({
        'users': [
          widget.currentUserId,
          widget.receiverId
        ], // Lưu thông tin người dùng trong cuộc trò chuyện
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  // Speech-to-Text function
  void _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      _speechToText.listen(
        onResult: (result) {
          setState(() {
            messageController.text =
                result.recognizedWords; // Lấy văn bản nhận diện
          });
        },
        localeId: "ja-JP", // Thiết lập tiếng Nhật
      );
    }
  }

  void _stopListening() {
    _speechToText.stop();
    setState(() => _isListening = false);
  }

  // Text-to-Speech function
  void _speak(String text) async {
    await _flutterTts.setLanguage("ja-JP");
    await _flutterTts.setSpeechRate(1);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  // Send message to Firestore
  void _sendMessage() async {
    final messageText = messageController.text.trim();
    if (messageText.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
        'senderId': widget.currentUserId,
        'receiverId': widget.receiverId,
        'message': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat with ${widget.receiverId}")),
      body: Column(
        children: [
          // Message list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  controller: scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message['senderId'] == widget.currentUserId;
                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Text(
                                message['message'],
                                style: TextStyle(
                                    color: isMe ? Colors.white : Colors.black),
                              ),
                            ),
                            SizedBox(width: 5),
                            if (!isMe)
                              IconButton(
                                icon:
                                    Icon(Icons.volume_up, color: Colors.black),
                                onPressed: () => _speak(message['message']),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Input field with STT integration
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Enter message",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: () {
                    if (_isListening) {
                      _stopListening();
                    } else {
                      _startListening();
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Text("Send"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
