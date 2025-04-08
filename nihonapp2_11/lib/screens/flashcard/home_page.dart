import 'package:duandemo/components/collection_card.dart';
import 'package:duandemo/components/dialog_box.dart';
import 'package:duandemo/components/drawer.dart';
import 'package:duandemo/model/card_provider.dart';
import 'package:duandemo/model/collection_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController firstController = TextEditingController();

  final TextEditingController secondController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Provider.of<CardProvider>(context, listen: false).loadData();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    void onSave(CardProvider value) {
      CardCollection newCollection = CardCollection(
        title: firstController.text,
        desc: secondController.text,
      );
      firstController.clear();
      secondController.clear();
      value.addCollection(newCollection);
      Navigator.of(context).pop();
    }

    return Consumer<CardProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(),
        drawer: const FDrawer(),
        // body: Text("Hello there"),
        body: ListView.builder(
          itemCount: value.collections.length,
          itemBuilder: (context, index) => CollectionCard(
            collection: value.collections[index],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => FDialogBox(
                firstField: "Name",
                secondField: "Description - Optional",
                firstController: firstController,
                secondController: secondController,
                onSave: () {
                  onSave(value);
                },
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text("Add Collection"),
        ),
      ),
    );
  }
}
