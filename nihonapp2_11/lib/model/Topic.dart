import 'package:duandemo/model/Lesson.dart';
import 'package:duandemo/model/Onion.dart';

class Topic {
  final int id;
  final String name;
  final List<Lesson> lessons;
  final List<Onion> onions;
  Topic({
    required this.id,
    required this.name,
    required this.lessons,
    required this.onions,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    var lessons = json['lessons'] as List;
    List<Lesson> lessonList = lessons.map((i) => Lesson.fromJson(i)).toList();

    var onions = json['onions'] as List;
    List<Onion> onionlist = onions.map((i) => Onion.fromJson(i)).toList();

    return Topic(
      id: json['id'],
      name: json['name'],
      lessons: lessonList,
      onions: onionlist,
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
