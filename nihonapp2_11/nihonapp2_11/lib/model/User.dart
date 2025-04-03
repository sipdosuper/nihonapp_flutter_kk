import 'dart:convert';

class User {
  String username;
  String email;
  int role;

  User({
    required this.username,
    required this.email,
    required this.role,
  });

  // Phương thức để chuyển đổi từ JSON thành đối tượng User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String,
      email: json['email'] as String,
      role: json['role'] as int,
    );
  }

  // Phương thức để chuyển đổi từ đối tượng User thành JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'role': role,
    };
  }

  @override
  String toString() {
    return 'User(username: $username, email: $email, role: $role)';
  }
}
