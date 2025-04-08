import 'package:duandemo/service/firebase_options.dart';
import 'package:duandemo/screens/admin/admin_dashboard_screen.dart';
import 'package:duandemo/screens/authentication/login_screen.dart';
import 'package:duandemo/screens/onion_ai/home_screen.dart'; // Giao tiếp AI
import 'package:duandemo/screens/flashcard/home_page.dart'; // 👉 Import flashcard home (tạo file)
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:duandemo/model/card_provider.dart';
import 'model/collection_model.dart';
import 'model/flashcard_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBgx6bsahXM7oEF7uLdhAT8plpR2NsLYTk",
      authDomain: "dacn-8ecee.firebaseapp.com",
      projectId: "dacn-8ecee",
      storageBucket: "dacn-8ecee.appspot.com",
      messagingSenderId: "22797930593",
      appId: "1:22797930593:web:f19225e64e7ff535389a20",
    ),
  );

  // Khởi tạo Hive cho Flashcard
  await Hive.initFlutter();
  Hive.registerAdapter(FlashCardDataAdapter());
  Hive.registerAdapter(CardCollectionAdapter());
  await Hive.openBox<FlashCardData>("flashcard_data");
  await Hive.openBox<CardCollection>("card_collection");

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CardProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'J_Talkie',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'NotoSansJP',
        ),
        // 👉 Tùy chọn: Chạy vào Admin Dashboard, hoặc Flashcard, hoặc AI:
        // home: HomeScreen(),
        // home: HomePage(),
        home: LoginScreen(),
        // home: AdminDashboardScreen(),
        routes: {
          '/flashcard': (context) => const HomePage(),
          '/ai-chat': (context) => const OnionHomeScreen(),
        },
      ),
    );
  }
}
