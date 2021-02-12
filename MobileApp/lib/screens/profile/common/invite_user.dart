import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';
import 'package:gtoserviceapp/components/widgets/dialogs/error_dialog.dart';
import 'package:gtoserviceapp/components/widgets/forms/gender_selector.dart';
import 'package:gtoserviceapp/components/widgets/forms/text_date_picker.dart';
import 'package:gtoserviceapp/components/widgets/shrunk_vertically.dart';
import 'package:gtoserviceapp/models/gender.dart';
import 'package:gtoserviceapp/services/repo/user.dart';

class InviteUserScreen extends StatefulWidget {
  final String title;
  final Future Function(String email) addUser;
  final void Function() onUpdate;

  InviteUserScreen({
    @required this.title,
    @required this.addUser,
    this.onUpdate,
  });

  @override
  _InviteUserScreenState createState() => _InviteUserScreenState();
}

class _InviteUserScreenState extends State<InviteUserScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _newProfile = true;
  InviteUserArgs _params = InviteUserArgs(dateOfBirth: DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ShrunkVertically(
      child: CardPadding(
          child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _buildSwitchWithText(),
            _buildForm(),
            SizedBox(height: 8),
            _buildSubmitButton(),
          ],
        ),
      )),
    );
  }

  Row _buildSwitchWithText() {
    return Row(
      children: <Widget>[
        _buildSwitch(),
        Text("Новый пользователь"),
      ],
    );
  }

  _buildSwitch() {
    return Switch(
      value: _newProfile,
      onChanged: (bool value) {
        setState(() {
          _newProfile = value;
        });
      },
    );
  }

  Widget _buildForm() {
    if (_newProfile) {
      return _buildNewProfileForm();
    } else {
      return _buildExistingProfileForm();
    }
  }

  Widget _buildNewProfileForm() {
    return Column(
      children: <Widget>[
        _buildNameField(),
        _buildEmailField(),
        _buildBirthDateField(context),
        _buildGenderSelector(),
      ],
    );
  }

  GenderSelector _buildGenderSelector() {
    return GenderSelector((Gender value) {
      _params.gender = value;
    });
  }

  Widget _buildNameField() {
    return TextFormField(
      initialValue: _params.name,
      decoration: InputDecoration(
        labelText: "ФИО",
        prefixIcon: Icon(Icons.person),
      ),
      onSaved: (value) {
        _params.name = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Введите ФИО";
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      initialValue: _params.email,
      decoration: InputDecoration(
        labelText: "Почта",
        prefixIcon: Icon(Icons.email),
      ),
      onSaved: (value) {
        _params.email = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Введите почтовый адрес";
        }
        return null;
      },
    );
  }

  Widget _buildExistingProfileForm() {
    return _buildEmailField();
  }

  Widget _buildBirthDateField(context) {
    return TextDatePicker(
      (picked) {
        setState(() {
          this._params.dateOfBirth = picked;
        });
      },
      initialDate: _params.dateOfBirth,
      lastDate: DateTime.now(),
      label: "Дата рождения",
      mode: DatePickerMode.year,
    );
  }

  _buildSubmitButton() {
    return RaisedButton(
        child: Text("Пригласить"),
        onPressed: () async {
          var form = _formKey.currentState;

          if (form.validate()) {
            form.save();

            if (_newProfile) {
              var future = UserRepo.I.invite(_params);
              ErrorDialog.showOnFutureError(context, future);
              await future;
            }

            var future = widget.addUser(_params.email);
            ErrorDialog.showOnFutureError(context, future);
            await future;

            widget.onUpdate?.call();
            Navigator.of(context).pop();
          }
        });
  }
}
