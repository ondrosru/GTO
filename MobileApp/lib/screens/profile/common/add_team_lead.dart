import 'package:flutter/material.dart';
import 'package:gtoserviceapp/screens/profile/common/invite_user.dart';
import 'package:gtoserviceapp/services/repo/team_lead.dart';

class AddTeamLeadScreen extends StatelessWidget {
  final int teamId;
  final void Function() onUpdate;

  AddTeamLeadScreen({
    @required this.teamId,
    @required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return InviteUserScreen(
      title: "Добавление тренера",
      addUser: _addTeamLead,
      onUpdate: onUpdate,
    );
  }

  Future _addTeamLead(String email) {
    return TeamLeadRepo.I.add(teamId, email);
  }
}
