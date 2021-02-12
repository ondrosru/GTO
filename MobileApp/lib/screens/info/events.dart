import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/info/event_info.dart';
import 'package:gtoserviceapp/models/role.dart';
import 'package:gtoserviceapp/screens/profile/common/add_edit_event.dart';
import 'package:gtoserviceapp/services/repo/event.dart';
import 'package:gtoserviceapp/services/storage/storage.dart';

import 'catalog.dart';
import 'event.dart';

class EventsScreen extends StatefulWidget {
  final int orgId;
  final bool editable;
  final bool canModerate;

  EventsScreen({@required this.orgId, bool editable, bool canModerate})
      : editable = editable ?? true,
        canModerate = canModerate ?? true;

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    bool canEdit = widget.editable && (Storage.I.role == Role.LocalAdmin);

    return CatalogScreen<Event>(
      getData: () => EventRepo.I.getAllFromOrg(widget.orgId),
      title: "Мероприятия",
      buildInfo: (Event event) => EventInfo(event: event),
      onFabPressed: canEdit ? _onFabPressed : null,
      onTapped: _onEventTap,
      onDeletePressed: canEdit ? _onDeletePressed : null,
    );
  }

  void _onEventTap(context, Event event) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return EventScreen(
        eventId: event.id,
        orgId: widget.orgId,
        editable: widget.editable,
        canModerate: widget.canModerate,
      );
    }));
  }

  _onFabPressed(context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return AddEditEventScreen(orgId: widget.orgId, onUpdate: _onUpdate);
    }));
  }

  Future<void> _onDeletePressed(Event event) {
    return EventRepo.I.delete(widget.orgId, event.id);
  }

  void _onUpdate() {
    setState(() {});
  }
}
