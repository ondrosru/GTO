import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';
import 'package:gtoserviceapp/components/widgets/dialogs/error_dialog.dart';
import 'package:gtoserviceapp/components/widgets/shrunk_vertically.dart';
import 'package:gtoserviceapp/services/repo/sport_object.dart';
import 'package:gtoserviceapp/services/storage/storage.dart';

class AddSportObjectScreen extends StatefulWidget {
  final SportObject _sportObject;

  AddSportObjectScreen({SportObject sportObject}) : _sportObject = sportObject;

  @override
  _AddSportObjectScreenState createState() =>
      _AddSportObjectScreenState(_sportObject);
}

class _AddSportObjectScreenState extends State<AddSportObjectScreen> {
  final _formKey = GlobalKey<FormState>();
  SportObject _sportObject;

  _AddSportObjectScreenState(SportObject sportObject)
      : _sportObject = sportObject ?? SportObject();

  bool get _isEditing {
    return _sportObject.id != null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: _buildTitle(),
        ),
        body: _buildBody(),
      ),
    );
  }

  Text _buildTitle() {
    return Text(
      (_isEditing ? "Редактирование" : "Добавление") + " спортивного объекта",
    );
  }

  Widget _buildBody() {
    return _buildForm();
  }

  Widget _buildForm() {
    return ShrunkVertically(
      child: CardPadding(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildNameField(),
              _buildAddressField(),
              _buildDescriptionField(),
              SizedBox(height: 16),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      child: Text(_isEditing ? "Сохранить" : "Добавить"),
      onPressed: _onSubmitPressed,
    );
  }

  TextFormField _buildNameField() {
    return TextFormField(
      initialValue: _sportObject.name,
      decoration: InputDecoration(
        labelText: "Название",
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "Введите название спортивного объекта";
        }
        return null;
      },
      onSaved: (value) {
        _sportObject.name = value;
      },
    );
  }

  TextFormField _buildAddressField() {
    return TextFormField(
      initialValue: _sportObject.address,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: "Адрес",
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "Введите адрес спортивного объекта";
        }
        return null;
      },
      onSaved: (value) {
        _sportObject.address = value;
      },
    );
  }

  TextFormField _buildDescriptionField() {
    return TextFormField(
      initialValue: _sportObject.description,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: "Описание",
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "Введите описание спортивного объекта";
        }
        return null;
      },
      onSaved: (value) {
        _sportObject.description = value;
      },
    );
  }

  _onSubmitPressed() async {
    var form = _formKey.currentState;
    if (!form.validate()) {
      return;
    }
    form.save();

    final int orgId = Storage.I.orgId;
    var future = _isEditing
        ? SportObjectRepo.I.update(orgId, _sportObject)
        : SportObjectRepo.I.add(orgId, _sportObject);
    ErrorDialog.showOnFutureError(context, future);
    await future;

    Navigator.of(context).pop();
  }
}
