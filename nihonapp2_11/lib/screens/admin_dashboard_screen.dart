import 'dart:convert';
import 'package:duandemo/screens/cousers/CourseListScreen.dart';
import 'package:duandemo/screens/form/list_teacher_form_screen.dart';
import 'package:duandemo/screens/form/student_registration_form_item.dart';
import 'package:duandemo/screens/time/time_screen.dart';
import 'package:duandemo/word_val.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final String api_topic = Wordval().api + 'topic';
  final String api_lesson = Wordval().api + 'lesson';
  final String api_sentence = Wordval().api + 'sentence';
  final String api_vocabulary = Wordval().api + 'vocabulary';

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
  List<dynamic> _lessons = [];

  bool _isLoadTime = false;

  @override
  void initState() {
    super.initState();
    _fetchTopics();
    _fetchLessons();
  }

  Future<void> _fetchTopics() async {
    final response = await http.get(Uri.parse(api_topic));
    if (response.statusCode == 200) {
      setState(() {
        _topics = json.decode(utf8.decode(response.bodyBytes));
      });
    } else {
      throw Exception('Failed to load topics');
    }
  }

  Future<void> _fetchLessons() async {
    final response = await http.get(Uri.parse(api_lesson));

    if (response.statusCode == 200) {
      setState(() {
        _lessons = json.decode(utf8.decode(response.bodyBytes));
      });
    } else {
      throw Exception('Failed to load topics');
    }
  }

  Future<void> _addTopic() async {
    try {
      final response = await http.post(
        Uri.parse(api_topic),
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
        Uri.parse(api_lesson),
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
        Uri.parse(api_sentence),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'word': _sentenceWordController.text,
          'meaning': _sentenceMeaningController.text,
          'transcription': _sentenceTranscriptionController.text,
          'answer': _sentenceAnswerController.text,
          'lesson_id': int.parse(_sentenceLessonIdController.text)
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
      final response = await http.post(
        Uri.parse(api_vocabulary),
        headers: {'Content-Type': 'application/json;charset=UTF-8'},
        body: jsonEncode({
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
      final response = await http.delete(Uri.parse(api_topic + '/$id'));
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
    final response = await http.delete(Uri.parse(api_lesson + '/$id'));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Đã xóa Lesson thành công')));
      _fetchTopics();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Xóa Lesson thất bại')));
    }
  }

  Future<void> _deleteSentence(int id) async {
    final response = await http.delete(Uri.parse(api_sentence + '/$id'));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Đã xóa Sentence thành công')));
      _fetchLessons();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Xóa Sentence thất bại')));
    }
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  String _selectedCategory = 'Topic';

  Widget _buildForm() {
    switch (_selectedCategory) {
      case 'Time':
        return TimeManagementScreen();
      case 'ClassRoom':
        return CourseListScreen(
          email: "",
        );
      case 'Student Form':
        return StudentRegistrationFormListScreen();
      case 'Teacher Form':
        return TeacherRegistrationFormListScreen();

      case 'Lesson':
        return Column(
          children: [
            TextField(
                controller: _lessonIdController,
                decoration: InputDecoration(labelText: 'ID Lesson')),
            TextField(
                controller: _lessonTitleController,
                decoration: InputDecoration(labelText: 'Tiêu đề Lesson')),
            TextField(
                controller: _lessonTopicIdController,
                decoration: InputDecoration(labelText: 'Topic ID')),
            ElevatedButton(onPressed: _addLesson, child: Text('Thêm Lesson')),

            //hien thi danh sach lesson
            Text('Danh sách Lesson:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _lessons.length,
              itemBuilder: (context, index) {
                final lesson = _lessons[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                  child: ExpansionTile(
                    title: Text(lesson['title']),
                    children: [
                      for (var sentence in lesson['sentences'])
                        ListTile(
                          title: Text(sentence['word']),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteSentence(sentence['id']),
                          ),
                        ),
                      ListTile(
                        title: Text('Xóa Lesson',
                            style: TextStyle(color: Colors.red)),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteLesson(lesson['id']),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      case 'Sentence':
        return Column(
          children: [
            TextField(
                controller: _sentenceWordController,
                decoration: InputDecoration(labelText: 'Từ')),
            TextField(
                controller: _sentenceMeaningController,
                decoration: InputDecoration(labelText: 'Nghĩa')),
            TextField(
                controller: _sentenceTranscriptionController,
                decoration: InputDecoration(labelText: 'Phiên âm')),
            TextField(
                controller: _sentenceAnswerController,
                decoration: InputDecoration(labelText: 'Câu trả lời')),
            TextField(
                controller: _sentenceLessonIdController,
                decoration: InputDecoration(labelText: 'Lesson ID')),
            ElevatedButton(
                onPressed: _addSentence, child: Text('Thêm Sentence')),
          ],
        );
      case 'Vocabulary':
        return Column(
          children: [
            TextField(
                controller: _vocabWordController,
                decoration: InputDecoration(labelText: 'Từ')),
            TextField(
                controller: _vocabMeaningController,
                decoration: InputDecoration(labelText: 'Nghĩa')),
            TextField(
                controller: _vocabTranscriptionController,
                decoration: InputDecoration(labelText: 'Phiên âm')),
            TextField(
                controller: _vocabExampleController,
                decoration: InputDecoration(labelText: 'Ví dụ')),
            ElevatedButton(
                onPressed: _addVocabulary, child: Text('Thêm Vocabulary')),
          ],
        );
      default:
        return Column(
          children: [
            TextField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'ID Topic')),
            TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Tên Topic')),
            TextField(
                controller: _levelIdController,
                decoration: InputDecoration(labelText: 'Level ID')),
            ElevatedButton(onPressed: _addTopic, child: Text('Thêm Topic')),
            //hien thi danh sach topic
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
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Dashboard")),
      body: Row(
        children: [
          Container(
            width: 200,
            color: Colors.grey[200],
            child: Column(
              children: [
                ListTile(
                    title: Text('Time'),
                    onTap: () => setState(() => _selectedCategory = 'Time')),
                ListTile(
                    title: Text('ClassRoom'),
                    onTap: () =>
                        setState(() => _selectedCategory = 'ClassRoom')),
                ListTile(
                    title: Text('Student Form'),
                    onTap: () =>
                        setState(() => _selectedCategory = 'Student Form')),
                ListTile(
                    title: Text('Teacher Form'),
                    onTap: () =>
                        setState(() => _selectedCategory = 'Teacher Form')),
                ListTile(
                    title: Text('Topic'),
                    onTap: () => setState(() => _selectedCategory = 'Topic')),
                ListTile(
                    title: Text('Lesson'),
                    onTap: () => setState(() => _selectedCategory = 'Lesson')),
                ListTile(
                    title: Text('Sentence'),
                    onTap: () =>
                        setState(() => _selectedCategory = 'Sentence')),
                ListTile(
                    title: Text('Vocabulary'),
                    onTap: () =>
                        setState(() => _selectedCategory = 'Vocabulary')),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildForm(),
            ),
          ),
        ],
      ),
    );
  }
}
