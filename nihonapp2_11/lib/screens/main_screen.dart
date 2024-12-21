import 'package:flutter/material.dart';
import 'topic_screen.dart';
import 'onion_screen.dart';
import 'gym_screen.dart';
import 'profile_screen.dart';
import 'chat_screen.dart'; // Import màn hình Chat
import 'onion_topic_screen.dart';
import 'package:duandemo/screens/WordChainGame.dart';
import 'chat_homescreen.dart'; // Import ChatHomescreen

class MainScreen extends StatefulWidget {
  final int level;

  MainScreen({required this.level});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Chỉ mục hiện tại
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      TopicScreen(level: widget.level), // Màn hình Học
      OnionTopicScreen(level: widget.level), // Màn hình Onion
      WordChainGame(), // Màn hình Gym
      ChatHomescreen(), // Màn hình Chat
      ProfileScreen(), // Màn hình Profile
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // Cập nhật chỉ mục hiện tại
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Hiển thị màn hình tương ứng
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.school), // Biểu tượng cho mục "Học"
            label: 'Học',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb), // Biểu tượng cho mục "Onion"
            label: 'Onion',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center), // Biểu tượng cho mục "Gym"
            label: 'Gym',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat), // Biểu tượng cho mục "Chat"
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Biểu tượng cho mục "Profile"
            label: 'Profile',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal.shade900, // Màu cho mục được chọn
        unselectedItemColor: Colors.grey, // Màu cho mục không được chọn
        backgroundColor: Colors.teal.shade100, // Màu nền thanh navigation
        onTap: _onItemTapped,
      ),
    );
  }
}
