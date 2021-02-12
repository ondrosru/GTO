import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';
import 'package:gtoserviceapp/components/widgets/dialogs/error_dialog.dart';
import 'package:gtoserviceapp/components/widgets/future_widget_builder.dart';
import 'package:gtoserviceapp/components/widgets/info/referee_info.dart';
import 'package:gtoserviceapp/components/widgets/shrunk_vertically.dart';
import 'package:gtoserviceapp/services/repo/referee.dart';
import 'package:gtoserviceapp/services/repo/trial.dart';

class AddTrialRefereeScreen extends StatefulWidget {
  final int orgId;
  final int eventId;

  AddTrialRefereeScreen({@required this.orgId, @required this.eventId});

  @override
  _AddTrialRefereeScreenState createState() => _AddTrialRefereeScreenState();
}

class _AddTrialRefereeScreenState extends State<AddTrialRefereeScreen> {
  int _trialId;
  int _refereeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Добавление судьи")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ShrunkVertically(
      child: CardPadding(
        child: Column(
          children: <Widget>[
            _buildFutureRefereeSelector(),
            SizedBox(height: 16),
            _buildFutureTrialSelector(),
            SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFutureRefereeSelector() {
    return FutureWidgetBuilder(
      RefereeRepo.I.getAll(widget.orgId),
      _buildRefereeSelector,
    );
  }

  Widget _buildRefereeSelector(context, List<Referee> refereeList) {
    return DropdownButton(
      isExpanded: true,
      itemHeight: null,
      hint: Text("Выберите судью"),
      items: _buildRefereeSelectorItems(refereeList),
      onChanged: _onRefereeChanged,
      value: _refereeId,
    );
  }

  List<DropdownMenuItem<int>> _buildRefereeSelectorItems(List<Referee> list) {
    return list.map((Referee referee) {
      return DropdownMenuItem<int>(
        child: RefereeInfo(referee),
        value: referee.id,
      );
    }).toList();
  }

  void _onRefereeChanged(int id) {
    setState(() {
      _refereeId = id;
    });
  }

  Widget _buildFutureTrialSelector() {
    return FutureWidgetBuilder(
      TrialRepo.I.getFromEvent(widget.eventId),
      _buildTrialSelector,
    );
  }

  Widget _buildTrialSelector(context, List<EventTrial> trialList) {
    return DropdownButton(
      isExpanded: true,
      itemHeight: null,
      hint: Text("Выберите испытание"),
      items: _buildTrialSelectorItems(trialList),
      onChanged: _onTrialChanged,
      value: _trialId,
    );
  }

  List<DropdownMenuItem<int>> _buildTrialSelectorItems(List<EventTrial> list) {
    return list.map((EventTrial trial) {
      return DropdownMenuItem<int>(
        child: Text(trial.name),
        value: trial.trialInEventId,
      );
    }).toList();
  }

  void _onTrialChanged(int id) {
    setState(() {
      _trialId = id;
    });
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      onPressed: _onSubmitPressed,
      child: Text("Добавить"),
    );
  }

  void _onSubmitPressed() async {
    if (_refereeId == null || _trialId == null) {
      return;
    }

    var future = RefereeRepo.I.addToTrial(_trialId, _refereeId);
    ErrorDialog.showOnFutureError(context, future);
    future.then((_) => Navigator.of(context).pop());
  }
}
