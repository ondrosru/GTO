import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/text/caption.dart';
import 'package:gtoserviceapp/components/widgets/text/headline.dart';
import 'package:gtoserviceapp/models/role.dart';
import 'package:gtoserviceapp/screens/info/trial_results.dart';
import 'package:gtoserviceapp/services/repo/referee.dart';
import 'package:gtoserviceapp/services/repo/trial.dart';
import 'package:gtoserviceapp/services/storage/storage.dart';
import 'package:gtoserviceapp/services/utils/utils.dart';

import '../profile/common/add_event_trial.dart';
import 'catalog.dart';

class EventTrialsScreen extends StatefulWidget {
  final int orgId;
  final int eventId;
  final bool editable;
  final bool resultsEditable;

  EventTrialsScreen(
      {@required this.orgId,
      @required this.eventId,
      bool editable,
      bool resultsEditable})
      : editable = editable ?? true,
        resultsEditable = resultsEditable ?? true;

  @override
  _EventTrialsScreenState createState() => _EventTrialsScreenState();
}

class _EventTrialsScreenState extends State<EventTrialsScreen> {
  @override
  Widget build(BuildContext context) {
    bool canEdit = widget.editable &&
        (Storage.I.role == Role.LocalAdmin || Storage.I.role == Role.Secretary);

    return CatalogScreen<EventTrial>(
      title: "Виды спорта",
      getData: () => TrialRepo.I.getFromEvent(widget.eventId),
      buildInfo: _buildInfo,
      onFabPressed: canEdit ? _onFabPressed : null,
      onDeletePressed: canEdit ? _onDeletePressed : null,
      onTapped: _onTapped,
    );
  }

  Widget _buildInfo(EventTrial trial) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        HeadlineText(trial.name),
        Row(
          children: <Widget>[
            CaptionText(Utils.formatDateTime(trial.startDateTime)),
            SizedBox(width: 16),
            CaptionText(trial.sportObjectName),
//            _buildSportObjectInfo(trial.sportObjectId),
          ],
        ),
        _buildRefereesInfo(trial.referees),
      ],
    );
  }

  _onFabPressed(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return AddEventTrialScreen(
        orgId: widget.orgId,
        eventId: widget.eventId,
        onUpdate: _onUpdate,
      );
    }));
  }

  Future<void> _onDeletePressed(EventTrial eventTrial) {
    return TrialRepo.I.deleteFromEvent(eventTrial.trialInEventId);
  }

  _buildRefereesInfo(List<Referee> referees) {
    if (referees.isEmpty) {
      return CaptionText("Судьи не назначены");
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CaptionText("Судьи: "),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              referees.map((referee) => CaptionText(referee.name)).toList(),
        ),
      ],
    );
  }

  void _onUpdate() {
    setState(() {});
  }

  void _onTapped(context, EventTrial eventTrial) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return TrialResultsScreen(
        trialInEventId: eventTrial.trialInEventId,
        editable: widget.resultsEditable,
      );
    }));
  }
}
