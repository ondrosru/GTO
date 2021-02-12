import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/info/event_info.dart';
import 'package:gtoserviceapp/screens/info/catalog.dart';
import 'package:gtoserviceapp/screens/info/event.dart';
import 'package:gtoserviceapp/services/repo/event.dart';

class SecretaryEventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CatalogScreen(
      getData: () => EventRepo.I.getAllForSecretary(),
      title: "Мои мероприятия",
      buildInfo: (Event event) => EventInfo(event: event),
      onTapped: _onTapped,
    );
  }

  void _onTapped(context, Event event) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return EventScreen(
        orgId: event.orgId,
        eventId: event.id,
      );
    }));
  }
}
