import 'package:flutter/material.dart';
import 'package:gtoserviceapp/services/utils/utils.dart';

class TextDateTimePicker extends StatelessWidget {
  final DateTime _initialDate;
  final DateTime _firstDate;
  final DateTime _lastDate;
  final String _label;
  final Function(DateTime) _onPicked;

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

  TextDateTimePicker(
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
            _fixInitialDate(initialDate ?? DateTime.now(), firstDate, lastDate);

  @override
  Widget build(BuildContext context) {
    TextEditingController ctl = TextEditingController(
      text: Utils.formatDateTime(_initialDate),
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
    DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: _firstDate,
      lastDate: _lastDate,
    );
    if (pickedDate == null) {
      return;
    }

    TimeOfDay pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) {
      return;
    }

    _onPicked(_combine(pickedDate, pickedTime));
  }

  DateTime _combine(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
