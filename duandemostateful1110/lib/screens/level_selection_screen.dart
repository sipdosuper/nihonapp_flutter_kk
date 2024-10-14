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
        title: Text('Chọn Cấp Độ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1,
          children: [
            _buildLevelCard('N5', 5),
            _buildLevelCard('N4', 4),
            _buildLevelCard('N3', 3),
            _buildLevelCard('N2', 2),
            _buildLevelCard('N1', 1),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard(String title, int level) {
    return GestureDetector(
      onTap: () {
        _navigateToMainScreen(level);
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
