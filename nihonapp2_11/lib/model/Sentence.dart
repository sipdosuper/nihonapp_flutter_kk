import 'package:duandemo/model/Vocabulary.dart';

class Sentence {
  final int id;
  final String word; // Câu chứa từ bị thiếu
  final String meaning; // Ý nghĩa của câu
  final String transcription; // Phiên âm của câu
  final String answer; // Từ bị thiếu (đáp án)
  final List<Vocabulary> vocabularies; // Danh sách từ vựng

  Sentence({
    required this.id,
    required this.word,
    required this.meaning,
    required this.transcription,
    required this.answer,
    required this.vocabularies,
  });

  // Tạo đối tượng Sentence từ JSON
  factory Sentence.fromJson(Map<String, dynamic> json) {
    var vocabulariesList = json['litsvocabulary'] as List;
    List<Vocabulary> vocabList =
        vocabulariesList.map((i) => Vocabulary.fromJson(i)).toList();

    return Sentence(
      id: json['id'],
      word: json['word'],
      meaning: json['meaning'], // Kiểu dữ liệu phải là String
      transcription: json['transcription'], // Kiểu dữ liệu String
      answer: json['answer'], // Kiểu dữ liệu String
      vocabularies: vocabList,
    );
  }
}
