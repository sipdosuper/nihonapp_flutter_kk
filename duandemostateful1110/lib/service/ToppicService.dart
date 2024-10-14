import 'dart:convert';
import 'package:http/http.dart' as http;

class TopicService {
  final String baseUrl =
      'http://localhost:8080/api/topic'; // Thay thế bằng URL thực tế của bạn

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
}
