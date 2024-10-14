import 'package:flutter/material.dart';
import 'topic_screen.dart';
import 'onion_screen.dart';
import 'gym_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  final int level;

  MainScreen({required this.level});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.add(TopicScreen(level: widget.level));
    _screens.add(OnionScreen()); // Thêm màn hình Onion
    _screens.add(GymScreen()); // Thêm màn hình Gym
    _screens.add(ProfileScreen()); // Thêm màn hình Profile
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('APP HỖ TRỢ HỌC TIẾNG NHẬT GIAO TIẾP'),
         automaticallyImplyLeading: false, // Ẩn nút quay lại
      ),
      body: _screens[_currentIndex], // Hiển thị màn hình hiện tại
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.school), // Không cần chỉ định màu tại đây
            label: 'Học',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb), // Không cần chỉ định màu tại đây
            label: 'Onion',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center), // Không cần chỉ định màu tại đây
            label: 'Gym',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Không cần chỉ định màu tại đây
            label: 'Profile',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black, // Màu cho mục được chọn
        unselectedItemColor: Colors.black54, // Màu cho mục không được chọn
        onTap: _onItemTapped,
      ),
    );
  }
}
