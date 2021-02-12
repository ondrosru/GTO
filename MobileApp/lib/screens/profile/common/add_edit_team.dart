import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';
import 'package:gtoserviceapp/components/widgets/dialogs/error_dialog.dart';
import 'package:gtoserviceapp/components/widgets/future_widget_builder.dart';
import 'package:gtoserviceapp/services/repo/team.dart';

class AddEditTeamScreen extends StatefulWidget {
  final int orgId;
  final int eventId;
  final Function() onUpdate;
  final int teamId;

  AddEditTeamScreen({
    this.orgId,
    this.eventId,
    @required this.onUpdate,
    this.teamId,
  });

  @override
  _AddEditTeamScreenState createState() => _AddEditTeamScreenState();
}

class _AddEditTeamScreenState extends State<AddEditTeamScreen> {
  final _key = GlobalKey<FormState>();
  String _name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text((_isEditing() ? "Редактирование" : "Создание") + " команды"),
    );
  }

  bool _isEditing() {
    return widget.teamId != null;
  }

  Widget _buildBody() {
    if (!_isEditing()) {
      return _buildForm();
    }

    return _buildFutureForm();
  }

  Widget _buildFutureForm() {
    return FutureWidgetBuilder(
      TeamRepo.I.get(widget.teamId),
      (context, Team team) {
        _name = team.name;
        return _buildForm();
      },
    );
  }

  Form _buildForm() {
    return Form(
      key: _key,
      child: CardPadding(
        child: Column(
          children: <Widget>[
            _buildNameField(),
            SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  TextFormField _buildNameField() {
    return TextFormField(
      initialValue: _name,
      decoration: InputDecoration(
        labelText: "Название команды",
      ),
      autofocus: true,
      onChanged: (String name) {
        _name = name;
      },
      validator: (String name) {
        if (name.isEmpty) {
          return "Введите название команды";
        }
        return null;
      },
    );
  }

  RaisedButton _buildSubmitButton() {
    return RaisedButton(
      child: Text((_isEditing() ? "Обновить" : "Создать")),
      onPressed: _onSubmitPressed,
    );
  }

  void _onSubmitPressed() {
    var form = _key.currentState;
    if (!form.validate()) {
      return;
    }
    form.save();

    var future = _isEditing()
        ? TeamRepo.I.update(widget.teamId, _name)
        : TeamRepo.I.addToEvent(widget.orgId, widget.eventId, _name);
    future.then((_) {
      widget.onUpdate();
      Navigator.of(context).pop();
    }).catchError((error) {
      showDialog(context: context, child: ErrorDialog.fromError(error));
    });
  }
}
