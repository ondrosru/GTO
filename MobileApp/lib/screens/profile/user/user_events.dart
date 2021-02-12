import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/info/event_info.dart';
import 'package:gtoserviceapp/screens/info/catalog.dart';
import 'package:gtoserviceapp/screens/info/event.dart';
import 'package:gtoserviceapp/services/repo/event.dart';

class UserEventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CatalogScreen(
      title: "Мои мероприятия",
      getData: () => EventRepo.I.getAllForUser(),
      buildInfo: (Event event) => EventInfo(event: event),
      onTapped: _onTapped,
    );
  }

  void _onTapped(context, Event event) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return EventScreen(
        eventId: event.id,
        orgId: event.orgId,
        editable: false,
      );
    }));
  }
}
