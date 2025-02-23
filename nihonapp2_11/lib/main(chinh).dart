import 'package:flutter/material.dart';
import 'package:duandemo/screens/chat_homescreen.dart';
import 'package:duandemo/screens/profile_screen.dart';
import 'package:duandemo/screens/lesson_list_screen.dart';
import 'package:duandemo/screens/onion_topic_screen.dart';
import 'package:duandemo/screens/topic_screen_like_duolingo.dart';
import 'package:duandemo/screens/level_selection_screen.dart';
import 'package:duandemo/screens/login_screen.dart';
import 'package:duandemo/screens/WordChainGame.dart';
import 'package:duandemo/model/Topic.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Học Tiếng Nhật',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: LoginScreen(), // Màn hình đầu tiên là Đăng Nhập
    );
  }
}

class MainScreen extends StatefulWidget {
  final int level;

  MainScreen({required this.level});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(level: widget.level),
      LessonListScreen(topic: Topic(id: widget.level, name: 'Mặc định', lessons: [], onions: [])),
      ChatHomescreen(),
      ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang Chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Khóa Học'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final int level;
  final String username = "dangkhoa";
  final String email = "khoa@gmail.com";

  HomeScreen({required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Chủ'),
        backgroundColor: Color(0xFFE57373), // Màu đỏ nhạt
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFFE57373), // Màu đỏ nhạt
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Xin chào, $username!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Email: $email',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: GridView.count(
                crossAxisCount: 3,
                padding: EdgeInsets.all(16.0),
                children: [
                  _buildFeatureButton(context, Icons.school, 'Học Câu', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopicScreen2(level: level),
                      ),
                    );
                  }),
                  _buildFeatureButton(context, Icons.book, 'Đọc Câu', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OnionTopicScreen(level: level),
                      ),
                    );
                  }),
                  _buildFeatureButton(context, Icons.videogame_asset, 'Chơi Game', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WordChainGame(),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.red.shade100,
            child: Icon(icon, size: 30, color: Colors.red),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
