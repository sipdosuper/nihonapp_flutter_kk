import 'package:duandemo/model/collection_model.dart';
import 'package:duandemo/model/flashcard_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CardProvider extends ChangeNotifier {
  final collectionBox = Hive.box<CardCollection>("card_collection");
  final cardBox = Hive.box<FlashCardData>("flashcard_data");

  List<CardCollection> collections = [];

  void loadData() {
    collections = collectionBox.values.toList();
    for (var col in collections) {
      debugPrint("Loaded collection: ${col.title} - id: ${col.id}");
    }
    notifyListeners();
  }

  void addCollection(CardCollection collection) async {
    await collectionBox.add(collection);
    collections = collectionBox.values.toList();
    notifyListeners();
  }

  void addCollections(List<CardCollection> newCollections) async {
    await collectionBox.addAll(newCollections);
    collections = collectionBox.values.toList();
    notifyListeners();
  }

  void removeCollection(CardCollection collection) async {
    await collection.delete();
    collections.remove(collection);
    notifyListeners();
  }

  void addCardToCollection(
      CardCollection collection, FlashCardData card) async {
    await cardBox.add(card);
    collection.flashcards.add(card);
    await collection.save();
    debugPrint("Added card to collection with id: ${collection.id}");
    notifyListeners();
  }

  void removeCardFromCollection(FlashCardData card) async {
    await card.delete();
    notifyListeners();
  }

  List<FlashCardData> allCards() {
    return collections.expand((element) => element.flashcards).toList();
  }

  void setCollectionDetails(
      CardCollection collection, String title, String desc) {
    collection.setDetails(title, desc);
    collection.save();
    notifyListeners();
  }

  void setFlashCardDetails(
    FlashCardData flashcard,
    String frontSide,
    String backSide,
  ) {
    flashcard.setFrontSide = frontSide;
    flashcard.setBackSide = backSide;
    flashcard.save();
    notifyListeners();
  }
}
