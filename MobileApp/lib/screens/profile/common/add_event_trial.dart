import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';
import 'package:gtoserviceapp/components/widgets/dialogs/error_dialog.dart';
import 'package:gtoserviceapp/components/widgets/expanded_horizontally.dart';
import 'package:gtoserviceapp/components/widgets/forms/selector.dart';
import 'package:gtoserviceapp/components/widgets/forms/text_date_time_picker.dart';
import 'package:gtoserviceapp/components/widgets/future_widget_builder.dart';
import 'package:gtoserviceapp/services/repo/sport_object.dart';
import 'package:gtoserviceapp/services/repo/trial.dart';

class AddEventTrialScreen extends StatefulWidget {
  final int orgId;
  final int eventId;
  final Future<List<EventTrial>> trials;
  final Future<List<SportObject>> sportObjects;
  final void Function() onUpdate;

  AddEventTrialScreen({
    @required this.orgId,
    @required this.eventId,
    @required this.onUpdate,
  })  : trials = TrialRepo.I.getFreeTrialsFromEvent(eventId),
        sportObjects = SportObjectRepo.I.getAll(orgId);

  @override
  _AddEventTrialScreenState createState() => _AddEventTrialScreenState();
}

class _AddEventTrialScreenState extends State<AddEventTrialScreen> {
  int _trialId;
  int _sportObjectId;
  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Добавление вида спорта")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ExpandedHorizontally(
      child: CardPadding(
        child: Column(
          children: <Widget>[
            _buildFutureTrialSelector(),
            SizedBox(height: 16),
            _buildFutureSportObjectSelector(),
            SizedBox(height: 16),
            _buildDateTimePicker(),
            SizedBox(height: 16),
            _buildSubmitButton(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFutureTrialSelector() {
    return FutureWidgetBuilder(widget.trials, _buildTrialSelector);
  }

  Widget _buildTrialSelector(context, List<EventTrial> list) {
    return Selector<EventTrial, int>(
      hint: "Вид спорта",
      value: _trialId,
      data: list,
      builder: _buildEvent,
      getKey: (EventTrial trial) => trial.id,
      onChanged: _onTrialChanged,
    );
  }

  void _onTrialChanged(int trialId) {
    setState(() {
      _trialId = trialId;
    });
  }

  Widget _buildEvent(EventTrial trial) {
    return Text(trial.name);
  }

  Widget _buildFutureSportObjectSelector() {
    return FutureWidgetBuilder(widget.sportObjects, _buildSportObjectSelector);
  }

  Widget _buildSportObjectSelector(context, List<SportObject> list) {
    return Selector<SportObject, int>(
      hint: "Спортивный объект",
      value: _sportObjectId,
      onChanged: _onSportObjectChanged,
      data: list,
      builder: (sportObject) => Text(sportObject.name),
      getKey: (sportObject) => sportObject.id,
    );
  }

  void _onSportObjectChanged(int sportObjectId) {
    setState(() {
      _sportObjectId = sportObjectId;
    });
  }

  Widget _buildDateTimePicker() {
    return TextDateTimePicker(
      _onTimeChanged,
      label: "Дата и время начала",
      initialDate: _dateTime,
    );
  }

  _onTimeChanged(DateTime time) {
    setState(() {
      _dateTime = time;
    });
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      onPressed: _formFinished ? _onSubmitPressed : null,
      child: Text("Добавить"),
      disabledTextColor: Colors.black,
    );
  }

  bool get _formFinished {
    return _trialId != null && _sportObjectId != null;
  }

  void _onSubmitPressed() {
    TrialRepo.I
        .addToEvent(
      widget.eventId,
      EventTrial(
        id: _trialId,
        sportObjectId: _sportObjectId,
        startDateTime: _dateTime,
      ),
    )
        .then((_) {
      widget.onUpdate();
      Navigator.of(context).pop();
    }).catchError((error) {
      showDialog(
        context: context,
        child: ErrorDialog.fromError(error),
      );
    });
  }
}
