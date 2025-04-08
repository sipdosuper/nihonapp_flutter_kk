import 'package:duandemo/components/practice_card.dart';
import 'package:duandemo/model/collection_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PracticePage extends StatefulWidget {
  final CardCollection collection;
  const PracticePage({super.key, required this.collection});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  late PageController _pageController;
  List<bool>? _showFrontSide;
  List<String>? _ratings;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initPrefs();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    int cardCount = widget.collection.flashcards.length;
    _showFrontSide = List.generate(cardCount, (index) => true);
    _ratings = List.generate(cardCount, (index) {
      final savedRating = _prefs.getString(_getRatingKey(index));
      return savedRating ?? "Unrated";
    });
    setState(() {});
  }

  String _getRatingKey(int index) => "rating_${widget.collection.id}_$index";

  void changeSide(int index) {
    setState(() {
      _showFrontSide![index] = !_showFrontSide![index];
    });
  }

  void saveRating(int index, String rating) async {
    setState(() {
      _ratings![index] = rating;
    });
    await _prefs.setString(_getRatingKey(index), rating);
  }

  Future<void> rateAndNext(int index, String rating) async {
    saveRating(index, rating);

    // Chờ 200ms cho cảm giác mượt
    await Future.delayed(const Duration(milliseconds: 200));

    if (index < widget.collection.flashcards.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🎉 Đã hoàn thành bộ flashcard!")),
      );
      // Đợi 1 giây rồi quay lại màn CollectionPage
      await Future.delayed(const Duration(seconds: 1));
      if (context.mounted) {
        Navigator.pop(context); // ← Quay lại màn CollectionPage
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ratings == null || _showFrontSide == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.collection.flashcards.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => changeSide(index),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                scale: animation, child: child);
                          },
                          child: _showFrontSide![index]
                              ? PracticeCard(
                                  key: ValueKey(true),
                                  isFrontSide: true,
                                  cardData: widget.collection.flashcards[index],
                                )
                              : PracticeCard(
                                  key: ValueKey(false),
                                  isFrontSide: false,
                                  cardData: widget.collection.flashcards[index],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Đánh giá: ${_ratings![index]}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FilledButton(
                            onPressed: () => rateAndNext(index, "Hard"),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.error,
                              ),
                            ),
                            child: const Text("Hard"),
                          ),
                          FilledButton(
                            onPressed: () => rateAndNext(index, "Good"),
                            style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Color.fromARGB(255, 25, 190, 30),
                              ),
                            ),
                            child: const Text("Good"),
                          ),
                          FilledButton(
                            onPressed: () => rateAndNext(index, "Easy"),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            child: const Text("Easy"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
