import 'package:flutter/material.dart';
import 'package:duandemo/model/collection_model.dart';
import 'package:duandemo/model/flashcard_model.dart';
import 'package:duandemo/components/flashcard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatedCardsPage extends StatefulWidget {
  final CardCollection collection;

  const RatedCardsPage({super.key, required this.collection});

  @override
  State<RatedCardsPage> createState() => _RatedCardsPageState();
}

class _RatedCardsPageState extends State<RatedCardsPage> {
  Map<String, List<FlashCardData>> ratedMap = {
    "Hard": [],
    "Good": [],
    "Easy": [],
  };

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRatings();
  }

  Future<void> loadRatings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < widget.collection.flashcards.length; i++) {
      final rating = prefs.getString("rating_${widget.collection.id}_$i");
      if (rating != null && ratedMap.containsKey(rating)) {
        ratedMap[rating]!.add(widget.collection.flashcards[i]);
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget buildSection(String label, List<FlashCardData> cards) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text("$label (${cards.length})"),
      children: [
        cards.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: Text("Không có thẻ nào",
                    style: TextStyle(color: Colors.grey)),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2 / 3,
                  children:
                      cards.map((card) => FlashCard(cardData: card)).toList(),
                ),
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đã đánh giá")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                buildSection("Hard", ratedMap["Hard"]!),
                buildSection("Good", ratedMap["Good"]!),
                buildSection("Easy", ratedMap["Easy"]!),
              ],
            ),
    );
  }
}
