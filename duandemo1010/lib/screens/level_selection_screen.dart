import 'package:flutter/material.dart';
import 'main_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  final List<Map<String, dynamic>> levels = [
    {'label': 'N5', 'value': 5},
    {'label': 'N4', 'value': 4},
    {'label': 'N3', 'value': 3},
    {'label': 'N2', 'value': 2},
    {'label': 'N1', 'value': 1},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn Level'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1.0,
        ),
        padding: EdgeInsets.all(16.0),
        itemCount: levels.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Chuyển tới MainScreen với level tương ứng
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(level: levels[index]['value']),
                ),
              );
            },
            child: Card(
              elevation: 5,
              child: Center(
                child: Text(
                  levels[index]['label'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
