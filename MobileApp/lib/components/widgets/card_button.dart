import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';

class CardButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function() onTap;

  CardButton({@required this.text, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CardPadding(
      child: Row(
        children: <Widget>[
          icon != null ? Icon(icon, color: Colors.black54) : Container(),
          icon != null ? SizedBox(width: 8) : Container(),
          Text(text),
        ],
      ),
      onTap: onTap,
    );
  }
}
