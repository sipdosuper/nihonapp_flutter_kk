import 'package:flutter/material.dart';
import 'create_scenario_screen.dart';
import 'saved_chats_screen.dart'; // 👉 Thêm import màn hình xem cuộc trò chuyện đã lưu

class OnionHomeScreen extends StatelessWidget {
  const OnionHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Tình Huống")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const CreateScenarioScreen()),
                );
              },
              child: const Text("Tạo tình huống"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SavedChatsScreen()),
                );
              },
              child: const Text("Xem cuộc trò chuyện đã lưu"),
            ),
          ],
        ),
      ),
    );
  }
}
