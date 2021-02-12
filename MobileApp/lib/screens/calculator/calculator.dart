import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';
import 'package:gtoserviceapp/components/widgets/navigation/nav_bar.dart';
import 'package:gtoserviceapp/components/widgets/navigation/tabs.dart';
import 'package:gtoserviceapp/components/widgets/shrunk_vertically.dart';
import 'package:gtoserviceapp/models/gender.dart';
import 'package:gtoserviceapp/screens/calculator/result.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _ageStr;
  Gender _gender;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Калькулятор"),
          automaticallyImplyLeading: false,
        ),
        body: _buildBody(context),
        bottomNavigationBar: NavigationBar(Tabs.Calculator),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ShrunkVertically(
      child: CardPadding(
        child: Column(
          children: <Widget>[
            _buildGenderRow(context),
            _buildAgeRow(context),
            SizedBox(height: 12),
            _buildSubmitButton(context),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }

  Row _buildAgeRow(BuildContext context) {
    return Row(
      children: <Widget>[
        Text("Возраст:"),
        SizedBox(width: 8),
        _buildAgeInput(context),
      ],
    );
  }

  Row _buildGenderRow(BuildContext context) {
    return Row(
      children: <Widget>[
        Text("Пол:"),
        SizedBox(width: 44),
        _buildGenderSelector(context),
      ],
    );
  }

  Widget _buildGenderSelector(BuildContext context) {
    return DropdownButton(
      value: _gender,
      items: _buildGenderSelectorItems(),
      onChanged: (value) => _onGenderSelectorUpdated(context, value),
      hint: Text("Пол"),
    );
  }

  List<DropdownMenuItem<Gender>> _buildGenderSelectorItems() {
    return <DropdownMenuItem<Gender>>[
      DropdownMenuItem(
        child: Text("Мужской"),
        value: Gender.Male,
      ),
      DropdownMenuItem(
        child: Text("Женский"),
        value: Gender.Female,
      ),
    ];
  }

  _onGenderSelectorUpdated(context, value) {
    setState(() {
      _gender = value;
    });
  }

  Widget _buildAgeInput(BuildContext context) {
    return SizedBox(
      width: 32,
      child: TextFormField(
        textAlign: TextAlign.center,
        initialValue: _ageStr?.toString(),
        keyboardType: TextInputType.number,
        onChanged: (text) => _onAgeChanged(context, text),
      ),
    );
  }

  _onAgeChanged(context, text) {
    setState(() {
      _ageStr = text;
    });
  }

  Widget _buildSubmitButton(BuildContext context) {
    bool buttonEnabled = (_age != null && _gender != null);
    return Center(
      child: RaisedButton(
        child: Text("Получить результаты"),
        onPressed: buttonEnabled ? _onSubmitButtonPressed(context) : null,
        disabledColor: Colors.grey.shade400,
        disabledTextColor: Colors.black,
      ),
    );
  }

  _onSubmitButtonPressed(context) {
    return () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => CalculatorResultScreen(age: _age, gender: _gender),
        ));
  }

  int get _age {
    if (_ageStr == null) {
      return null;
    }

    return int.tryParse(_ageStr);
  }
}
