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

  // Factory constructor to convert JSON to StudentRegistration
  factory StudentRegistration.fromJson(Map<String, dynamic> json) {
    return StudentRegistration(
      nameAndSdt: json['nameAndSdt'] ?? '',  // Đảm bảo ánh xạ đúng trường 'nameAndSdt'
      regisDay: DateTime.parse(json['regisDay']),  // Chuyển đổi chuỗi ngày thành DateTime
      bill: json['bill'] ?? '',  // Trường bill có thể là chuỗi rỗng
      email: json['email'] ?? '',  // Đảm bảo trường email có trong JSON
      classRoomId: json['classRoom_id'] ?? 0,  // Đảm bảo đúng tên trường 'classRoom_id' trong JSON
    );
  }

  // Convert StudentRegistration object to JSON
  Map<String, dynamic> toJson() {
    return {
      "nameAndSdt": nameAndSdt,
      "regisDay": regisDay.toIso8601String(),  // Chuyển DateTime thành chuỗi ISO8601
      "bill": bill,
      "email": email,
      "classRoom_id": classRoomId,  // Đảm bảo đúng tên trường khi chuyển sang JSON
    };
  }
}
