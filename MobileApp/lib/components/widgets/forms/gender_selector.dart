import 'package:flutter/material.dart';
import 'package:gtoserviceapp/models/gender.dart';

class GenderSelector extends StatefulWidget {
  final Function(Gender) _onValueChanged;

  GenderSelector(this._onValueChanged);

  @override
  _GenderSelectorState createState() => _GenderSelectorState(_onValueChanged);
}

class _GenderSelectorState extends State<GenderSelector> {
  final Function(Gender) _onValueChanged;
  Gender _value = Gender.Male;

  _GenderSelectorState(this._onValueChanged) {
    _onValueChanged(this._value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _buildRadio(Gender.Male),
        _buildRadio(Gender.Female),
      ],
    );
  }

  _buildRadio(Gender value) {
    return GestureDetector(
      onTap: () => _onTap(value),
      child: Row(
        children: <Widget>[
          Radio(value: value, groupValue: _value, onChanged: _onTap),
          Text(value.toStr()),
        ],
      ),
    );
  }

  _onTap(Gender value) {
    setState(() {
      _onValueChanged(value);
      _value = value;
    });
  }
}
