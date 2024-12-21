import 'package:duandemo/model/Sentence.dart';

class Onion {
  final int id;
  final String title;
  final List<Sentence> sentence; // Danh sách câu (sentences)

  Onion({required this.id, required this.title, required this.sentence});

  factory Onion.fromJson(Map<String, dynamic> json) {
    var sentenceList = json['sentences'] as List;
    List<Sentence> sentenceObjects =
        sentenceList.map((i) => Sentence.fromJson(i)).toList();

    return Onion(
      id: json['id'],
      title: json['title'], // Đây là tiêu đề của bài học
      sentence: sentenceObjects, // Danh sách câu
    );
  }
}
