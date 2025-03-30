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

  @override
  void initState() {
    super.initState();
    fetchUserSignupData();
  }

  Future<void> fetchUserSignupData() async {
    final response = await http.get(
        Uri.parse('http://localhost:8080/api/user/signup-stats?year=2025'));
    if (response.statusCode == 200) {
      final Map<int, int> fetchedData = Map<int, int>.from(
          jsonDecode(response.body)
              .map((key, value) => MapEntry(int.parse(key), value)));

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
      appBar: AppBar(title: Text("Biểu đồ đăng ký")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            barGroups: monthlyUsers.entries.map((entry) {
              return BarChartGroupData(
                x: entry.key, // Tháng
                barRods: [
                  BarChartRodData(
                    toY: entry.value.toDouble(),
                    color: Colors.blue,
                    width: 16,
                    borderRadius: BorderRadius.circular(6),
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
                      value.toInt().toString(), // Chỉ hiển thị số nguyên
                      style: TextStyle(fontSize: 12),
                    );
                  },
                  interval: 1, // Đảm bảo chỉ hiển thị số nguyên
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text("Tháng ${value.toInt()}"),
                    );
                  },
                ),
              ),
            ),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }
}
