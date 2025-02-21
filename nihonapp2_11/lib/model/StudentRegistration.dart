import 'dart:convert';

class StudentRegistration {
  final String nameAndSdt;
  final DateTime regisDay;
  final String bill;
  final String email;
  final int classRoomId;

  StudentRegistration({
    required this.nameAndSdt,
    required this.regisDay,
    required this.bill,
    required this.email,
    required this.classRoomId,
  });

  factory StudentRegistration.fromJson(Map<String, dynamic> json) {
    return StudentRegistration(
      nameAndSdt: json['nameAndSdt'] ?? '',
      regisDay: DateTime.parse(json['regisDay']),
      bill: json['bill'] ?? '',
      email: json['email'] ?? '',
      classRoomId: json['classRoom_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nameAndSdt": nameAndSdt,
      "regisDay": regisDay.toIso8601String(),
      "bill": bill,
      "email": email,
      "classRoom_id": classRoomId,
    };
  }
}
