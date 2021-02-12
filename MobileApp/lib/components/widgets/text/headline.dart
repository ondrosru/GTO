import 'package:flutter/material.dart';

class HeadlineText extends StatelessWidget {
  final String _data;
  final Color _color;

  HeadlineText(this._data, {Color color}) : _color = color;

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).textTheme.headline5;
    if (_color != null) {
      style = style.copyWith(color: _color);
    }

    return Text(_data, style: style);
  }
}
