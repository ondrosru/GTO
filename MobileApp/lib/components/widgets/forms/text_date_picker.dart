import 'package:flutter/material.dart';
import 'package:gtoserviceapp/services/utils/utils.dart';

class TextDatePicker extends StatelessWidget {
  final DateTime _initialDate;
  final DateTime _firstDate;
  final DateTime _lastDate;
  final String _label;
  final Function(DateTime) _onPicked;
  final DatePickerMode _mode;

  static DateTime _fixInitialDate(
    DateTime initialDate,
    DateTime firstDate,
    DateTime lastDate,
  ) {
    firstDate ??= DateTime(1900);
    lastDate ??= DateTime(2100);
    if (initialDate.isBefore(firstDate)) {
      return firstDate;
    }
    if (initialDate.isAfter(lastDate)) {
      return lastDate;
    }
    return initialDate;
  }

  TextDatePicker(
    this._onPicked, {
    String label,
    DateTime initialDate,
    DateTime firstDate,
    DateTime lastDate,
    DatePickerMode mode,
  })  : _label = label,
        _firstDate = firstDate ?? DateTime(1900),
        _lastDate = lastDate ?? DateTime(2100),
        _initialDate =
            _fixInitialDate(initialDate ?? DateTime.now(), firstDate, lastDate),
        _mode = mode ?? DatePickerMode.day;

  @override
  Widget build(BuildContext context) {
    TextEditingController ctl = TextEditingController(
      text: Utils.formatDate(_initialDate),
    );

    return TextFormField(
      controller: ctl,
      readOnly: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.date_range),
        labelText: _label,
      ),
      onTap: () => _onTap(context, ctl),
    );
  }

  Future _onTap(context, TextEditingController ctl) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: _initialDate,
      initialDatePickerMode: _mode,
      firstDate: _firstDate,
      lastDate: _lastDate,
    );

    if (picked == null) {
      return;
    }

    _onPicked(picked);
  }
}
