import 'package:flutter/material.dart';

const DefaultMargin = EdgeInsets.fromLTRB(16, 16, 16, 0);
const ListMargin = EdgeInsets.symmetric(vertical: 4, horizontal: 16);

class CardPadding extends StatelessWidget {
  final Widget _child;
  final EdgeInsets _margin;
  final Function() _onTap;

  CardPadding(
      {@required Widget child,
      EdgeInsets margin = DefaultMargin,
      Function() onTap})
      : _child = child,
        _margin = margin,
        _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: _margin,
      child: _onTap != null
          ? InkWell(
              onTap: _onTap,
              child: _buildCardChild(),
            )
          : _buildCardChild(),
    );
  }

  Widget _buildCardChild() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _child,
    );
  }
}
