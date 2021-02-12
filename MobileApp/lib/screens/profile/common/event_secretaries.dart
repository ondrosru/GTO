import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/info/secretary_info.dart';
import 'package:gtoserviceapp/screens/info/catalog.dart';
import 'package:gtoserviceapp/services/repo/secretary.dart';

import 'add_event_secretary.dart';

class EventSecretaryCatalogScreen extends StatelessWidget {
  final int orgId;
  final int eventId;
  final bool editable;

  EventSecretaryCatalogScreen(
      {@required this.orgId, @required this.eventId, editable})
      : editable = editable ?? true;

  @override
  Widget build(BuildContext context) {
    return CatalogScreen<Secretary>(
      title: "Секретари мероприятия",
      getData: () => SecretaryRepo.I.getFromEvent(orgId, eventId),
      buildInfo: (Secretary secretary) => SecretaryInfo(secretary),
      onFabPressed: editable ? _onFabPressed : null,
      onDeletePressed: editable ? _onDeletePressed : null,
    );
  }

  void _onFabPressed(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddEventSecretaryScreen(orgId: orgId, eventId: eventId),
      ),
    );
  }

  Future<void> _onDeletePressed(Secretary secretary) {
    return SecretaryRepo.I.deleteFromEvent(
      orgId,
      eventId,
      secretary.secretaryId,
    );
  }
}
