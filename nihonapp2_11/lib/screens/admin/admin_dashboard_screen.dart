import 'dart:convert';
import 'package:duandemo/model/Role.dart';
import 'package:duandemo/screens/Roles/AddRoleScreen.dart';
import 'package:duandemo/screens/Fl_Chart/user_level_pear_chart.dart';
import 'package:duandemo/screens/Fl_Chart/user_stats_bar_chart_screen.dart';
import 'package:duandemo/screens/cousers/CourseListScreen.dart';
import 'package:duandemo/screens/form/list_student_form_screen.dart';
import 'package:duandemo/screens/form/list_teacher_form_screen.dart';
import 'package:duandemo/screens/time/time_screen.dart';
import 'package:duandemo/word_val.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../authentication/login_screen.dart';

//-----------------------------------------------------
// AdminDashboardScreen
//-----------------------------------------------------
class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // API endpoints
  final String api_topic = Wordval().api + 'topic';
  final String api_lesson = Wordval().api + 'lesson';
  final String api_sentence = Wordval().api + 'sentence';
  final String api_vocabulary = Wordval().api + 'vocabulary';

  // Controllers cho Topic
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _levelIdController = TextEditingController();

  // Controllers cho Lesson
  final TextEditingController _lessonIdController = TextEditingController();
  final TextEditingController _lessonTitleController = TextEditingController();
  final TextEditingController _lessonTopicIdController =
      TextEditingController();

  // Controllers cho Sentence
  final TextEditingController _sentenceWordController = TextEditingController();
  final TextEditingController _sentenceMeaningController =
      TextEditingController();
  final TextEditingController _sentenceTranscriptionController =
      TextEditingController();
  final TextEditingController _sentenceAnswerController =
      TextEditingController();
  final TextEditingController _sentenceLessonIdController =
      TextEditingController();

  // Controllers cho Vocabulary
  final TextEditingController _vocabIdController = TextEditingController();
  final TextEditingController _vocabWordController = TextEditingController();
  final TextEditingController _vocabMeaningController = TextEditingController();
  final TextEditingController _vocabTranscriptionController =
      TextEditingController();
  final TextEditingController _vocabExampleController = TextEditingController();

  // Các biến lưu danh sách dữ liệu lấy từ API
  List<dynamic> _topics = [];
  List<dynamic> _lessons = [];

  // Biến để xác định danh mục đang chọn (mặc định là Topic)
  String _selectedCategory = 'Topic';

  // Biến để quản lý trạng thái mở/đóng sidebar
  bool _isSidebarOpen = true;

  @override
  void initState() {
    super.initState();
    _fetchTopics();
    _fetchLessons();
  }

  // Hàm lấy danh sách Topic
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

  // Hàm lấy danh sách Lesson
  Future<void> _fetchLessons() async {
    final response = await http.get(Uri.parse(api_lesson));
    if (response.statusCode == 200) {
      setState(() {
        _lessons = json.decode(utf8.decode(response.bodyBytes));
      });
    } else {
      throw Exception('Failed to load lessons');
    }
  }

  // Hàm thêm Topic
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

  // Hàm thêm Lesson
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

  // Hàm thêm Sentence
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

  // Hàm thêm Vocabulary
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

  // Hàm xóa Topic
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

  // Hàm xóa Lesson
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

  // Hàm xóa Sentence
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

  // Hàm đăng xuất
  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  // Hàm xây dựng giao diện dựa trên danh mục được chọn
  Widget _buildForm() {
    switch (_selectedCategory) {
      case 'USBarChart':
        return UserStatsBarChartScreen();
      case 'ULPearChart':
        return UserLevelPieChartScreen();
      case 'Time':
        return TimeManagementScreen();
      case 'ClassRoom':
        return CourseListScreen(email: "");
      case 'Student Form':
        return StudentRegistrationListScreen();
      case 'Teacher Form':
        return TeacherRegistrationFormListScreen(
          onDataChanged: () {
            setState(() {});
          },
        );
      case 'LessonSection':
        return LessonSectionScreen();
      case 'Role':
        return RoleScreen();
      default:
        return Column(
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID Topic'),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Tên Topic'),
            ),
            TextField(
              controller: _levelIdController,
              decoration: InputDecoration(labelText: 'Level ID'),
            ),
            ElevatedButton(onPressed: _addTopic, child: Text('Thêm Topic')),
            SizedBox(height: 20),
            Text(
              'Danh sách Topic:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Expanded(
              child: ListView.builder(
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
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        backgroundColor: Color(0xFFE57373),
        // Nút toggle sidebar ở leading
        leading: IconButton(
          icon: Icon(
              _isSidebarOpen ? Icons.arrow_back_ios : Icons.arrow_forward_ios),
          onPressed: () {
            setState(() {
              _isSidebarOpen = !_isSidebarOpen;
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: Row(
        children: [
          // Sidebar với AnimatedContainer
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: _isSidebarOpen ? 200 : 60,
            color: Colors.grey[200],
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.bar_chart),
                    title: _isSidebarOpen ? Text('User Stats BarChart') : null,
                    selected: _selectedCategory == 'USBarChart',
                    selectedTileColor: Color(0xFFE57373).withOpacity(0.3),
                    onTap: () =>
                        setState(() => _selectedCategory = 'USBarChart'),
                  ),
                  ListTile(
                    leading: Icon(Icons.pie_chart),
                    title: _isSidebarOpen ? Text('User Level PearChart') : null,
                    selected: _selectedCategory == 'ULPearChart',
                    selectedTileColor: Color(0xFFE57373).withOpacity(0.3),
                    onTap: () =>
                        setState(() => _selectedCategory = 'ULPearChart'),
                  ),
                  ListTile(
                    leading: Icon(Icons.access_time),
                    title: _isSidebarOpen ? Text('Time') : null,
                    selected: _selectedCategory == 'Time',
                    selectedTileColor: Color(0xFFE57373).withOpacity(0.3),
                    onTap: () => setState(() => _selectedCategory = 'Time'),
                  ),
                  ListTile(
                    leading: Icon(Icons.class_),
                    title: _isSidebarOpen ? Text('ClassRoom') : null,
                    selected: _selectedCategory == 'ClassRoom',
                    selectedTileColor: Color(0xFFE57373).withOpacity(0.3),
                    onTap: () =>
                        setState(() => _selectedCategory = 'ClassRoom'),
                  ),
                  ListTile(
                    leading: Icon(Icons.people_alt),
                    title: _isSidebarOpen ? Text('Student Form') : null,
                    selected: _selectedCategory == 'Student Form',
                    selectedTileColor: Color(0xFFE57373).withOpacity(0.3),
                    onTap: () =>
                        setState(() => _selectedCategory = 'Student Form'),
                  ),
                  ListTile(
                    leading: Icon(Icons.person_outline),
                    title: _isSidebarOpen ? Text('Teacher Form') : null,
                    selected: _selectedCategory == 'Teacher Form',
                    selectedTileColor: Color(0xFFE57373).withOpacity(0.3),
                    onTap: () =>
                        setState(() => _selectedCategory = 'Teacher Form'),
                  ),
                  ListTile(
                    leading: Icon(Icons.book),
                    title: _isSidebarOpen ? Text('Phần Bài Học') : null,
                    selected: _selectedCategory == 'LessonSection',
                    selectedTileColor: Color(0xFFE57373).withOpacity(0.3),
                    onTap: () =>
                        setState(() => _selectedCategory = 'LessonSection'),
                  ),
                  ListTile(
                    leading: Icon(Icons.admin_panel_settings),
                    title: _isSidebarOpen ? Text('Role') : null,
                    selected: _selectedCategory == 'Role',
                    selectedTileColor: Color(0xFFE57373).withOpacity(0.3),
                    onTap: () => setState(() => _selectedCategory = 'Role'),
                  ),
                ],
              ),
            ),
          ),
          // Nội dung chính
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

//-----------------------------------------------------
// LessonSectionScreen: Gộp Topic, Lesson, Sentence, Vocabulary
//-----------------------------------------------------
class LessonSectionScreen extends StatefulWidget {
  @override
  _LessonSectionScreenState createState() => _LessonSectionScreenState();
}

class _LessonSectionScreenState extends State<LessonSectionScreen> {
  // API endpoints
  final String api_topic = Wordval().api + 'topic';
  final String api_lesson = Wordval().api + 'lesson';
  final String api_sentence = Wordval().api + 'sentence';
  final String api_vocabulary = Wordval().api + 'vocabulary';

  // Controllers cho Topic
  final TextEditingController _topicIdController = TextEditingController();
  final TextEditingController _topicNameController = TextEditingController();
  final TextEditingController _topicLevelIdController = TextEditingController();

  // Controllers cho Lesson
  final TextEditingController _lessonIdController = TextEditingController();
  final TextEditingController _lessonTitleController = TextEditingController();
  final TextEditingController _lessonTopicIdController =
      TextEditingController();

  // Controllers cho Sentence
  final TextEditingController _sentenceWordController = TextEditingController();
  final TextEditingController _sentenceMeaningController =
      TextEditingController();
  final TextEditingController _sentenceTranscriptionController =
      TextEditingController();
  final TextEditingController _sentenceAnswerController =
      TextEditingController();
  final TextEditingController _sentenceLessonIdController =
      TextEditingController();

  // Controllers cho Vocabulary
  final TextEditingController _vocabWordController = TextEditingController();
  final TextEditingController _vocabMeaningController = TextEditingController();
  final TextEditingController _vocabTranscriptionController =
      TextEditingController();
  final TextEditingController _vocabExampleController = TextEditingController();

  // Dữ liệu từ API
  List<dynamic> _topics = [];
  List<dynamic> _lessons = [];

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
        _topics = (response.bodyBytes.isNotEmpty)
            ? List<dynamic>.from(json.decode(utf8.decode(response.bodyBytes)))
            : [];
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Lỗi tải Topic")));
    }
  }

  Future<void> _fetchLessons() async {
    final response = await http.get(Uri.parse(api_lesson));
    if (response.statusCode == 200) {
      setState(() {
        _lessons = (response.bodyBytes.isNotEmpty)
            ? List<dynamic>.from(json.decode(utf8.decode(response.bodyBytes)))
            : [];
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Lỗi tải Lesson")));
    }
  }

  Future<void> _addTopic() async {
    try {
      final response = await http.post(
        Uri.parse(api_topic),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': int.parse(_topicIdController.text),
          'name': _topicNameController.text,
          'level_id': int.parse(_topicLevelIdController.text),
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
        _fetchLessons();
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Phần Bài Học"),
          backgroundColor: Color(0xFFE57373),
          bottom: TabBar(
            tabs: [
              Tab(text: "Topic"),
              Tab(text: "Lesson"),
              Tab(text: "Sentence"),
              Tab(text: "Vocabulary"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Topic Tab
            Column(
              children: [
                TextField(
                  controller: _topicIdController,
                  decoration: InputDecoration(labelText: 'ID Topic'),
                ),
                TextField(
                  controller: _topicNameController,
                  decoration: InputDecoration(labelText: 'Tên Topic'),
                ),
                TextField(
                  controller: _topicLevelIdController,
                  decoration: InputDecoration(labelText: 'Level ID'),
                ),
                ElevatedButton(onPressed: _addTopic, child: Text('Thêm Topic')),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _topics.length,
                    itemBuilder: (context, index) {
                      final topic = _topics[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        child: ExpansionTile(
                          title: Text(topic['name']),
                          children: [
                            for (var lesson in topic['lessons'] ?? [])
                              ListTile(
                                title: Text(lesson['title']),
                              ),
                            ListTile(
                              title: Text('Xóa Topic',
                                  style: TextStyle(color: Colors.red)),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Nơi thực hiện xóa Topic nếu cần
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            // Lesson Tab
            Column(
              children: [
                TextField(
                  controller: _lessonIdController,
                  decoration: InputDecoration(labelText: 'ID Lesson'),
                ),
                TextField(
                  controller: _lessonTitleController,
                  decoration: InputDecoration(labelText: 'Tiêu đề Lesson'),
                ),
                TextField(
                  controller: _lessonTopicIdController,
                  decoration: InputDecoration(labelText: 'Topic ID'),
                ),
                ElevatedButton(
                    onPressed: _addLesson, child: Text('Thêm Lesson')),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = _lessons[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        child: ExpansionTile(
                          title: Text(lesson['title']),
                          children: [
                            for (var sentence in lesson['sentences'] ?? [])
                              ListTile(
                                title: Text(sentence['word']),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    // Nơi thực hiện xóa Sentence nếu cần
                                  },
                                ),
                              ),
                            ListTile(
                              title: Text('Xóa Lesson',
                                  style: TextStyle(color: Colors.red)),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Nơi thực hiện xóa Lesson nếu cần
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            // Sentence Tab
            SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _sentenceWordController,
                    decoration: InputDecoration(labelText: 'Từ'),
                  ),
                  TextField(
                    controller: _sentenceMeaningController,
                    decoration: InputDecoration(labelText: 'Nghĩa'),
                  ),
                  TextField(
                    controller: _sentenceTranscriptionController,
                    decoration: InputDecoration(labelText: 'Phiên âm'),
                  ),
                  TextField(
                    controller: _sentenceAnswerController,
                    decoration: InputDecoration(labelText: 'Câu trả lời'),
                  ),
                  TextField(
                    controller: _sentenceLessonIdController,
                    decoration: InputDecoration(labelText: 'Lesson ID'),
                  ),
                  ElevatedButton(
                      onPressed: _addSentence, child: Text('Thêm Sentence')),
                ],
              ),
            ),
            // Vocabulary Tab
            SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _vocabWordController,
                    decoration: InputDecoration(labelText: 'Từ'),
                  ),
                  TextField(
                    controller: _vocabMeaningController,
                    decoration: InputDecoration(labelText: 'Nghĩa'),
                  ),
                  TextField(
                    controller: _vocabTranscriptionController,
                    decoration: InputDecoration(labelText: 'Phiên âm'),
                  ),
                  TextField(
                    controller: _vocabExampleController,
                    decoration: InputDecoration(labelText: 'Ví dụ'),
                  ),
                  ElevatedButton(
                      onPressed: _addVocabulary,
                      child: Text('Thêm Vocabulary')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//-----------------------------------------------------
// RoleScreen: Màn hình quản lý Role
//-----------------------------------------------------
class RoleScreen extends StatefulWidget {
  const RoleScreen({Key? key}) : super(key: key);

  @override
  _RoleScreenState createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  late Future<List<Role>> _futureRoles;
  final Color primaryColor = Color(0xFFE57373);

  @override
  void initState() {
    super.initState();
    _futureRoles = fetchRoles();
  }

  // Hàm lấy danh sách Role từ backend
  Future<List<Role>> fetchRoles() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/role'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => Role.fromJson(json)).toList();
    } else {
      throw Exception('Không thể tải danh sách Role');
    }
  }

  // Hàm refresh danh sách Role
  void refreshRoles() {
    setState(() {
      _futureRoles = fetchRoles();
    });
  }

  // Hàm xóa Role theo id
  Future<void> _deleteRole(int roleId) async {
    print(roleId);
    final url = Uri.parse('http://localhost:8080/api/role/delete/$roleId');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa Role thành công')),
        );
        refreshRoles();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Xóa Role thất bại, mã lỗi: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Danh sách Roles',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Role>>(
          future: _futureRoles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Không có Role nào'));
            } else {
              final roles = snapshot.data!;
              return ListView.builder(
                itemCount: roles.length,
                itemBuilder: (context, index) {
                  final role = roles[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: primaryColor,
                        child: Text(
                          role.id.toString(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        role.name,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          // Hiển thị dialog xác nhận xóa
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Xác nhận'),
                              content: Text(
                                  'Bạn có chắc muốn xóa Role "${role.name}" không?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('Hủy'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _deleteRole(role.id);
                                  },
                                  child: Text('Xóa',
                                      style:
                                          TextStyle(color: Colors.redAccent)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRoleScreen()),
          ).then((value) {
            if (value == true) {
              refreshRoles();
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
