import 'package:duandemo/model/Lesson.dart';

class Topic {
  final int id;
  final String name;
  final List<Lesson> lessons;
  Topic({
    required this.id,
    required this.name,
    required this.lessons,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    var list = json['lessons'] as List;
    List<Lesson> lessonList = list.map((i) => Lesson.fromJson(i)).toList();

    return Topic(
      id: json['id'],
      name: json['name'],
      lessons: lessonList,
    );
  }

  // Phương thức toJson để chuyển đối tượng Topic thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
