class Time {
  final int id;
  final String time;

  Time({required this.id, required this.time});

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      id: json['id'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'time': time};
  }
}
