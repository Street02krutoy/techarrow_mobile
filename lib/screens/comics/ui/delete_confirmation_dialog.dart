import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:techarrow_mobile/storage/storage.dart';

class DeleteConfirmationDialog {
  Widget build(BuildContext context, String title, {Function? onDelete}) {
    return AlertDialog(
      title: const Text("Внимание!"),
      content: const Padding(
        padding: EdgeInsets.all(8),
        child: Text("Вы действительно хотите удалить комикс?"),
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
                ApplicationStorage().deleteComics(title).then((val) {
                  Fluttertoast.showToast(msg: "Успешно!");
                  if (context.mounted) Navigator.of(context).pop();
                  if (onDelete != null) onDelete();
                }).catchError((err) {
                  Fluttertoast.showToast(msg: err);

                  if (context.mounted) Navigator.of(context).pop();
                });
              } catch (e) {
                Fluttertoast.showToast(msg: "error $e");
                if (context.mounted) Navigator.of(context).pop();
              }
            },
            child: const Text("OK")),
      ],
    );
  }
}
