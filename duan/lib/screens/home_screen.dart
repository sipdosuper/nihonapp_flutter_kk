import 'package:flutter/material.dart';
import 'detail_screen.dart'; // Màn hình chi tiết

class HomeScreen extends StatelessWidget {
  final String userName = "Trần Duy Khánh"; // Tên tài khoản
  final int currentLesson = 1; // Bài học hiện tại

  final List<Map<String, dynamic>> topics = [
    {
      "title": "Chủ đề 1",
      "description": "Tình huống học thử",
      "items": [
        {
          "title": "Vượt qua bài phỏng vấn tuyển dụng",
          "description": "15 Bài học",
          "image": "https://cdn.tgdd.vn//GameApp/1309260//1-800x450.jpg"
        },
        {
          "title": "Chỉ đường cho người nước ngoài",
          "description": "10 Bài học",
          "image": "https://cdn.tgdd.vn//GameApp/1309260//1-800x450.jpg"
        },
      ]
    },
    {
      "title": "Chủ đề 2",
      "description": "Tình huống phỏng vấn",
      "items": [
        {
          "title": "Vượt qua bài phỏng vấn tuyển dụng",
          "description": "15 Bài học",
          "image": "https://cdn.tgdd.vn//GameApp/1309260//1-800x450.jpg"
        },
        {
          "title": "Cách chào hỏi",
          "description": "5 Bài học",
          "image": "https://cdn.tgdd.vn//GameApp/1309260//1-800x450.jpg"
        },
      ]
    },
  ];

  void _navigateToDetail(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailScreen(title: title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xin chào, $userName!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Bạn đang học tới bài: $currentLesson',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, topicIndex) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        topics[topicIndex]['title'],
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        topics[topicIndex]['description'],
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    ...List.generate(topics[topicIndex]['items'].length, (itemIndex) {
                      final item = topics[topicIndex]['items'][itemIndex];
                      return GestureDetector(
                        onTap: () => _navigateToDetail(context, item['title']),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey, width: 2), // Add border
                            image: DecorationImage(
                              image: NetworkImage(item['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      item['title'],
                                      style: TextStyle(color: Colors.white, fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Text(
                                    item['description'],
                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
