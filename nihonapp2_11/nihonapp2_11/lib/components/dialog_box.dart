import 'package:flutter/material.dart';

class FDialogBox extends StatelessWidget {
  final String firstField;
  final String secondField;
  final VoidCallback onSave;
  final TextEditingController firstController;
  final TextEditingController secondController;
  const FDialogBox({
    super.key,
    required this.firstField,
    required this.secondField,
    required this.onSave,
    required this.firstController,
    required this.secondController,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 12),
        child: SizedBox(
          height: 230,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  TextField(
                    controller: firstController,
                    decoration: InputDecoration(labelText: firstField),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: secondController,
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(
                        labelText: secondField, alignLabelWithHint: true),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Cancel",
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: onSave,
                    child: const Text("Save"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
