class Classroom {
  final int id;
  final String name;
  final String level;
  final String description;
  final int slMax;
  final String linkGiaotrinh;
  final DateTime start;
  final DateTime end;
  final int price;
  final String time;
  final String teacher;

  Classroom({
    required this.id,
    required this.name,
    required this.level,
    required this.description,
    required this.slMax,
    required this.linkGiaotrinh,
    required this.start,
    required this.end,
    required this.price,
    required this.time,
    required this.teacher,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Không có tên',
      level: json['level']['name'] ?? 'Không có cấp độ',
      description: json['description'] ?? 'Không có mô tả',
      slMax: (json['sl_max'] as num?)?.toInt() ?? 0,
      linkGiaotrinh: json['link_giaotrinh'] ?? '',
      start: json['start'] != null
          ? DateTime.parse(json['start'])
          : DateTime.now(),
      end: json['end'] != null ? DateTime.parse(json['end']) : DateTime.now(),
      price: (json['price'] as num?)?.toInt() ?? 0,
      time: json['time']['time'] ?? 'Không có thời gian',
      teacher: json['teacher']['teacherName'] ?? 'Không có giáo viên',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': {'name': level},
      'description': description,
      'sl_max': slMax,
      'link_giaotrinh': linkGiaotrinh,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'price': price,
      'time': {'time': time},
      'teacher': {'teacherName': teacher},
    };
  }
}
