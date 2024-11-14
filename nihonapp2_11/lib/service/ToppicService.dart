import 'dart:convert';
import 'package:duandemo/word_val.dart';
import 'package:http/http.dart' as http;

class TopicService {
  final String baseUrl =
      Wordval().api + 'topic'; // Thay thế bằng URL thực tế của bạn

  // GET - Lấy tất cả các Topic
  Future<List<dynamic>> getTopics() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load topics');
    }
  }

  // POST - Thêm Topic
  Future<void> createTopic(int id, String name) async {
    var url = Uri.parse(baseUrl);

    // Tạo payload cho request
    var body = jsonEncode({
      'id': id,
      'name': name,
    });
    print(body);
    try {
      // Gửi yêu cầu POST
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print('Topic created successfully');
      } else {
        print('Failed to create topic. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  // DELETE - Xóa Topic
  Future<void> deleteTopic(int id) async {
    var url = Uri.parse('$baseUrl/$id');
    try {
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        print('Topic deleted successfully');
      } else {
        print('Failed to delete topic. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
