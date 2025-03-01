import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:techarrow_mobile/storage/storage.dart';

class CreatePageDialog {
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  Widget build(BuildContext context, String title, {Function? onCreate}) {
    return AlertDialog(
      title: const Text("Создать страницу"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: "Ширина"),
            keyboardType: TextInputType.number,
            controller: _widthController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          TextField(
            decoration: const InputDecoration(labelText: "Высота"),
            keyboardType: TextInputType.number,
            controller: _heightController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel")),
        TextButton(
            onPressed: () {
              try {
                ApplicationStorage().createComicsPage(
                    title,
                    int.parse(_heightController.text),
                    int.parse(_widthController.text));
                if (context.mounted) {
                  Navigator.of(context).pop();
                  if (onCreate != null) onCreate();
                }
              } catch (e) {
                print(e);
                Fluttertoast.showToast(msg: "error $e");
                if (context.mounted) Navigator.of(context).pop();
              }
            },
            child: const Text("OK")),
      ],
    );
  }
}
