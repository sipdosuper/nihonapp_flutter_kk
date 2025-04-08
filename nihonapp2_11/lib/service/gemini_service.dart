import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = 'AIzaSyAoy6XDAeZYPtIv7mja9rhvGE_QffcYovM'; //
  final String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent'; // ✅ Model chuẩn

  /// ✅ Lưu lại bối cảnh hội thoại (vai trò, giới tính AI/User)
  String? _contextMemory;

  /// ✅ Tạo tình huống AI mở đầu + Khởi tạo _contextMemory
  Future<String> generateScenario({
    required String userCharacter,
    required String userGender,
    required String aiCharacter,
    required String aiGender,
    required String description,
  }) async {
    final uri = Uri.parse('$baseUrl?key=$apiKey');

    /// ✅ Lưu context cho các hội thoại tiếp theo
    _contextMemory = """
Bạn đóng vai $aiCharacter, giới tính $aiGender. Tôi là $userCharacter, giới tính $userGender.
Tình huống: $description.
Luôn trả lời bằng tiếng Nhật. Không phiên âm Romaji, không dịch Tiếng Việt.
Hãy nhập vai tự nhiên, đúng với mối quan hệ giữa chúng ta. Lưu ý hãy dùng câu nói ngắn, hạn chế sử dụng nhiều từ ngữ.
""";

    /// ✅ Prompt khởi đầu để AI nói câu đầu tiên
    final prompt =
        "$_contextMemory\nHãy bắt đầu cuộc hội thoại với câu nói đầu tiên của bạn.";

    final body = jsonEncode({
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    });

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception('Failed to generate content: ${response.body}');
    }
  }

  /// ✅ Chat tiếp theo, giữ nguyên vai trò/giới tính đã khai báo
  Future<String> chatWithAI(List<Map<String, dynamic>> history) async {
    if (_contextMemory == null) {
      throw Exception('Context not initialized. Call generateScenario first.');
    }

    final uri = Uri.parse('$baseUrl?key=$apiKey');

    /// ✅ Gửi lại bối cảnh + lịch sử hội thoại
    final List<Map<String, dynamic>> contents = [
      {
        "role": "user",
        "parts": [
          {"text": _contextMemory!}
        ]
      },
      ...history.map((msg) => {
            "role": msg['sender'] == 'User' ? 'user' : 'model',
            "parts": [
              {"text": msg['text']}
            ]
          })
    ];

    final body = jsonEncode({"contents": contents});

    /// ✅ Log kiểm tra
    print('========= [API REQUEST BODY] =========');
    print(body);
    print('======================================');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    /// ✅ Log kết quả
    print('========= [API RESPONSE] ============');
    print('Status Code: ${response.statusCode}');
    print('Body: ${response.body}');
    print('=====================================');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception('Failed to chat: ${response.body}');
    }
  }

  /// ✅ Dịch tiếng Nhật sang Tiếng Việt nếu cần
  Future<String> translateToVietnamese(String text) async {
    final uri = Uri.parse('$baseUrl?key=$apiKey');

    final prompt = """
Dịch đoạn sau sang Tiếng Việt tự nhiên, không cần sát nghĩa gốc nếu không phù hợp:
$text
""";

    final body = jsonEncode({
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    });

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    /// ✅ Log phản hồi dịch
    print('========= [TRANSLATE RESPONSE] ============');
    print('Status Code: ${response.statusCode}');
    print('Body: ${response.body}');
    print('=====================================');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception('Failed to translate: ${response.body}');
    }
  }

  /// ✅ Sinh gợi ý trả lời nhanh (Suggestions) dựa vào câu AI mới nhất
  Future<List<String>> generateSuggestions(String aiMessage) async {
    final uri = Uri.parse('$baseUrl?key=$apiKey');

    final prompt = """
Dựa vào câu sau của AI, hãy đưa ra 3 câu trả lời ngắn gợi ý mà người dùng có thể nói tiếp. 
Chỉ trả lại 4 câu trả lời, mỗi câu một dòng, không đánh số thứ tự.
Câu AI: "$aiMessage"
""";

    final body = jsonEncode({
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    });

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    /// ✅ Log phản hồi gợi ý
    print('========= [SUGGESTIONS RESPONSE] ==========');
    print('Status Code: ${response.statusCode}');
    print('Body: ${response.body}');
    print('===========================================');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rawText =
          data['candidates'][0]['content']['parts'][0]['text'] as String;

      /// ✅ Tách các dòng gợi ý
      final suggestions = rawText
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();

      return suggestions;
    } else {
      throw Exception('Failed to generate suggestions: ${response.body}');
    }
  }
}
