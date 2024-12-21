import 'dart:convert';
import 'package:duandemo/word_val.dart';
import 'package:http/http.dart' as http;
import 'package:duandemo/model/Onion.dart';

class OnionService {
  // URL cơ bản của API
  final String baseUrl = Wordval().api + "onion"; // Thay bằng URL API của bạn

  // Hàm lấy Onion theo ID
  Future<Onion> fetchOnionById(int onionId) async {
    final url = Uri.parse("$baseUrl/$onionId"); // API endpoint

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Onion.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to load Onion with ID $onionId: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching Onion: $e');
    }
  }
}
