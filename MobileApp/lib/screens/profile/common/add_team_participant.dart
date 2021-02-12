import 'package:flutter/material.dart';
import 'package:gtoserviceapp/screens/profile/common/invite_user.dart';
import 'package:gtoserviceapp/services/repo/participant.dart';

class AddTeamParticipantScreen extends StatelessWidget {
  final int teamId;
  final void Function() onUpdate;

  AddTeamParticipantScreen({
    @required this.teamId,
    @required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return InviteUserScreen(
      title: "Добавление участника",
      addUser: _addParticipant,
      onUpdate: onUpdate,
    );
  }

  Future _addParticipant(String email) {
    return ParticipantRepo.I.addToTeam(teamId, email);
  }
}
