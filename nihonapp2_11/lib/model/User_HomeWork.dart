class UserHomeWork {
  final int id;
  final String studentAnswer;
  final String? audio; // Có thể null
  final String teacherNote;
  final double point;
  final int homeWorkId;
  final int studentId;

  UserHomeWork({
    required this.id,
    required this.studentAnswer,
    this.audio, // Có thể null
    required this.teacherNote,
    required this.point,
    required this.homeWorkId,
    required this.studentId,
  });

  // Chuyển từ JSON sang Object
  factory UserHomeWork.fromJson(Map<String, dynamic> json) {
    return UserHomeWork(
      id: json['id'],
      studentAnswer: json['student_answer'],
      audio: json['audio'], // Giá trị có thể null
      teacherNote: json['teacher_note'],
      point: (json['point'] as num).toDouble(),
      homeWorkId: json['homework_id'],
      studentId: json['student_id'],
    );
  }

  // Chuyển từ Object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'student_answer': studentAnswer,
      'audio': audio,
      'teacher_note': teacherNote,
      'point': point,
      'homework_id': homeWorkId,
      'student_id': studentId,
    };
  }
}
