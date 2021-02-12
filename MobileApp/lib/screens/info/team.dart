import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_button.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';
import 'package:gtoserviceapp/components/widgets/expanded_horizontally.dart';
import 'package:gtoserviceapp/components/widgets/future_widget_builder.dart';
import 'package:gtoserviceapp/components/widgets/info/team_info.dart';
import 'package:gtoserviceapp/models/role.dart';
import 'package:gtoserviceapp/screens/info/team_leads.dart';
import 'package:gtoserviceapp/screens/info/team_participants.dart';
import 'package:gtoserviceapp/services/repo/team.dart';
import 'package:gtoserviceapp/services/storage/storage.dart';

import '../profile/common/add_edit_team.dart';

class TeamScreen extends StatefulWidget {
  final int eventId;
  final int teamId;
  final void Function() onUpdate;
  final bool editable;
  final bool resultsEditable;
  final bool canModerate;

  TeamScreen({
    @required this.eventId,
    @required this.teamId,
    @required this.onUpdate,
    bool editable,
    bool resultsEditable,
    bool canModerate,
  })  : editable = editable ?? true,
        resultsEditable = resultsEditable ?? true,
        canModerate = canModerate ?? true;

  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  @override
  Widget build(BuildContext context) {
    bool canEdit = widget.editable &&
        (Storage.I.role == Role.LocalAdmin ||
            Storage.I.role == Role.Secretary ||
            Storage.I.role == Role.TeamLead);

    return Scaffold(
      appBar: AppBar(
        title: Text("Команда"),
        actions: canEdit ? _buildActions() : null,
      ),
      body: _buildFutureBody(),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.edit),
        onPressed: _onEditPressed,
      )
    ];
  }

  Widget _buildFutureBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ExpandedHorizontally(
          child: CardPadding(
            child: _buildFutureTeamInfo(),
          ),
        ),
        _buildTeamLeadsButton(),
        _buildParticipantsButton(),
      ],
    );
  }

  FutureWidgetBuilder<Team> _buildFutureTeamInfo() {
    return FutureWidgetBuilder(
      TeamRepo.I.get(widget.teamId),
      _buildTeamInfo,
    );
  }

  Widget _buildTeamInfo(context, Team team) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TeamInfo(team: team),
      ],
    );
  }

  Widget _buildTeamLeadsButton() {
    return CardButton(
      text: "Тренеры",
      icon: Icons.person,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return TeamLeadsScreen(
            teamId: widget.teamId,
            editable: widget.editable,
          );
        }));
      },
    );
  }

  _buildParticipantsButton() {
    return CardButton(
      text: "Участники",
      icon: Icons.person,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return TeamParticipantsScreen(
            eventId: widget.eventId,
            teamId: widget.teamId,
            onUpdate: _onUpdate,
            editable: widget.editable,
            resultsEditable: widget.resultsEditable,
            canModerate: widget.canModerate,
          );
        }));
      },
    );
  }

  void _onUpdate() {
    widget.onUpdate();
    setState(() {});
  }

  void _onEditPressed() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return AddEditTeamScreen(
        teamId: widget.teamId,
        onUpdate: _onUpdate,
      );
    }));
  }
}
