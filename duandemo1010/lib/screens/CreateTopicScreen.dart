import 'package:duandemo/model/Topic.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateTopicScreen extends StatefulWidget {
  @override
  _CreateTopicScreenState createState() => _CreateTopicScreenState();
}

class _CreateTopicScreenState extends State<CreateTopicScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  bool _isLoading = false;

  Future<void> createTopic(String name, String title) async {
    setState(() {
      _isLoading = true;
    });
    Topic topic = Topic(id: int.parse(title), name: name, lessons: []);
    print(topic);
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/topic'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: topic.toJson(),

      // body: jsonEncode(<String, dynamic>{
      //   'name': name,
      //   'id': int.parse(title),
      // }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      // Nếu thành công, có thể hiển thị thông báo hoặc điều hướng
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Topic created successfully!')),
      );
    } else {
      // Nếu có lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create topic')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Topic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          createTopic(
                            _nameController.text,
                            _titleController.text,
                          );
                        }
                      },
                      child: Text('Create Topic'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
