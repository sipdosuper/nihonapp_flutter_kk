import 'package:flutter/material.dart';
import 'package:duandemo/service/gemini_service.dart';
import 'chat_screen.dart';

class CreateScenarioScreen extends StatefulWidget {
  const CreateScenarioScreen({super.key});

  @override
  State<CreateScenarioScreen> createState() => _CreateScenarioScreenState();
}

class _CreateScenarioScreenState extends State<CreateScenarioScreen> {
  final _aiController = TextEditingController();
  final _descController = TextEditingController();
  final _userRoleController = TextEditingController(); // Vai trò người dùng

  String _aiGender = 'Nam';
  String _userGender = 'Nam'; // Giới tính người dùng

  // ✅ Danh sách gợi ý tình huống nhanh
  final List<Map<String, String>> _suggestedScenarios = [
    {
      "ai": "Khách hàng",
      "desc": "Bạn là nhân viên lễ tân, khách đến đặt phòng khách sạn."
    },
    {
      "ai": "Khách hàng",
      "desc": "Bạn là nhân viên bán hàng, khách hỏi về sản phẩm quần áo."
    },
    {
      "ai": "Cảnh sát hình sự",
      "desc": "Bạn đến bắt tôi vì liên quan đến vụ mua bán ma túy"
    },
    {
      "ai": "Khách hàng",
      "desc": "Bạn làm phục vụ, khách đến nhà hàng và gọi món ăn."
    },
    {
      "ai": "Giáo viên",
      "desc": "Bạn là học sinh, muốn hỏi bài giáo viên bằng tiếng Nhật."
    },
  ];

  // ✅ Hàm gọi API tạo tình huống
  void _createScenario({
    required String aiCharacter,
    required String aiGender,
    required String userRole,
    required String userGender,
    required String description,
  }) async {
    final service = GeminiService();

    _showLoadingDialog('Đang tạo tình huống, vui lòng chờ...');

    try {
      final response = await service.generateScenario(
        userCharacter: userRole,
        userGender: userGender,
        aiCharacter: aiCharacter,
        aiGender: aiGender,
        description: description,
      );

      if (!context.mounted) return;
      Navigator.pop(context); // Đóng loading

      // Chuyển sang ChatScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            initialMessage: response,
            userCharacter: userRole,
            userGender: userGender,
            aiCharacter: aiCharacter,
            aiGender: aiGender,
            description: description,
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      _showErrorDialog('Lỗi tạo tình huống: $e');
    }
  }

  // ✅ Gợi ý tình huống và tự động tạo nhanh
  void _createFromSuggestion(Map<String, String> suggestion) {
    final aiCharacter = suggestion["ai"]!;
    final description = suggestion["desc"]!;
    final userRole = _userRoleController.text.isNotEmpty
        ? _userRoleController.text
        : "Nhân viên";

    _createScenario(
      aiCharacter: aiCharacter,
      aiGender: _aiGender,
      userRole: userRole,
      userGender: _userGender,
      description: description,
    );
  }

  // Hiển thị lỗi
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  // Hiển thị loading
  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tạo tình huống')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nhân vật AI', style: TextStyle(fontSize: 16)),
            TextField(
              controller: _aiController,
              decoration:
                  const InputDecoration(hintText: 'Nhập nhân vật AI...'),
            ),
            const SizedBox(height: 16),
            const Text('Giới tính AI', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: _aiGender,
              isExpanded: true,
              items: ['Nam', 'Nữ']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => _aiGender = val!),
            ),
            const SizedBox(height: 16),
            const Text('Vai trò/Nghề nghiệp của bạn',
                style: TextStyle(fontSize: 16)),
            TextField(
              controller: _userRoleController,
              decoration: const InputDecoration(
                  hintText: 'Ví dụ: Nhân viên lễ tân, Bán hàng...'),
            ),
            const SizedBox(height: 16),
            const Text('Giới tính của bạn', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: _userGender,
              isExpanded: true,
              items: ['Nam', 'Nữ']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => _userGender = val!),
            ),
            const SizedBox(height: 16),
            const Text('Mô tả tình huống', style: TextStyle(fontSize: 16)),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Nhập mô tả về tình huống...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () => _createScenario(
                  aiCharacter: _aiController.text,
                  aiGender: _aiGender,
                  userRole: _userRoleController.text,
                  userGender: _userGender,
                  description: _descController.text,
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Tạo tình huống'),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const Text(
              '🌸 Gợi ý nhanh tình huống',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Column(
              children: _suggestedScenarios.map((item) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(item['desc']!,
                        style: const TextStyle(fontSize: 16)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _createFromSuggestion(item),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
