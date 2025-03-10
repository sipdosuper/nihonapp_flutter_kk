class Teacher {
  final int id;
  final String username;
  final String email;
  final double? salary;

  Teacher({
    required this.id,
    required this.username,
    required this.email,
    this.salary,
  });

  /// Chuyển từ JSON thành đối tượng Teacher
  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      salary: json['salary'] != null ? json['salary'].toDouble() : null,
    );
  }
}
