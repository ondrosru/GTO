import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_list_view.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';
import 'package:gtoserviceapp/components/widgets/future_widget_builder.dart';
import 'package:gtoserviceapp/models/gender.dart';
import 'package:gtoserviceapp/services/repo/calculator.dart';

class CalculatorResultScreen extends StatefulWidget {
  final int age;
  final Gender gender;

  CalculatorResultScreen({@required this.age, @required this.gender});

  @override
  _CalculatorResultScreenState createState() =>
      _CalculatorResultScreenState(gender, age);
}

class _CalculatorResultScreenState extends State<CalculatorResultScreen> {
  Future<Trials> _trials;
  Map<int, String> _primaryResults = {};

  _CalculatorResultScreenState(Gender gender, int age) {
    _trials = CalculatorRepo.I.fetchTrials(age, gender);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text("Калькулятор")),
        body: _buildBody(widget.age, widget.gender),
      ),
    );
  }

  Widget _buildBody(int age, Gender gender) {
    return FutureWidgetBuilder(
      _trials,
      (_, Trials trials) => _buildTrials(trials, age, gender),
    );
  }

  Widget _buildTrials(Trials trials, int age, Gender gender) {
    return ListView(
      children: <Widget>[
        _buildHeader(gender, age, trials),
        Divider(color: Colors.black),
        _buildTrialsList(trials),
      ],
    );
  }

  Widget _buildHeader(Gender gender, int age, Trials trials) {
    return CardPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Пол: ${gender.toStr()}"),
          SizedBox(height: 2),
          Text("Возраст: $age"),
          SizedBox(height: 2),
          Text("Возрастная ступень: ${trials.ageCategory}"),
        ],
      ),
    );
  }

  Widget _buildTrialsList(Trials trials) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index >= trials.groups.length) {
          return null;
        }
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: _buildGroup(trials.groups[index]),
        );
      },
      separatorBuilder: (_, __) => Divider(color: Colors.black),
      itemCount: trials.groups.length,
    );
  }

  Widget _buildGroup(Group group) {
    return CardListView<Trial>(group.trials, _buildTrial);
  }

  Widget _buildTrial(BuildContext context, Trial trial) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(trial.name),
        SizedBox.fromSize(size: Size.fromHeight(4)),
        _buildTrialResults(trial),
        SizedBox.fromSize(size: Size.fromHeight(4)),
        _buildPrimarySecondaryResults(trial, context),
      ],
    );
  }

  Widget _buildTrialResults(Trial trial) {
    return Row(
      children: <Widget>[
        _buildTrialResult(trial.resultForGold, Colors.yellow),
        _buildTrialResult(trial.resultForSilver, Colors.grey),
        _buildTrialResult(trial.resultForBronze, Colors.brown.shade300),
      ],
    );
  }

  Widget _buildTrialResult(String value, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: Row(
        children: <Widget>[
          Icon(Icons.brightness_1, color: color),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildPrimarySecondaryResults(Trial trial, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text("Первичный результат: "),
            _buildPrimaryResult(trial.id),
          ],
        ),
        SizedBox(
          height: 4,
        ),
        _buildFutureSecondaryResult(context, trial.id),
      ]..removeWhere((x) => x == null),
    );
  }

  Widget _buildPrimaryResult(trialId) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 96,
          height: 48,
          child: TextFormField(
            textAlign: TextAlign.center,
            initialValue: _primaryResults[trialId]?.toString(),
            onChanged: (value) => _onPrimaryResultChanged(trialId, value),
            onFieldSubmitted: (_) => _onPrimaryResultSubmitted(),
            onEditingComplete: _onPrimaryResultSubmitted,
          ),
        ),
      ],
    );
  }

  _onPrimaryResultChanged(int trialId, String value) {
    _primaryResults[trialId] = value;
  }

  _onPrimaryResultSubmitted() {
    setState(() {});
  }

  Widget _buildFutureSecondaryResult(BuildContext context, int trialId) {
    if (_primaryResults[trialId] == null ||
        _primaryResults[trialId].trim().isEmpty) {
      return null;
    }

    return FutureWidgetBuilder(
        CalculatorRepo.I
            .fetchSecondaryResult(trialId, _primaryResults[trialId]),
        (_, SecondaryResultResponse response) =>
            _buildSecondaryResult(response));
  }

  Row _buildSecondaryResult(SecondaryResultResponse response) {
    return Row(
      children: <Widget>[
        Text("Приведенный: "),
        Text(
          response.secondaryResult.toString(),
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
