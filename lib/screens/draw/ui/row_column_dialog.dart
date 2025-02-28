import 'package:flutter/material.dart';

class RowsColumnsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int rows = 0;
    int columns = 0;

    return AlertDialog(
      title: Text('Enter rows and columns'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Rows'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              rows = int.parse(value);
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Columns'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              columns = int.parse(value);
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            // Здесь вы можете использовать значения rows и columns
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
