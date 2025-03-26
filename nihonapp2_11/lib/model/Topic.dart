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
  var lessonData = json['lessons'] as List? ?? []; // Đổi 'lesson' -> 'lessons'
  List<Lesson> lessonList = lessonData.map((i) => Lesson.fromJson(i)).toList();

  // Nếu onions vẫn đúng với key 'onion' thì giữ nguyên
  var onionData = json['onion'] as List? ?? [];
  List<Onion> onionList = onionData.map((i) => Onion.fromJson(i)).toList();

  return Topic(
    id: json['id'],
    name: json['name'],
    lessons: lessonList,
    onions: onionList,
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
