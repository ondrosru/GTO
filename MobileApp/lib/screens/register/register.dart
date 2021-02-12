import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';
import 'package:gtoserviceapp/components/widgets/dialogs/error_dialog.dart';
import 'package:gtoserviceapp/components/widgets/forms/gender_selector.dart';
import 'package:gtoserviceapp/components/widgets/forms/text_date_picker.dart';
import 'package:gtoserviceapp/components/widgets/shrunk_vertically.dart';
import 'package:gtoserviceapp/models/gender.dart';
import 'package:gtoserviceapp/screens/register/success.dart';
import 'package:gtoserviceapp/services/repo/user.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  InviteUserArgs _params = InviteUserArgs(dateOfBirth: DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Регистрация")),
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
            _buildForm(),
            SizedBox(height: 8),
            _buildSubmitButton(),
          ],
        ),
      )),
    );
  }

  Widget _buildForm() {
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
        prefixIcon: Icon(Icons.person),
        labelText: "ФИО",
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
        child: Text("Регистрация"),
        onPressed: () async {
          var form = _formKey.currentState;

          if (form.validate()) {
            form.save();

            var future = UserRepo.I.invite(_params);
            ErrorDialog.showOnFutureError(context, future);
            await future;

            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) {
              return RegisterSuccessScreen();
            }));
          }
        });
  }
}
