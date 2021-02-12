import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/text/caption.dart';
import 'package:gtoserviceapp/services/repo/org.dart';

class OrgInfo extends StatelessWidget {
  final Org org;

  OrgInfo({@required this.org});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(org.name),
        CaptionText(org.address),
        CaptionText("Активных мероприятий: ${org.countOfAllEvents}"),
      ],
    );
  }
}
