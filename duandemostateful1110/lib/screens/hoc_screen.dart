import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class HocScreen extends StatelessWidget {
  final String level;

  HocScreen({required this.level});

  @override
  Widget build(BuildContext context) {
    // Giả định đây là dữ liệu topics
    final topics = [
      {
        'title': 'Chủ đề 1',
        'lessons': [
          {
            'title': 'Bài học 1',
            'sentences': _getSentencesForLesson1()
          },
          {
            'title': 'Bài học 2',
            'sentences': _getSentencesForLesson2()
          },
        ],
      },
      {
        'title': 'Chủ đề 2',
        'lessons': [
          {
            'title': 'Bài học 1',
            'sentences': _getSentencesForLesson1()
          },
        ],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Học $level'),
      ),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(topics[index]['title'] as String),
              onTap: () {
                // Sửa pushReplacement thành push để giữ lại màn hình trước đó trong stack
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardScreen(
                      topics: topics,
                      index: index,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  List<Map<String, String>> _getSentencesForLesson1() {
    return [
      {
        'japanese': '私は学生です。',
        'vietnamese': 'Tôi là sinh viên.',
        'missingWord': '学生',
        'vocabulary': '学生 (がくせい): Sinh viên',
        'grammar': 'です: Dùng để diễn đạt sự xác nhận về một sự thật.'
      },
      {
        'japanese': '私は日本に行きます。',
        'vietnamese': 'Tôi sẽ đi Nhật Bản.',
        'missingWord': '日本',
        'vocabulary': '日本 (にほん): Nhật Bản',
        'grammar': 'に: Giới từ chỉ địa điểm.'
      },
      {
        'japanese': '明日、友達と会います。',
        'vietnamese': 'Ngày mai, tôi sẽ gặp bạn.',
        'missingWord': '友達',
        'vocabulary': '友達 (ともだち): Bạn bè',
        'grammar': 'と: Giới từ chỉ cùng với.'
      },
    ];
  }

  List<Map<String, String>> _getSentencesForLesson2() {
    return [
      {
        'japanese': '彼は先生です。',
        'vietnamese': 'Anh ấy là giáo viên.',
        'missingWord': '先生',
        'vocabulary': '先生 (せんせい): Giáo viên',
        'grammar': 'です: Cấu trúc khẳng định.'
      },
      {
        'japanese': '彼女は医者です。',
        'vietnamese': 'Cô ấy là bác sĩ.',
        'missingWord': '医者',
        'vocabulary': '医者 (いしゃ): Bác sĩ',
        'grammar': 'です: Cấu trúc khẳng định.'
      },
    ];
  }
}
