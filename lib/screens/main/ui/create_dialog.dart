import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:techarrow_mobile/storage/storage.dart';

class CreateDialog {
  final TextEditingController _controller = TextEditingController();

  Widget build(BuildContext context, {Function? onCreate}) {
    return AlertDialog(
      title: const Text("Создание комикса"),
      content: Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: _controller,
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel")),
        TextButton(
            onPressed: () {
              ApplicationStorage().createComics(_controller.text).then((val) {
                Fluttertoast.showToast(msg: "ok");
                if (context.mounted) Navigator.of(context).pop();
                if (onCreate != null) onCreate();
              }).catchError((err) {
                Fluttertoast.showToast(msg: err);

                if (context.mounted) Navigator.of(context).pop();
              });
            },
            child: const Text("OK")),
      ],
    );
  }
}
