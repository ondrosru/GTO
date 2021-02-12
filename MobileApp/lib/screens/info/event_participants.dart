import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/dialogs/error_dialog.dart';
import 'package:gtoserviceapp/components/widgets/info/participant_info.dart';
import 'package:gtoserviceapp/models/role.dart';
import 'package:gtoserviceapp/screens/info/catalog.dart';
import 'package:gtoserviceapp/screens/info/participant_results.dart';
import 'package:gtoserviceapp/screens/profile/photo/camera.dart';
import 'package:gtoserviceapp/screens/profile/photo/photo_processing.dart';
import 'package:gtoserviceapp/services/repo/participant.dart';
import 'package:gtoserviceapp/services/repo/photo.dart';
import 'package:gtoserviceapp/services/storage/storage.dart';

import '../profile/common/add_event_participant.dart';

class EventParticipantsScreen extends StatefulWidget {
  final int eventId;
  final bool editable;
  final bool resultsEditable;
  final bool canModerate;

  EventParticipantsScreen(
      {@required this.eventId,
      bool editable,
      bool resultsEditable,
      bool canModerate})
      : editable = editable ?? true,
        resultsEditable = resultsEditable ?? true,
        canModerate = canModerate ?? true;

  @override
  _EventParticipantsScreenState createState() =>
      _EventParticipantsScreenState();
}

class _EventParticipantsScreenState extends State<EventParticipantsScreen> {
  @override
  Widget build(BuildContext context) {
    bool canEdit = widget.editable &&
        (Storage.I.role == Role.LocalAdmin || Storage.I.role == Role.Secretary);
    bool canModerate = widget.canModerate &&
        (Storage.I.role == Role.LocalAdmin || Storage.I.role == Role.Secretary);

    return CatalogScreen<Participant>(
      getData: () => ParticipantRepo.I.getAllFromEvent(widget.eventId),
      title: "Участники мероприятия",
      buildInfo: (participant) => ParticipantInfo(
        participant: participant,
        onUpdate: _onUpdate,
        editable: widget.editable,
      ),
      onDeletePressed: canEdit ? _onDeletePressed : null,
      onFabPressed: canEdit ? _onFabPressed : null,
      onTapped: _onTapped,
      actions: canModerate ? _buildActions() : null,
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.image),
        onPressed: _onSearchImagePressed,
      ),
      IconButton(
        icon: Icon(Icons.photo_camera),
        onPressed: _onSearchCameraPressed,
      ),
    ];
  }

  void _onFabPressed(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return AddParticipantScreen(eventId: widget.eventId, onUpdate: _onUpdate);
    }));
  }

  Future<void> _onDeletePressed(Participant participant) {
    return ParticipantRepo.I.delete(participant.eventParticipantId).then((_) {
      _onUpdate();
    });
  }

  void _onUpdate() {
    setState(() {});
  }

  void _onTapped(context, Participant participant) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return ParticipantResultsScreen(
        eventId: widget.eventId,
        participant: participant,
        editable: widget.resultsEditable,
        canModerate: widget.canModerate,
      );
    }));
  }

  void _onSearchCameraPressed() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return CameraScreen(onPhotoTaken: _findFace);
    }));
  }

  void _onSearchImagePressed() async {
    File photo = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    await _findFace(photo.readAsBytesSync());
  }

  Future<void> _findFace(Uint8List photo) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return PhotoProcessingScreen();
    }));

    var futureUserId = PhotoRepo.I.findFace(photo);

    List<Participant> participant;
    try {
      var userId = await futureUserId;
      participant = (await ParticipantRepo.I.getAllFromEvent(widget.eventId))
          .where((participant) => participant.userId == userId)
          .toList();
    } catch (e) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        child: ErrorDialog.fromError(e),
      );
      return;
    }

    Navigator.of(context).pop();
    if (participant.isEmpty) {
      showDialog(
        context: context,
        child: ErrorDialog.fromText(
          "Человек не является участником мероприятия",
        ),
      );
      return;
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return ParticipantResultsScreen(
        participant: participant.first,
        eventId: widget.eventId,
        canModerate: widget.canModerate,
      );
    }));
  }

  void findFace(Uint8List photo) {}
}
