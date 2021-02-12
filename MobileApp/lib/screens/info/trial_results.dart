import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';
import 'package:gtoserviceapp/components/widgets/dialogs/error_dialog.dart';
import 'package:gtoserviceapp/components/widgets/future_widget_builder.dart';
import 'package:gtoserviceapp/components/widgets/text/caption.dart';
import 'package:gtoserviceapp/components/widgets/text/headline.dart';
import 'package:gtoserviceapp/models/badge.dart';
import 'package:gtoserviceapp/models/role.dart';
import 'package:gtoserviceapp/services/repo/result.dart';
import 'package:gtoserviceapp/services/storage/storage.dart';
import 'package:gtoserviceapp/services/utils/utils.dart';

class TrialResultsScreen extends StatefulWidget {
  final int trialInEventId;
  final bool editable;

  TrialResultsScreen({@required this.trialInEventId, bool editable})
      : editable = editable ?? true;

  @override
  _TrialResultsScreenState createState() => _TrialResultsScreenState();
}

class _TrialResultsScreenState extends State<TrialResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Результаты")),
      body: _buildFutureBody(),
    );
  }

  Widget _buildFutureBody() {
    return FutureWidgetBuilder(
      ResultRepo.I.getTrialResults(widget.trialInEventId),
      _buildBody,
    );
  }

  Widget _buildBody(context, Results results) {
    return ListView(
      children: <Widget>[
        _buildHeader(results),
        ..._buildResults(results),
      ],
    );
  }

  Widget _buildHeader(Results results) {
    return CardPadding(
      child: HeadlineText(results.trialName),
    );
  }

  List<Widget> _buildResults(Results results) {
    return results.participants.map(_buildUserResult).toList();
  }

  Widget _buildUserResult(ParticipantResult participant) {
    return CardPadding(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          participant.badge.toWidget(),
          (participant.badge != Badge.Null) ? SizedBox(width: 8) : Container(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(participant.userName +
                  " (#" +
                  participant.userId.toString() +
                  ")"),
              CaptionText(Utils.formatDate(participant.dateOfBirth)),
              participant.teamName != null
                  ? CaptionText(participant.teamName)
                  : Container(),
              _buildResult(participant),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResult(ParticipantResult p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildFirstResult(p),
        p.secondResult != null ? _buildSecondResult(p) : Container(),
      ],
    );
  }

  Widget _buildFirstResult(ParticipantResult p) {
    bool canEdit = widget.editable &&
        (Storage.I.role == Role.LocalAdmin || Storage.I.role == Role.Secretary);
    if (!canEdit && p.firstResult == null) {
      return Container();
    }

    return Row(
      children: <Widget>[
        CaptionText("Результат: "),
        canEdit ? _buildFirstResultField(p) : Text(p.firstResult.toString())
      ],
    );
  }

  _buildFirstResultField(ParticipantResult p) {
    return SizedBox(
      width: 96,
      child: TextFormField(
        initialValue: p.firstResult,
        textAlign: TextAlign.center,
        onFieldSubmitted: (value) => _onFirstResultSubmitted(
          value,
          p.resultOfTrialInEventId,
        ),
      ),
    );
  }

  void _onFirstResultSubmitted(String value, int resultId) {
    ResultRepo.I.changeTrialResult(resultId, value).then((_) {
      setState(() {});
    }).catchError((error) {
      showDialog(context: context, child: ErrorDialog.fromError(error));
    });
  }

  Widget _buildSecondResult(ParticipantResult p) {
    return Row(
      children: <Widget>[
        CaptionText("Приведенный: "),
        Text(p.secondResult.toString())
      ],
    );
  }
}
