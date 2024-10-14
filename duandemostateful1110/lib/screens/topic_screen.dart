import 'package:flutter/material.dart';
import 'learning_screen.dart'; // Đừng quên import LearningScreen

class TopicScreen extends StatefulWidget {
  final int level;

  TopicScreen({required this.level});

  @override
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  final List<Map<String, dynamic>> n5Topics = [
    {
      'title': 'Chủ đề 1',
      'lessons': [
        {
          'title': 'Bài học 1: Giới thiệu về bản thân',
          'description': 'Học cách giới thiệu bản thân bằng tiếng Nhật.',
          'image': 'https://kilala.vn/data/upload/article/10614/arigatou-co-nghia-la-gi.jpg',
          'sentences': _getSentencesForLesson1(),
        },
        {
          'title': 'Bài học 2: Hỏi thăm sức khỏe',
          'description': 'Học cách hỏi thăm sức khỏe bằng tiếng Nhật.',
          'image': 'https://kilala.vn/data/upload/article/10614/arigatou-co-nghia-la-gi.jpg',
          'sentences': _getSentencesForLesson2(),
        },
      ],
    },
    {
      'title': 'Chủ đề 2',
      'lessons': [
        {
          'title': 'Bài học 1: Đặt câu hỏi',
          'description': 'Học cách đặt câu hỏi bằng tiếng Nhật.',
          'image': 'https://kilala.vn/data/upload/article/10614/arigatou-co-nghia-la-gi.jpg',
        },
        {
          'title': 'Bài học 2: Nói về gia đình',
          'description': 'Học cách nói về gia đình bằng tiếng Nhật.',
          'image': 'https://kilala.vn/data/upload/article/10614/arigatou-co-nghia-la-gi.jpg',
        },
      ],
    },
  ];

  final Map<int, List<Map<String, dynamic>>> n4Topics = {
    4: [
      {
        'title': 'Chủ đề 1',
        'lessons': [
          {
            'title': 'Bài học 1: Đàm thoại trong nhà hàng',
            'description': 'Học cách đặt món ăn tại nhà hàng Nhật.',
            'image': 'https://example.com/restaurant.png',
          },
        ],
      },
      {
        'title': 'Chủ đề 2',
        'lessons': [
          {
            'title': 'Bài học 2: Hỏi đường',
            'description': 'Học cách hỏi đường và chỉ đường.',
            'image': 'https://example.com/direction.png',
          },
        ],
      },
    ],
  };

  static List<Map<String, String>> _getSentencesForLesson1() {
    return [
      {
        'japanese': '私は学生です。',
        'vietnamese': 'Tôi là sinh viên.',
        'missingWord': '学生',
        'meaning': 'Nghĩa: Tôi là một sinh viên.',
        'vocabulary': '学生 (がくせい): Sinh viên',
        'grammar': 'です: Dùng để diễn đạt sự xác nhận về một sự thật.',
      },
      {
        'japanese': '私は日本に行きます。',
        'vietnamese': 'Tôi sẽ đi Nhật Bản.',
        'missingWord': '日本',
        'meaning': 'Nghĩa: Tôi sẽ đi đến Nhật Bản.',
        'vocabulary': '日本 (にほん): Nhật Bản',
        'grammar': 'に: Giới từ chỉ địa điểm.',
      },
      {
        'japanese': '明日、友達と会います。',
        'vietnamese': 'Ngày mai, tôi sẽ gặp bạn.',
        'meaning': 'Nghĩa: Ngày mai, tôi sẽ gặp bạn.',
        'missingWord': '友達',
        'vocabulary': '友達 (ともだち): Bạn bè',
        'grammar': 'と: Giới từ chỉ cùng với.'
      },
    ];
  }

  static List<Map<String, String>> _getSentencesForLesson2() {
    return [
      {
        'japanese': '彼は先生です。',
        'vietnamese': 'Anh ấy là giáo viên.',
        'missingWord': '先生',
        'meaning': 'Nghĩa: Anh ấy là một giáo viên.',
        'vocabulary': '先生 (せんせい): Giáo viên',
        'grammar': 'です: Cấu trúc khẳng định.',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> topics = widget.level == 5 ? n5Topics : n4Topics[widget.level]!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chủ đề N${widget.level}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    topic['title'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                ...topic['lessons'].map<Widget>((lesson) {
                  return GestureDetector(
                    onTap: () {
                      if (lesson.containsKey('sentences')) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LearningScreen(
                              lessonTitle: lesson['title'],
                              sentences: lesson['sentences'] ?? [],
                            ),
                          ),
                        );
                      }
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(lesson['image']),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Text(
                            lesson['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
