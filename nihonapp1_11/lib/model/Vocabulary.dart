class Vocabulary {
  final int id;
  final String word;
  final String meaning;
  final String example;
  final String transcription;

  Vocabulary({
    required this.id,
    required this.word,
    required this.meaning,
    required this.example,
    required this.transcription,
  });

  // Tạo đối tượng Vocabulary từ JSON
  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      id: json['id'],
      word: json['word'],
      meaning: json['meaning'],
      example: json['example'],
      transcription: json['transcription'],
    );
  }
}
