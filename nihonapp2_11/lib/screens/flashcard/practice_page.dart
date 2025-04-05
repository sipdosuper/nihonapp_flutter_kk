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
  List<bool>? _showFrontSide;
  List<String>? _ratings;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
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
                    Text(
                      "Rating: ${_ratings![index]}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FilledButton(
                            onPressed: () => saveRating(index, "Hard"),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.error,
                              ),
                            ),
                            child: const Text("Hard"),
                          ),
                          FilledButton(
                            onPressed: () => saveRating(index, "Good"),
                            style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Color.fromARGB(255, 25, 190, 30),
                              ),
                            ),
                            child: const Text("Good"),
                          ),
                          FilledButton(
                            onPressed: () => saveRating(index, "Easy"),
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
