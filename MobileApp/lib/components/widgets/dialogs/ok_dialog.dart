import 'package:flutter/material.dart';

class OkDialog extends StatelessWidget {
  final String _title;
  final String _text;

  OkDialog(this._title, {text}) : this._text = text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      content: _text == null ? null : Text(_text),
      actions: <Widget>[
        FlatButton(
          child: Text("Ok"),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
