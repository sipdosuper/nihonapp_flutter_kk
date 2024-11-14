import 'package:flutter/material.dart';

class OnionScreen extends StatefulWidget {
  @override
  _OnionScreenState createState() => _OnionScreenState();
}

class _OnionScreenState extends State<OnionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Màn hình Onion'),
      ),
      body: Center(
        child: Text('Nội dung của màn hình Onion'),
      ),
    );
  }
}
