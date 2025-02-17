import 'dart:convert';

class TeacherRegistrationForm {
  final String name;
  final String email;
  final String phone;
  final String birthDay;
  final String proof; // Link ảnh Cloudinary
  final String introduce;
  final String regisDay;
  final int level_id;
  final int workingTime_id;

  TeacherRegistrationForm({
    required this.name,
    required this.email,
    required this.phone,
    required this.birthDay,
    required this.proof,
    required this.introduce,
    required this.regisDay,
    required this.level_id,
    required this.workingTime_id,
  });

  // Convert JSON to Object
  factory TeacherRegistrationForm.fromJson(Map<String, dynamic> json) {
    return TeacherRegistrationForm(
      name: json['teacherName']?.toString() ?? 'Unknown',
      email: json['email']?.toString() ?? 'No email',
      phone: json['phone']?.toString() ?? 'No phone',
      birthDay: json['birthDay']?.toString() ?? 'Unknown',
      proof: json['proof']?.toString() ?? '',
      introduce: json['introduce']?.toString() ?? 'No introduce',
      regisDay: json['regisDay']?.toString() ?? 'Unknown',
      level_id: json['level']?['id'] != null ? (json['level']['id'] as int) : 0,
      workingTime_id: json['workingTime']?['id'] != null
          ? (json['workingTime']['id'] as int)
          : 0,
    );
  }

  // Convert Object to JSON
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "birthDay": birthDay,
      "proof": proof,
      "introduce": introduce,
      "regisDay": regisDay,
      "level_id": level_id,
      "workingTime_id": workingTime_id,
    };
  }
}
