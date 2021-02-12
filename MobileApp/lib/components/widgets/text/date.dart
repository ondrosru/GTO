import 'package:flutter/material.dart';
import 'package:gtoserviceapp/services/utils/utils.dart';

class DateText extends StatelessWidget {
  final DateTime _dateTime;

  DateText(this._dateTime);

  @override
  Widget build(BuildContext context) {
    return Text(Utils.formatDate(_dateTime));
  }
}
