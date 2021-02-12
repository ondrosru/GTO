import 'package:flutter/material.dart';

class YesNoDialog extends StatelessWidget {
  final String _title;
  final Function() _onYes;

  YesNoDialog(this._title, this._onYes);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      actions: <Widget>[
        FlatButton(
          child: Text("Нет"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Да"),
          onPressed: () {
            _onYes();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
