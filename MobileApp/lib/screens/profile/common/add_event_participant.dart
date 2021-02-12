import 'package:flutter/material.dart';
import 'package:gtoserviceapp/screens/profile/common/invite_user.dart';
import 'package:gtoserviceapp/services/repo/participant.dart';

class AddParticipantScreen extends StatelessWidget {
  final int eventId;
  final void Function() onUpdate;

  AddParticipantScreen({
    @required this.eventId,
    @required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return InviteUserScreen(
      title: "Добавление участника (личный зачет)",
      addUser: _addUser,
      onUpdate: onUpdate,
    );
  }

  Future _addUser(String email) {
    return ParticipantRepo.I.addToEvent(eventId, email);
  }
}
