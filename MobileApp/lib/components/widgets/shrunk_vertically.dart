import 'package:flutter/material.dart';

class ShrunkVertically extends StatelessWidget {
  final Widget _child;

  ShrunkVertically({@required Widget child}) : _child = child;

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          _child,
          Spacer(),
        ],
      );
}
