class StudentRegistration {
  final int id;
  final String nameAndSdt;
  final String? email;
  final bool bankCheck;
  final DateTime regisDay;
  final String bill;
  final bool? status;
  final int classRoomId;

  StudentRegistration({
    required this.id,
    required this.nameAndSdt,
    this.email,
    required this.bankCheck,
    required this.regisDay,
    required this.bill,
    this.status,
    required this.classRoomId,
  });

  // Chuyển JSON thành đối tượng StudentRegistration
  factory StudentRegistration.fromJson(Map<String, dynamic> json) {
    return StudentRegistration(
      id: json['id'],
      nameAndSdt: json['nameAndSdt'] ?? '',
      email: json['email'], // Có thể null
      bankCheck: json['bankCheck'] ?? false,
      regisDay: DateTime.parse(json['regisDay']),
      bill: json['bill'] ?? '',
      status: json['status'], // Có thể null
      classRoomId: json['classRoomId'] ?? 0,
    );
  }

  // Chuyển đối tượng StudentRegistration thành JSON
  Map<String, dynamic> toJson() {
    return {
      "nameAndSdt": nameAndSdt,
      "regisDay": regisDay.toIso8601String(),
      "bill": bill,
      "email": email,
      "classRoom_id":
          classRoomId, // Đúng với key "classRoom_id" trong JSON yêu cầu
    };
  }
}
