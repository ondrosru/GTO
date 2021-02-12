import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';
import 'package:gtoserviceapp/components/widgets/dialogs/error_dialog.dart';
import 'package:gtoserviceapp/components/widgets/forms/text_date_picker.dart';
import 'package:gtoserviceapp/components/widgets/future_widget_builder.dart';
import 'package:gtoserviceapp/services/repo/event.dart';

class AddEditEventScreen extends StatefulWidget {
  final int orgId;
  final int eventId;
  final void Function() onUpdate;

  AddEditEventScreen({
    @required this.orgId,
    this.eventId,
    @required this.onUpdate,
  });

  @override
  _AddEditEventScreenState createState() =>
      _AddEditEventScreenState(orgId: orgId, eventId: eventId);
}

class _AddEditEventScreenState extends State<AddEditEventScreen> {
  final int orgId;
  final int eventId;
  final _formKey = GlobalKey<FormState>();
  Future<Event> _futureEvent;
  Event _event;

  _AddEditEventScreenState({@required this.orgId, this.eventId}) {
    if (eventId == null) {
      _futureEvent = Future.value(
        Event(
          startDate: DateTime.now(),
          expirationDate: DateTime.now(),
        ),
      );
    } else {
      _futureEvent = EventRepo.I.get(orgId, eventId);
    }
  }

  bool get _isEditing {
    return eventId != null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("${_isEditing ? "Редактирование" : "Создание"} мероприятия"),
    );
  }

  Widget _buildBody() {
    return _buildFutureForm();
  }

  Widget _buildFutureForm() {
    return FutureWidgetBuilder(
      _futureEvent,
      (_, Event event) {
        _event = event;
        return _buildForm();
      },
    );
  }

  Widget _buildForm() {
    return CardPadding(
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            _buildNameField(),
            _buildDescriptionField(),
            _buildStartDateField(),
            _buildExpirationDateField(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  TextFormField _buildNameField() {
    return TextFormField(
      initialValue: _event.name,
      decoration: InputDecoration(
        labelText: "Название",
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "Введите название мероприятия";
        }
        return null;
      },
      onSaved: (value) {
        _event.name = value;
      },
    );
  }

  TextFormField _buildDescriptionField() {
    return TextFormField(
      initialValue: _event.description,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: "Описание",
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "Введите описание мероприятия";
        }
        return null;
      },
      onSaved: (value) {
        _event.description = value;
      },
    );
  }

  Widget _buildStartDateField() {
    return TextDatePicker(
      (picked) {
        setState(() {
          _event.startDate = picked;
        });
      },
      initialDate: _event.startDate,
      label: "Дата начала",
    );
  }

  Widget _buildExpirationDateField() {
    return TextDatePicker(
      (picked) {
        setState(() {
          _event.expirationDate = picked;
        });
      },
      initialDate: _event.expirationDate,
      label: "Дата завершения",
    );
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      child: Text(_isEditing ? "Сохранить" : "Создать"),
      onPressed: _onSubmitPressed,
    );
  }

  _onSubmitPressed() {
    var form = _formKey.currentState;
    if (!form.validate()) {
      return;
    }
    form.save();

    var future = _isEditing
        ? EventRepo.I.update(orgId, _event)
        : EventRepo.I.add(orgId, _event);
    future.then((_) {
      widget.onUpdate();
      Navigator.of(context).pop();
    }).catchError((error) {
      showDialog(context: context, child: ErrorDialog.fromError(error));
    });
  }
}
