import 'package:flutter/material.dart';

enum Badge {
  Bronze,
  Silver,
  Gold,
  Error,
  Null,
}

extension BadgeEx on Badge {
  static Badge fromString(String str) {
    if (str == null) {
      return Badge.Null;
    }

    switch (str?.toLowerCase()) {
      case "бронза":
        return Badge.Bronze;
      case "серебро":
        return Badge.Silver;
      case "золото":
        return Badge.Gold;
      default:
        return Badge.Error;
    }
  }

  Widget toWidget() {
    if (this == Badge.Null) {
      return Container();
    }

    return Icon(Icons.brightness_1, color: _toColor());
  }

  Color _toColor() {
    switch (this) {
      case Badge.Bronze:
        return Colors.brown.shade300;
      case Badge.Silver:
        return Colors.grey;
      case Badge.Gold:
        return Colors.yellow;
      case Badge.Error:
        return Colors.red;
      default:
        return null;
    }
  }
}
