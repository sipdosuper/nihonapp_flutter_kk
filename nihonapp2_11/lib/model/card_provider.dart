import 'package:duandemo/model/collection_model.dart';
import 'package:duandemo/model/flashcard_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CardProvider extends ChangeNotifier {
  final Box<CardCollection> collectionBox =
      Hive.box<CardCollection>("card_collection");
  final Box<FlashCardData> cardBox = Hive.box<FlashCardData>("flashcard_data");

  List<CardCollection> collections = [];

  void loadData() {
    collections = collectionBox.values.toList();
    for (var col in collections) {
      debugPrint("Loaded collection: ${col.title} - id: ${col.id}");
    }
    notifyListeners();
  }

  Future<void> addCollection(CardCollection collection) async {
    await collectionBox.add(collection);
    loadData(); // dùng loadData để đảm bảo đồng bộ state
  }

  Future<void> addCollections(List<CardCollection> newCollections) async {
    await collectionBox.addAll(newCollections);
    loadData();
  }

  Future<void> removeCollection(CardCollection collection) async {
    final key = collection.key;
    await collectionBox.delete(key);
    loadData();
  }

  Future<void> addCardToCollection(
      CardCollection collection, FlashCardData card) async {
    await cardBox.add(card);
    collection.flashcards.add(card);
    await collection.save();
    debugPrint("Added card to collection with id: ${collection.id}");
    notifyListeners();
  }

  Future<void> removeCardFromCollection(FlashCardData card) async {
    await card.delete();
    loadData();
  }

  List<FlashCardData> allCards() {
    return collections.expand((col) => col.flashcards).toList();
  }

  Future<void> setCollectionDetails(
      CardCollection collection, String title, String desc) async {
    collection.setDetails(title, desc);
    await collection.save();
    notifyListeners();
  }

  Future<void> setFlashCardDetails(
    FlashCardData flashcard,
    String frontSide,
    String backSide,
  ) async {
    flashcard.setFrontSide = frontSide;
    flashcard.setBackSide = backSide;
    await flashcard.save();
    notifyListeners();
  }
}
