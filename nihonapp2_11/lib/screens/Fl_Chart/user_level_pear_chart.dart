import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserLevelPieChartScreen extends StatefulWidget {
  @override
  _UserLevelPieChartScreenState createState() =>
      _UserLevelPieChartScreenState();
}

class _UserLevelPieChartScreenState extends State<UserLevelPieChartScreen> {
  Map<int, int> levelUsers = {}; // Dữ liệu từ API
  final Map<int, String> levelLabels = {
    1: "N1",
    2: "N2",
    3: "N3",
    4: "N4",
    5: "N5"
  };
  final List<Color> levelColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple
  ];

  @override
  void initState() {
    super.initState();
    fetchUserLevelData();
  }

  Future<void> fetchUserLevelData() async {
    final response = await http.get(
        Uri.parse('http://localhost:8080/api/level/countUser')); // API giả định
    if (response.statusCode == 200) {
      final Map<int, int> fetchedData = Map<int, int>.from(
          jsonDecode(response.body)
              .map((key, value) => MapEntry(int.parse(key), value)));
      // Đảm bảo có đủ 5 level, nếu thiếu thì gán giá trị 0
      setState(() {
        levelUsers = {for (int i = 1; i <= 5; i++) i: fetchedData[i] ?? 0};
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi tải dữ liệu!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Biểu đồ phần trăm user theo level")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Nếu màn hình nhỏ (mobile), sử dụng bố cục dạng Column
            if (constraints.maxWidth < 600) {
              return Column(
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1.2,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          child: PieChart(
                            PieChartData(
                              sections: levelUsers.entries.map((entry) {
                                int index = entry.key - 1;
                                return PieChartSectionData(
                                  value: entry.value.toDouble(),
                                  title: "${entry.value}",
                                  color: levelColors[index],
                                  radius: 65,
                                  titleStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              }).toList(),
                              sectionsSpace: 4,
                              centerSpaceRadius: 35,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Legend hiển thị dạng Wrap để tự sắp xếp khi không đủ không gian
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: levelUsers.entries.map((entry) {
                      int index = entry.key - 1;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: levelColors[index],
                          ),
                          SizedBox(width: 4),
                          Text(
                            "${levelLabels[entry.key]}: ${entry.value}",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              );
            } else {
              // Với màn hình lớn, giữ bố cục dạng Row như cũ
              return Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: levelUsers.entries.map((entry) {
                          int index = entry.key - 1;
                          return PieChartSectionData(
                            value: entry.value.toDouble(),
                            title: "${entry.value}",
                            color: levelColors[index],
                            radius: 80,
                            titleStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          );
                        }).toList(),
                        sectionsSpace: 4,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: levelUsers.entries.map((entry) {
                      int index = entry.key - 1;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              color: levelColors[index],
                            ),
                            SizedBox(width: 8),
                            Text(
                              "${levelLabels[entry.key]}: ${entry.value} user",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
