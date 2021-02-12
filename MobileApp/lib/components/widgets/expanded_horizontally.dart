import 'package:flutter/material.dart';

class ExpandedHorizontally extends StatelessWidget {
  final Widget _child;

  ExpandedHorizontally({@required Widget child}) : _child = child;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Expanded(
            child: _child,
          ),
        ],
      );
}
