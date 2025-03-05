// news_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as dom;

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

  @override
  String toString() {
    return 'NewsItem(title: $title, link: $link)';
  }
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<NewsItem>> _futureNewsItems;

  @override
  void initState() {
    super.initState();
    _futureNewsItems = fetchNewsItems();
  }

  Future<List<NewsItem>> fetchNewsItems() async {
    const url = 'https://www.nhhk.com.vn/blogs/tin-tuc/ky-thi-jlpt';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Parse HTML document
      final document = htmlParser.parse(response.body);
      
      // Giả sử mỗi tin tức nằm trong 1 thẻ <div class="item-blog">
      List<dom.Element> newsElements = document.querySelectorAll('.item-blog');
      List<NewsItem> newsItems = [];
      
      for (var element in newsElements) {
        // Giả sử tiêu đề nằm trong <h2 class="title"><a>Tiêu đề</a></h2>
        var titleElement = element.querySelector('h2.title a');
        var title = titleElement?.text.trim() ?? 'No title';
        
        // Lấy link từ thuộc tính href của <a>
        var link = titleElement?.attributes['href'] ?? '';
        
        // Giả sử mô tả nằm trong <p class="description">
        var descElement = element.querySelector('p.description');
        var description = descElement?.text.trim() ?? 'No description';
        
        // Giả sử ảnh được lấy từ <img class="img-responsive"> hoặc tương tự
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin nổi bật'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<NewsItem>>(
        future: _futureNewsItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có tin nổi bật nào!'));
          } else {
            final newsItems = snapshot.data!;
            return ListView.builder(
              itemCount: newsItems.length,
              itemBuilder: (context, index) {
                final news = newsItems[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: news.imageUrl.isNotEmpty
                        ? Image.network(
                            news.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                    title: Text(news.title),
                    subtitle: Text(
                      news.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      // Bạn có thể mở link trong WebView hoặc trình duyệt.
                      // Ví dụ: Sử dụng url_launcher để mở link:
                      // launch(news.link);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
