import 'package:duandemo/components/dialog_box.dart';
import 'package:duandemo/model/card_provider.dart';
import 'package:duandemo/model/flashcard_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlashCard extends StatefulWidget {
  final FlashCardData cardData;

  const FlashCard({super.key, required this.cardData});

  @override
  State<FlashCard> createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  bool isBookmarked = false;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    void onEdit(String title, String desc) {
      Provider.of<CardProvider>(context, listen: false).setFlashCardDetails(
        widget.cardData,
        title,
        desc,
      );
      Navigator.of(context).pop();
    }

    void handleOnEdit() {
      TextEditingController fSideController = TextEditingController.fromValue(
        TextEditingValue(text: widget.cardData.getFrontSide),
      );
      TextEditingController bSideController = TextEditingController.fromValue(
        TextEditingValue(text: widget.cardData.getBackSide),
      );
      showDialog(
        context: context,
        builder: (context) => FDialogBox(
          firstField: "Front Side",
          secondField: "Back Side",
          onSave: () {
            onEdit(fSideController.text, bSideController.text);
          },
          firstController: fSideController,
          secondController: bSideController,
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
              .removeCardFromCollection(
            // widget.parentCollection,
            widget.cardData,
          );
          break;
      }
    }

    return SizedBox(
      width: 200,
      height: 300,
      child: Card.filled(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            top: 10.0,
            bottom: 10.0,
            right: 5.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            child: Center(
                              widthFactor: 1,
                              child: Text(
                                widget.cardData.getFrontSide,
                                style: textTheme.titleSmall,
                              ),
                            ),
                          ),
                          Text(
                            widget.cardData.getBackSide,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey[700],
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        PopupMenuButton<String>(
                          onSelected: handlePopup,
                          itemBuilder: (BuildContext context) {
                            return {
                              [const Icon(Icons.edit), 'Edit'],
                              [
                                Icon(
                                  Icons.delete,
                                  color: Theme.of(context).colorScheme.tertiary,
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
                  ],
                ),
              ),
              Flexible(
                child: IconButton(
                  tooltip: "Bookmark Flashcard",
                  isSelected: widget.cardData.bookmarked,
                  selectedIcon: const Icon(Icons.bookmark),
                  onPressed: () {
                    widget.cardData.toggleBookmark();
                    setState(() {
                      isBookmarked = !isBookmarked;
                    });
                  },
                  icon: const Icon(Icons.bookmark_outline),
                  color: Theme.of(context).colorScheme.tertiary,
                  alignment: Alignment.bottomRight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
