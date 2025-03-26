import 'package:flutter/material.dart';
import 'package:duandemo/screens/chat_homescreen.dart';
import 'package:duandemo/screens/profile_screen.dart';
import 'package:duandemo/screens/lesson_list_screen.dart';
import 'package:duandemo/screens/onion_topic_screen.dart';
import 'package:duandemo/screens/topic_screen_like_duolingo.dart';
import 'package:duandemo/screens/level_selection_screen.dart';
import 'package:duandemo/screens/login_screen.dart';
import 'package:duandemo/screens/WordChainGame.dart';
import 'package:duandemo/model/Topic.dart';
import 'package:duandemo/screens/cousers/couser_decription_screen.dart';
import 'package:duandemo/screens/news_screen.dart'; // Màn hình NewsScreen
// ----- Thêm các import cần thiết cho việc gọi API và model Classroom -----
import 'package:duandemo/model/ClassRoom.dart';
import 'package:duandemo/word_val.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as dom;

// -------------------------------------------------------------------------
// Định nghĩa model NewsItem để chứa dữ liệu tin tức
class NewsItem {
  final String title;
  final String link;
  final String description;
  final String imageUrl;

  NewsItem({
    required this.title,
    required this.link,
    required this.description,
    required this.imageUrl,
  });
}

// Hàm gọi API lấy danh sách tin tức từ web
Future<List<NewsItem>> fetchNewsItems() async {
  const url = 'https://www.nhhk.com.vn/blogs/tin-tuc/ky-thi-jlpt';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    // Giải mã dữ liệu HTML theo UTF-8 để tránh lỗi khi gặp ký tự tiếng Nhật
    final document = htmlParser.parse(utf8.decode(response.bodyBytes));
    // Giả sử mỗi tin tức nằm trong thẻ có class "item-blog"
    List<dom.Element> newsElements = document.querySelectorAll('.item-blog');
    List<NewsItem> newsItems = [];
    for (var element in newsElements) {
      // Tiêu đề nằm trong h2.title > a
      var titleElement = element.querySelector('h2.title a');
      var title = titleElement?.text.trim() ?? 'No title';
      var link = titleElement?.attributes['href'] ?? '';
      // Mô tả nằm trong p.description
      var descElement = element.querySelector('p.description');
      var description = descElement?.text.trim() ?? 'No description';
      // Ảnh tin tức
      var imgElement = element.querySelector('img');
      var imageUrl = imgElement?.attributes['src'] ?? '';

      newsItems.add(NewsItem(
        title: title,
        link: link,
        description: description,
        imageUrl: imageUrl,
      ));
    }
    return newsItems;
  } else {
    throw Exception('Failed to load news items');
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Học Tiếng Nhật',
      theme: ThemeData(
        primarySwatch: Colors.red,
        // Đặt font mặc định hỗ trợ tiếng Nhật
        fontFamily: 'NotoSansJP',
      ),
      // Chạy ứng dụng bắt đầu từ màn hình đăng nhập
      home: LoginScreen(),
    );
  }
}

// -------------------------------------------------------------------------
// MainScreen - Chứa BottomNavigationBar, khởi tạo HomeScreen với level được truyền
// -------------------------------------------------------------------------
class MainScreen extends StatefulWidget {
  final int level;

  MainScreen({required this.level});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      // Màn hình Trang Chủ
      HomeScreen(level: widget.level),
      // Màn hình "Khóa Học"
      LessonListScreen(
        // Đổi "Mặc định" thành "Khóa học đã mua"
        topic: Topic(
          id: widget.level,
          name: 'Khóa học đã mua',
          lessons: [],
          onions: [],
        ),
      ),
      // Màn hình "Chat"
      ChatHomescreen(),
      // Màn hình "Profile"
      ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang Chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Khóa Học'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

// --------------------------------------------------------
// HomeScreen: Gọi API khóa học & tin tức, hiển thị Trang Chủ
// --------------------------------------------------------
class HomeScreen extends StatefulWidget {
  final int level;
  // Thông tin user có thể giữ ở đây hoặc chuyển vào State
  final String username = "dangkhoa";
  final String email = "khoa@gmail.com";

  HomeScreen({Key? key, required this.level}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Biến để lưu danh sách khóa học và trạng thái loading
  List<Classroom> _courses = [];
  bool _isLoadingCourses = true;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  // Gọi API lấy danh sách khóa học, giải mã UTF-8
  Future<void> _fetchCourses() async {
    try {
      final response = await http.get(Uri.parse(Wordval().api + 'classroom'));
      if (response.statusCode == 200) {
        // Giải mã UTF-8 để tránh lỗi khi có ký tự tiếng Nhật
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _courses = data.map((json) => Classroom.fromJson(json)).toList();
          _isLoadingCourses = false;
        });
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (error) {
      print("Error fetching courses: $error");
      setState(() {
        _isLoadingCourses = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Màu chủ đạo
    const primaryColor = Color(0xFFE57373);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Tắt nút lùi
        title: Text('Trang Chủ - N${widget.level}'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.list_alt),
            tooltip: 'Chọn Level',
            onPressed: () async {
              // Mở LevelSelectionScreen
              final selectedLevel = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LevelSelectionScreen(),
                ),
              );
              // Nếu chọn xong level (có trả về)
              if (selectedLevel != null) {
                // Quay lại MainScreen với level = selectedLevel
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScreen(level: selectedLevel),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Vùng hiển thị thông tin người dùng
            _buildUserInfoCard(
              username: widget.username,
              email: widget.email,
              primaryColor: primaryColor,
            ),
            const SizedBox(height: 20),
            // Vùng "Các chức năng" (grid icon)
            _buildFeatureGrid(context),
            const SizedBox(height: 20),
            // Vùng "Mua khóa học" (lấy data API)
            _buildMuaKhoaHocSection(context),
            const SizedBox(height: 20),
            // Vùng "Bảng tin mới" (lấy dữ liệu tin tức từ web)
            _buildTinMoiSection(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị thông tin người dùng (trên cùng)
  Widget _buildUserInfoCard({
    required String username,
    required String email,
    required Color primaryColor,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xin chào, $username!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Email: $email',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị "Các chức năng" (grid icon)
  Widget _buildFeatureGrid(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.0),
        children: [
          _buildFeatureButton(
            context,
            Icons.school,
            'Học Câu',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopicScreen2(level: widget.level),
                ),
              );
            },
          ),
          _buildFeatureButton(
            context,
            Icons.book,
            'Đọc Câu',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OnionTopicScreen(level: widget.level),
                ),
              );
            },
          ),
          _buildFeatureButton(
            context,
            Icons.videogame_asset,
            'Chơi Game',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WordChainGame(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget con để tạo 1 ô chức năng (icon + text)
  Widget _buildFeatureButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.red.shade100,
            child: Icon(icon, size: 30, color: Colors.red),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị mục "Mua khóa học" (lấy từ API)
  Widget _buildMuaKhoaHocSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mua khóa học',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200, // chiều cao tùy chỉnh
            child: _isLoadingCourses
                ? Center(child: CircularProgressIndicator())
                : _courses.isEmpty
                    ? Center(child: Text("Không có khóa học nào!"))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _courses.length,
                        itemBuilder: (context, index) {
                          final course = _courses[index];
                          return _buildCourseItem(context, course);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // Widget con để hiển thị 1 khóa học trong mục "Mua khóa học"
  Widget _buildCourseItem(BuildContext context, Classroom course) {
    return Container(
      width: 220, // Độ rộng mỗi card
      margin: EdgeInsets.only(right: 16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tên khóa học
              Text(
                course.name ?? "Tên khóa học",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              // Cấp độ
              Text(
                "Cấp độ: ${course.level ?? 'N/A'}",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              // Giá
              Text(
                "Giá: ${course.price ?? '0'} VND",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              Spacer(),
              // Nút Chi tiết (chuyển sang màn hình CourseDescriptionScreen)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDescriptionScreen(
                          classroom: course,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: Text("Chi tiết"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget hiển thị mục "Bảng tin mới" (lấy dữ liệu từ web)
  Widget _buildTinMoiSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bảng tin mới',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<NewsItem>>(
            future: fetchNewsItems(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Container(
                  height: 200,
                  child: Center(child: Text('Lỗi tải tin tức')),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Container(
                  height: 200,
                  child: Center(child: Text('Không có tin mới nào')),
                );
              } else {
                final newsList = snapshot.data!;
                return Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      final news = newsList[index];
                      return Container(
                        width: 220,
                        margin: EdgeInsets.only(right: 16),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              news.imageUrl.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        news.imageUrl,
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      height: 100,
                                      color: Colors.grey[300],
                                      child: Icon(Icons.image, color: Colors.grey),
                                    ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  news.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewsScreen()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Xem tất cả',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
