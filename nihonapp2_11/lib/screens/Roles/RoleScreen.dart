import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:duandemo/model/Role.dart';
import 'package:duandemo/screens/Roles/AddRoleScreen.dart';
import 'package:http/http.dart' as http;

class RoleScreen extends StatefulWidget {
  const RoleScreen({Key? key}) : super(key: key);

  @override
  _RoleScreenState createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  late Future<List<Role>> _futureRoles;
  final Color primaryColor = Color(0xFFE57373);

  @override
  void initState() {
    super.initState();
    _futureRoles = fetchRoles();
  }

  // Hàm lấy danh sách Role từ backend
  Future<List<Role>> fetchRoles() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/role'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => Role.fromJson(json)).toList();
    } else {
      throw Exception('Không thể tải danh sách Role');
    }
  }

  // Hàm refresh danh sách Role
  void refreshRoles() {
    setState(() {
      _futureRoles = fetchRoles();
    });
  }

  // Hàm xóa Role theo id
  Future<void> _deleteRole(int roleId) async {
    final url = Uri.parse('http://localhost:8080/api/role/delete/$roleId');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa Role thành công')),
        );
        refreshRoles();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa Role thất bại, mã lỗi: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Danh sách Roles',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Role>>(
          future: _futureRoles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Không có Role nào'));
            } else {
              final roles = snapshot.data!;
              return ListView.builder(
                itemCount: roles.length,
                itemBuilder: (context, index) {
                  final role = roles[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: primaryColor,
                        child: Text(
                          role.id.toString(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        role.name,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          // Hiển thị dialog xác nhận xóa
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Xác nhận'),
                              content: Text('Bạn có chắc muốn xóa Role "${role.name}" không?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('Hủy'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _deleteRole(role.id);
                                  },
                                  child: Text('Xóa', style: TextStyle(color: Colors.redAccent)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRoleScreen()),
          ).then((value) {
            if (value == true) {
              refreshRoles();
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
