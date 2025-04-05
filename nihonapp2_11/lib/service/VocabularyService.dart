import 'dart:convert';
import 'package:duandemo/model/Vocabulary.dart';
import 'package:duandemo/word_val.dart';
import 'package:http/http.dart' as http;

class VocabularyService {
  final String apiUrl = Wordval().api + 'vocabulary'; // Thay bằng API của bạn

  Future<List<Vocabulary>> fetchVocabularies() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Parse JSON và chuyển thành List<Vocabulary>
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Vocabulary.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load vocabularies');
      }
    } catch (e) {
      throw Exception('Error fetching vocabularies: $e');
    }
  }
}
