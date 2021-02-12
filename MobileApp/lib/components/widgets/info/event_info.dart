import 'package:flutter/material.dart';
import 'package:gtoserviceapp/services/repo/event.dart';

class EventInfo extends StatelessWidget {
  final Event event;

  EventInfo({@required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(event.name),
        Text(
          event.description,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}
