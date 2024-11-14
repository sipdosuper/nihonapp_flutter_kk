import 'package:flutter/material.dart';
import 'main_screen.dart'; // Đừng quên import MainScreen

class LevelSelectionScreen extends StatefulWidget {
  @override
  _LevelSelectionScreenState createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  void _navigateToMainScreen(int level) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainScreen(level: level)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade500,
        title: Text(
          'Chọn Cấp Độ',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.teal.shade100, // Thay thế gradient bằng màu teal nhạt
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBlockItem('N5', 5, Colors.lightBlue.shade300,
                Icons.directions_walk, 'Khởi đầu dễ dàng'),
            _buildBlockItem('N4', 4, Colors.green.shade400,
                Icons.directions_bike, 'Tiến bộ nhanh chóng'),
            _buildBlockItem('N3', 3, Colors.yellow.shade600, Icons.motorcycle,
                'Thách thức bắt đầu'),
            _buildBlockItem('N2', 2, Colors.orange.shade600,
                Icons.directions_car, 'Vượt qua thử thách'),
            _buildBlockItem(
                'N1', 1, Colors.red.shade600, Icons.flight, 'Đạt đến đỉnh cao'),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockItem(
      String title, int level, Color color, IconData icon, String subtitle) {
    return GestureDetector(
      onTap: () => _navigateToMainScreen(level),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 30,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}
