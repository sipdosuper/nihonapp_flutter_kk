import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'view_saved_chat_screen.dart';

class SavedChatsScreen extends StatefulWidget {
  const SavedChatsScreen({super.key});

  @override
  State<SavedChatsScreen> createState() => _SavedChatsScreenState();
}

class _SavedChatsScreenState extends State<SavedChatsScreen> {
  late Box savedChatsBox;
  String _searchQuery = '';
  String _timeFilter = 'Tất cả';

  @override
  void initState() {
    super.initState();
    savedChatsBox = Hive.box('saved_chats');
  }

  void _deleteChat(String key) async {
    await savedChatsBox.delete(key);
    setState(() {});
  }

  bool _matchTimeFilter(DateTime dateTime) {
    final now = DateTime.now();
    switch (_timeFilter) {
      case 'Hôm nay':
        return dateTime.year == now.year &&
            dateTime.month == now.month &&
            dateTime.day == now.day;
      case '7 ngày':
        return dateTime.isAfter(now.subtract(const Duration(days: 7)));
      case '30 ngày':
        return dateTime.isAfter(now.subtract(const Duration(days: 30)));
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final keys = savedChatsBox.keys.toList();

    keys.sort((a, b) {
      final aTimestamp = savedChatsBox.get(a)['timestamp'];
      final bTimestamp = savedChatsBox.get(b)['timestamp'];
      if (aTimestamp == null || bTimestamp == null) return 0;
      return bTimestamp.compareTo(aTimestamp);
    });

    final filteredKeys = keys.where((key) {
      final chatData = savedChatsBox.get(key);
      final timestamp = chatData['timestamp'];
      DateTime? chatDate;
      if (timestamp != null) {
        chatDate = DateTime.tryParse(timestamp);
      }

      return key.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          (chatDate == null || _matchTimeFilter(chatDate));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuộc trò chuyện đã lưu'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm cuộc trò chuyện...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                const Text('Lọc theo thời gian:'),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _timeFilter,
                  items: const [
                    DropdownMenuItem(value: 'Tất cả', child: Text('Tất cả')),
                    DropdownMenuItem(value: 'Hôm nay', child: Text('Hôm nay')),
                    DropdownMenuItem(
                        value: '7 ngày', child: Text('7 ngày qua')),
                    DropdownMenuItem(
                        value: '30 ngày', child: Text('30 ngày qua')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _timeFilter = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredKeys.isEmpty
                ? const Center(
                    child: Text('Không tìm thấy cuộc trò chuyện nào.'))
                : ListView.builder(
                    itemCount: filteredKeys.length,
                    itemBuilder: (context, index) {
                      final chatName = filteredKeys[index];
                      final chatData = savedChatsBox.get(chatName);
                      final String? timestamp = chatData['timestamp'];

                      String formattedTime = "Không rõ";
                      if (timestamp != null) {
                        final dateTime = DateTime.tryParse(timestamp);
                        if (dateTime != null) {
                          formattedTime =
                              DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
                        }
                      }

                      return ListTile(
                        title: Text(chatName),
                        subtitle: Text("Lưu lúc: $formattedTime"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteChat(chatName),
                        ),
                        onTap: () {
                          final messages = chatData['messages'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewSavedChatScreen(
                                chatName: chatName,
                                messages: messages.cast<Map<String, dynamic>>(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
