import 'package:flutter/material.dart';

class TextPlaceholder extends StatelessWidget {
  final String _text;

  TextPlaceholder.empty() : _text = "";

  TextPlaceholder.progress() : _text = "...";

  @override
  Widget build(BuildContext context) {
    return Text(_text);
  }
}
