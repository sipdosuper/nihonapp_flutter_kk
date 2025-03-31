import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddRoleScreen extends StatefulWidget {
  const AddRoleScreen({Key? key}) : super(key: key);

  @override
  _AddRoleScreenState createState() => _AddRoleScreenState();
}

class _AddRoleScreenState extends State<AddRoleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final Color primaryColor = Color(0xFFE57373);

  Future<void> _submitRole() async {
    if (_formKey.currentState!.validate()) {
      final idInput = _idController.text;
      final name = _nameController.text;

      // Kiểm tra và chuyển đổi id
      if (idInput.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Vui lòng nhập ID')));
        return;
      }
      int? id = int.tryParse(idInput);
      if (id == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('ID phải là số hợp lệ')));
        return;
      }

      // Tạo dữ liệu theo RoleCreateRequest: id và name (string)
      final Map<String, dynamic> roleData = {
        "id": id,
        "name": name,
      };

      final url = Uri.parse('http://localhost:8080/api/role');
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(roleData),
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Role được thêm thành công')));
          Navigator.of(context).pop(true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Thêm Role thất bại, mã lỗi: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Có lỗi xảy ra: $e')));
      }
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm Role", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Trường nhập ID
                  TextFormField(
                    controller: _idController,
                    decoration: InputDecoration(
                      labelText: "ID",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập ID';
                      }
                      if (int.tryParse(value) == null) {
                        return 'ID phải là số hợp lệ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // Trường nhập tên Role
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Tên Role",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên Role';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitRole,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Thêm Role",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
