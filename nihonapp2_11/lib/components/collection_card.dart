import 'package:duandemo/components/dialog_box.dart';
import 'package:duandemo/model/card_provider.dart';
import 'package:duandemo/model/collection_model.dart';
import 'package:duandemo/screens/flashcard/collections_page.dart';
import 'package:duandemo/screens/flashcard/practice_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CollectionCard extends StatelessWidget {
  final CardCollection collection;
  const CollectionCard({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    void onEdit(String title, String desc) {
      Provider.of<CardProvider>(context, listen: false).setCollectionDetails(
        collection,
        title,
        desc,
      );
      Navigator.of(context).pop();
    }

    void handleOnEdit() {
      TextEditingController titleController = TextEditingController.fromValue(
          TextEditingValue(text: collection.title));
      TextEditingController descController = TextEditingController.fromValue(
          TextEditingValue(text: collection.desc));

      showDialog(
        context: context,
        builder: (context) => FDialogBox(
          firstField: "Name",
          secondField: "Description - Optional",
          onSave: () {
            onEdit(titleController.text, descController.text);
          },
          firstController: titleController,
          secondController: descController,
        ),
      );
    }

    void handlePopup(String value) {
      switch (value) {
        case 'Edit':
          handleOnEdit();
          break;
        case 'Delete':
          Provider.of<CardProvider>(context, listen: false)
              .removeCollection(collection);
          break;
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CollectionPage(collection: collection),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 190, // Tăng chiều cao để có đủ không gian hiển thị Description
        child: Card.filled(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          collection.title,
                          style: textTheme.titleLarge,
                        ),
                        const SizedBox(
                            height:
                                5), // Tạo khoảng cách giữa title và description
                        Text(
                          collection.desc.isNotEmpty
                              ? collection.desc
                              : "No description",
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "No. of Cards: ${collection.noOfFlashcards}",
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: <Widget>[
                          PopupMenuButton<String>(
                            onSelected: handlePopup,
                            itemBuilder: (BuildContext context) {
                              return {
                                [const Icon(Icons.edit), 'Edit'],
                                [
                                  Icon(
                                    Icons.delete,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                  'Delete'
                                ]
                              }.map((List choice) {
                                return PopupMenuItem<String>(
                                  value: choice[1],
                                  child: ListTile(
                                    leading: choice[0],
                                    title: Text(choice[1]),
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
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
                  child: Text(
                    "Practice",
                    style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
