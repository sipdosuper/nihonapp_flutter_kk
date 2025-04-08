import 'package:duandemo/themes/app_theme.dart';
import 'package:flutter/material.dart';

class FDrawer extends StatelessWidget {
  const FDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: Column(
          children: [
            Image.asset("assets/Logo.png"),
            const SizedBox(
              height: 25.0, // Adjust the value as needed
            ),
            const Divider(
              indent: 50,
              endIndent: 50,
              height: 1,
              color: Colors.white,
            ),
            const SizedBox(
              height: 10,
            ),
            Theme(
              data: FAppTheme.darkTheme,
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // chỉ cần đóng Drawer
                        Navigator.pop(
                            context); // 👈 quay lại màn hình trước đó (MainScreen đã có sẵn level)
                      },
                      child: const ListTile(
                        leading: Icon(Icons.home),
                        title: Text("Home"),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/allCards");
                      },
                      child: const ListTile(
                        leading: Icon(Icons.list),
                        title: Text("All Cards"),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/bookmarks");
                      },
                      child: const ListTile(
                        leading: Icon(Icons.bookmark),
                        title: Text("Bookmarks"),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/settings");
                      },
                      child: const ListTile(
                        leading: Icon(Icons.settings),
                        title: Text("Settings"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
