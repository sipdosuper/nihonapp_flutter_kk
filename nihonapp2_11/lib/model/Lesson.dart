import 'package:duandemo/model/Sentence.dart';

class Lesson {
  final int id;
  final String title; // Tiêu đề của bài học
  final List<Sentence> sentence; // Danh sách câu (sentences)

  Lesson({
    required this.id,
    required this.title,
    required this.sentence,
  });

  // Ánh xạ dữ liệu từ JSON
factory Lesson.fromJson(Map<String, dynamic> json) {
  // Đổi 'sentence' -> 'sentences' cho đúng với key của JSON
  var sentenceList = json['sentences'] as List? ?? [];
  List<Sentence> sentenceObjects =
      sentenceList.map((i) => Sentence.fromJson(i)).toList();

  return Lesson(
    id: json['id'],
    title: json['title'],
    sentence: sentenceObjects,
  );
}


}
