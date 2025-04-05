import 'package:duandemo/model/flashcard_model.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'collection_model.g.dart';

@HiveType(typeId: 0)
class CardCollection extends HiveObject {
  @HiveField(0)
  HiveList<FlashCardData> flashcards = HiveList(
    Hive.box<FlashCardData>('flashcard_data'),
  );

  @HiveField(1)
  String title;

  @HiveField(2)
  String desc;

  @HiveField(3)
  String id; // Thêm ID

  CardCollection({
    required this.title,
    required this.desc,
    String? id,
  }) : id = id ?? const Uuid().v4(); // Tự động sinh ID nếu không truyền vào

  get getFlashcards => flashcards;
  get noOfFlashcards => flashcards.length;

  void addFlashcard(FlashCardData flashcard) {
    flashcards.add(flashcard);
  }

  void removeFlashcard(FlashCardData flashcard) {
    flashcards.remove(flashcard);
  }

  void setDetails(String title, String desc) {
    this.title = title;
    this.desc = desc;
  }

  CardCollection.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? "",
        desc = json['desc'] ?? "",
        id = json['id'] ?? const Uuid().v4() {
    List<dynamic> flashcardsFromJson = json['flashcards'];
    List<FlashCardData> temp = flashcardsFromJson
        .map(
          (e) => FlashCardData.fromJson(e),
        )
        .toList();

    flashcards = HiveList(
      Hive.box<FlashCardData>('flashcard_data'),
      objects: temp,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'desc': desc,
        'id': id,
        'flashcards': flashcards.map((e) => e.toJson()).toList(),
      };
}
