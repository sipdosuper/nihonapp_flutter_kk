import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _levelIdController = TextEditingController();

  final TextEditingController _lessonIdController = TextEditingController();
  final TextEditingController _lessonTitleController = TextEditingController();
  final TextEditingController _lessonTopicIdController =
      TextEditingController();

  final TextEditingController _sentenceWordController = TextEditingController();
  final TextEditingController _sentenceMeaningController =
      TextEditingController();
  final TextEditingController _sentenceTranscriptionController =
      TextEditingController();
  final TextEditingController _sentenceAnswerController =
      TextEditingController();
  final TextEditingController _sentenceLessonIdController =
      TextEditingController();

  final TextEditingController _vocabIdController = TextEditingController();
  final TextEditingController _vocabWordController = TextEditingController();
  final TextEditingController _vocabMeaningController = TextEditingController();
  final TextEditingController _vocabTranscriptionController =
      TextEditingController();
  final TextEditingController _vocabExampleController = TextEditingController();

  List<dynamic> _topics = [];

  @override
  void initState() {
    super.initState();
    _fetchTopics();
  }

  Future<void> _fetchTopics() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/topic'));
    if (response.statusCode == 200) {
      setState(() {
        _topics = json.decode(utf8.decode(response.bodyBytes));
      });
    } else {
      throw Exception('Failed to load topics');
    }
  }

  Future<void> _addTopic() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/topic'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': int.parse(_idController.text),
          'name': _nameController.text,
          'level_id': int.parse(_levelIdController.text),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Đã thêm Topic thành công')));
        _fetchTopics();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Thêm Topic thất bại: ${response.body}')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi: $error')));
    }
  }

  Future<void> _addLesson() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/lesson'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': int.parse(_lessonIdController.text),
          'title': _lessonTitleController.text,
          'topic_id': int.parse(_lessonTopicIdController.text),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Đã thêm Lesson thành công')));
        _fetchTopics();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Thêm Lesson thất bại: ${response.body}')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi: $error')));
    }
  }

  Future<void> _addSentence() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/sentence'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': int.parse(_sentenceLessonIdController.text),
          'word': _sentenceWordController.text,
          'meaning': _sentenceMeaningController.text,
          'transcription': _sentenceTranscriptionController.text,
          'answer': _sentenceAnswerController.text,
          'lesson_id': int.parse(_sentenceLessonIdController.text),
          'onion_id': 1,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đã thêm Sentence thành công')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Thêm Sentence thất bại: ${response.body}')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi: $error')));
    }
  }

  Future<void> _addVocabulary() async {
    try {
      final int? id = int.tryParse(_vocabIdController.text);
      if (id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ID phải là một số nguyên hợp lệ')));
        return;
      }

      final response = await http.post(
        Uri.parse('http://localhost:8080/api/vocabulary'),
        headers: {'Content-Type': 'application/json;charset=UTF-8'},
        body: jsonEncode({
          'id': id,
          'word': _vocabWordController.text,
          'meaning': _vocabMeaningController.text,
          'transcription': _vocabTranscriptionController.text,
          'example': _vocabExampleController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đã thêm Vocabulary thành công')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Thêm Vocabulary thất bại: ${response.body}')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi: $error')));
    }
  }

  Future<void> _deleteTopic(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận'),
        content: Text('Bạn có chắc chắn muốn xóa Topic này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final response =
          await http.delete(Uri.parse('http://localhost:8080/api/topic/$id'));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Đã xóa Topic thành công')));
        _fetchTopics();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Xóa Topic thất bại: ${response.statusCode}')));
      }
    }
  }

  Future<void> _deleteLesson(int id) async {
    final response =
        await http.delete(Uri.parse('http://localhost:8080/api/lesson/$id'));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Đã xóa Lesson thành công')));
      _fetchTopics();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Xóa Lesson thất bại')));
    }
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý dữ liệu Admin'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form thêm Topic
            Card(
              margin: EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Thêm Topic',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    TextField(
                      controller: _idController,
                      decoration: InputDecoration(labelText: 'ID Topic'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Tên Topic'),
                    ),
                    TextField(
                      controller: _levelIdController,
                      decoration: InputDecoration(labelText: 'ID Level'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _addTopic,
                      icon: Icon(Icons.add),
                      label: Text('Thêm Topic'),
                    ),
                  ],
                ),
              ),
            ),

            // Form thêm Lesson
            Card(
              margin: EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Thêm Lesson',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    TextField(
                      controller: _lessonIdController,
                      decoration: InputDecoration(labelText: 'ID Lesson'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _lessonTitleController,
                      decoration: InputDecoration(labelText: 'Tiêu đề Lesson'),
                    ),
                    TextField(
                      controller: _lessonTopicIdController,
                      decoration:
                          InputDecoration(labelText: 'ID Topic liên kết'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _addLesson,
                      icon: Icon(Icons.add),
                      label: Text('Thêm Lesson'),
                    ),
                  ],
                ),
              ),
            ),

            // Form thêm Sentence
            Card(
              margin: EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Thêm Sentence',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    TextField(
                      controller: _sentenceWordController,
                      decoration: InputDecoration(labelText: 'Word'),
                    ),
                    TextField(
                      controller: _sentenceMeaningController,
                      decoration: InputDecoration(labelText: 'Meaning'),
                    ),
                    TextField(
                      controller: _sentenceTranscriptionController,
                      decoration: InputDecoration(labelText: 'Transcription'),
                    ),
                    TextField(
                      controller: _sentenceAnswerController,
                      decoration: InputDecoration(labelText: 'Answer'),
                    ),
                    TextField(
                      controller: _sentenceLessonIdController,
                      decoration: InputDecoration(labelText: 'Lesson ID'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _addSentence,
                      icon: Icon(Icons.add),
                      label: Text('Thêm Sentence'),
                    ),
                  ],
                ),
              ),
            ),

            // Form thêm Vocabulary
            Card(
              margin: EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Thêm Vocabulary',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    TextField(
                      controller: _vocabIdController,
                      keyboardType:
                          TextInputType.number, // Chỉ cho phép nhập số
                      decoration: InputDecoration(labelText: 'ID'),
                    ),
                    TextField(
                      controller: _vocabWordController,
                      decoration: InputDecoration(labelText: 'Word'),
                    ),
                    TextField(
                      controller: _vocabMeaningController,
                      decoration: InputDecoration(labelText: 'Meaning'),
                    ),
                    TextField(
                      controller: _vocabTranscriptionController,
                      decoration: InputDecoration(labelText: 'Transcription'),
                    ),
                    TextField(
                      controller: _vocabExampleController,
                      decoration: InputDecoration(labelText: 'Example'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _addVocabulary,
                      icon: Icon(Icons.add),
                      label: Text('Thêm Vocabulary'),
                    ),
                  ],
                ),
              ),
            ),

            // Danh sách các Topic
            Text('Danh sách Topic:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _topics.length,
              itemBuilder: (context, index) {
                final topic = _topics[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                  child: ExpansionTile(
                    title: Text(topic['name']),
                    children: [
                      for (var lesson in topic['lessons'])
                        ListTile(
                          title: Text(lesson['title']),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteLesson(lesson['id']),
                          ),
                        ),
                      ListTile(
                        title: Text('Xóa Topic',
                            style: TextStyle(color: Colors.red)),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTopic(topic['id']),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
