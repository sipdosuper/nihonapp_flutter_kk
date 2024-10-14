import 'package:duandemo/model/Sentence.dart';

class Lesson {
  int id;
  String title;
  List<Sentence> sentence;

  Lesson({required this.id, required this.title, required this.sentence});

  factory Lesson.fromJson(Map<String, dynamic> json) {
    var list = json['sentences'] as List;
    List<Sentence> sentenceList =
        list.map((i) => Sentence.fromJson(i)).toList();

    return Lesson(id: json['id'], title: json['title'], sentence: sentenceList);
  }
}
