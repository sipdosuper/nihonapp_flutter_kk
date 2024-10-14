import 'dart:ffi';

class User {
  final String name;
  final int age;
  final String email;
  final Long role;

  User(
      {required this.name,
      required this.age,
      required this.email,
      required this.role});

  // Method to convert JSON to User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      age: json['age'],
      email: json['email'],
      role: json['role'],
    );
  }

  // Method to convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'email': email,
      'role': role,
    };
  }
}
