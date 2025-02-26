import 'package:flutter/material.dart';
import 'package:duandemo/model/StudentRegistration.dart';
import 'package:intl/intl.dart';

class StudentFormDetailScreen extends StatelessWidget {
  final StudentRegistration student;

  StudentFormDetailScreen({required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết sinh viên',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xFFE57373),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: Color(0xFFE57373), size: 30),
                    SizedBox(width: 10),
                    Text(student.nameAndSdt,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Divider(),
                detailRow(Icons.email, 'Email', student.email.toString()),
                detailRow(Icons.date_range, 'Ngày đăng ký',
                    DateFormat('yyyy-MM-dd').format(student.regisDay)),
                detailRow(
                    Icons.class_, 'Lớp học ID', student.classRoomId.toString()),
                detailRow(
                    Icons.attach_money,
                    'Hóa đơn',
                    student.bill.isNotEmpty
                        ? student.bill
                        : 'Không có hóa đơn'),
                SizedBox(height: 20),
                if (student.bill.isNotEmpty &&
                    Uri.tryParse(student.bill)?.hasAbsolutePath == true)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        student.bill,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Text("Không thể tải ảnh",
                              style: TextStyle(color: Colors.red));
                        },
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Chức năng gửi sẽ có sau")),
                      );
                    },
                    child: Text("Gửi"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE57373),
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFFE57373)),
          SizedBox(width: 10),
          Text('$label: ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(
            child: Text(value,
                style: TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}