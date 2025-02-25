import 'package:duandemo/firebase_options.dart';
import 'package:duandemo/screens/WordChainGame.dart';
import 'package:duandemo/screens/chat_homescreen.dart';
import 'package:duandemo/screens/cousers/CourseListScreen.dart';
import 'package:duandemo/screens/form/add_student_form_screen,dart';
import 'package:duandemo/screens/form/add_teacher_form_screen.dart';
import 'package:duandemo/screens/form/list_student_form_screen.dart';
import 'package:duandemo/screens/form/list_teacher_form_screen.dart';
import 'package:duandemo/screens/level_selection_screen.dart';
import 'package:duandemo/screens/onionList_screen.dart';
import 'package:duandemo/screens/onion_screen.dart';
import 'package:duandemo/screens/onion_topic_screen.dart';
import 'package:duandemo/screens/test_up_image/upload_imageScreen.dart';
import 'package:duandemo/screens/topic_screen_like_duolingo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Màn hình đăng nhập
import 'package:duandemo/screens/form/student_registration_form_item.dart'; // Màn hình hiển thị thông tin học viên
import 'package:duandemo/screens/form/list_student_form_screen.dart'; // Màn hình danh sách học viên
import 'package:duandemo/screens/form/teacher_registration_form_delta_screen.dart'; // Chi tiết giáo viên
import 'package:duandemo/screens/form/teacher_form_item.dart'; // Màn hình danh sách giáo viên
import 'package:duandemo/screens/form/teacher_form_detail_screen.dart'; // Màn hình chi tiết giáo viên
import 'package:duandemo/screens/form/list_student_form_screen.dart'; // Ví dụ màn hình học viên, nếu cần
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
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login to Dashboard App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: LoginScreen()); // Khởi động với màn hình đăng nhập
        //home: ChatHomescreen(),
        //home: WordChainGame(),
        // home: LevelSelectionScreen());
       //  home: CourseListScreen());

        // home: UploadImageScreen());
       // home: AddTeacherFormScreen());
       // home: TeacherRegistrationFormListScreen());
        
      //  home:AddStudentFormScreen()); //Khánh 
        home:StudentRegistrationListScreen());

       

    // home: OnionTopicScreen(level: 5));
    // home: TopicScreen2(
    //   level: 1,
    // ));
  }
}
