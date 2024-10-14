import 'package:flutter/material.dart';

class GymScreen extends StatefulWidget {
  @override
  _GymScreenState createState() => _GymScreenState();
}

class _GymScreenState extends State<GymScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Màn hình Gym'),
      ),
      body: Center(
        child: Text(
          'Nội dung của màn hình Gym',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
