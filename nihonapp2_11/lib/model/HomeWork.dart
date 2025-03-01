import 'package:duandemo/model/User_HomeWork.dart';

class HomeWork {
  final int id;
  final String name;
  final String question;
  final List<UserHomeWork> userHomeWorks;

  HomeWork({
    required this.id,
    required this.name,
    required this.question,
    required this.userHomeWorks,
  });

  // Chuyển từ JSON sang Object
  factory HomeWork.fromJson(Map<String, dynamic> json) {
    return HomeWork(
      id: json['id'],
      name: json['name'],
      question: json['question'],
      userHomeWorks: (json['user_HomeWorks'] as List<dynamic>)
          .map((item) => UserHomeWork.fromJson(item))
          .toList(),
    );
  }

  // Chuyển từ Object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'question': question,
      'user_HomeWorks': userHomeWorks.map((item) => item.toJson()).toList(),
    };
  }
}
