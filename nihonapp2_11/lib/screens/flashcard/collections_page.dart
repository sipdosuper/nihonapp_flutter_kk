import 'package:duandemo/components/dialog_box.dart';
import 'package:duandemo/components/flashcard.dart';
import 'package:duandemo/model/card_provider.dart';
import 'package:duandemo/model/collection_model.dart';
import 'package:duandemo/model/flashcard_model.dart';
import 'package:duandemo/screens/flashcard/practice_page.dart';
import 'package:duandemo/screens/flashcard/rated_cards_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CollectionPage extends StatelessWidget {
  final CardCollection collection;
  final TextEditingController firstController = TextEditingController();
  final TextEditingController secondController = TextEditingController();

  CollectionPage({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    void onSave(CardProvider value) {
      FlashCardData newFlashcard = FlashCardData(
        frontSide: firstController.text,
        backSide: secondController.text,
      );
      firstController.clear();
      secondController.clear();
      value.addCardToCollection(collection, newFlashcard);
    }

    return Consumer<CardProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Bộ thẻ"),
          actions: [
            IconButton(
              tooltip: "Luyện tập",
              onPressed: () {
                if (collection.flashcards.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PracticePage(collection: collection),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.school),
            ),
            IconButton(
              tooltip: "Xem đã đánh giá",
              icon: const Icon(Icons.bar_chart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RatedCardsPage(collection: collection),
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GridView.count(
            crossAxisCount: 3,
            children: List.generate(
              collection.flashcards.length,
              (index) => FlashCard(
                cardData: collection.flashcards[index],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return FDialogBox(
                  firstField: "Front Side",
                  secondField: "Back Side",
                  firstController: firstController,
                  secondController: secondController,
                  onSave: () {
                    onSave(value);
                  },
                );
              },
            );
          },
          icon: const Icon(Icons.add),
          label: const Text("Add Card"),
        ),
      ),
    );
  }
}
