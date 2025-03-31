import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserStatsBarChartScreen extends StatefulWidget {
  @override
  _UserStatsBarChartScreenState createState() =>
      _UserStatsBarChartScreenState();
}

class _UserStatsBarChartScreenState extends State<UserStatsBarChartScreen> {
  Map<int, int> monthlyUsers = {}; // Dữ liệu từ API
  int selectedYear = 2025; // Năm mặc định
  final List<int> availableYears = [2020, 2021, 2022, 2023, 2024, 2025];

  @override
  void initState() {
    super.initState();
    fetchUserSignupData();
  }

  Future<void> fetchUserSignupData() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8080/api/user/signup-stats?year=$selectedYear'));
    if (response.statusCode == 200) {
      final Map<int, int> fetchedData = Map<int, int>.from(
        jsonDecode(response.body).map(
          (key, value) => MapEntry(int.parse(key), value),
        ),
      );
      // Đảm bảo có đủ 12 tháng, nếu thiếu thì gán giá trị 0
      setState(() {
        monthlyUsers = {for (int i = 1; i <= 12; i++) i: fetchedData[i] ?? 0};
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
      appBar: AppBar(
        title: Text("Biểu đồ đăng ký"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Khu vực chọn năm (Dropdown)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Chọn năm: ", style: TextStyle(fontSize: 16)),
                DropdownButton<int>(
                  value: selectedYear,
                  items: availableYears.map((year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }).toList(),
                  onChanged: (newYear) {
                    setState(() {
                      selectedYear = newYear!;
                    });
                    fetchUserSignupData();
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            // Biểu đồ + nhãn "Tháng"
            Expanded(
              child: Column(
                children: [
                  // Biểu đồ được bọc trong Expanded để chiếm tối đa chiều cao còn lại
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
                          child: BarChart(
                            BarChartData(
                              barGroups: monthlyUsers.entries.map((entry) {
                                return BarChartGroupData(
                                  x: entry.key,
                                  barRods: [
                                    BarChartRodData(
                                      toY: entry.value.toDouble(),
                                      color: Colors.blue,
                                      width: 14,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                  showingTooltipIndicators: [0],
                                );
                              }).toList(),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black54,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          value.toInt().toString(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Nhãn "Tháng" đặt bên dưới góc trái
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "Tháng",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
