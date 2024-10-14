class Sentence {
  final String word;
  final int id;

  Sentence({required int this.id, required this.word});

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      id: json['id'],
      word: json['word'],
    );
  }
}
