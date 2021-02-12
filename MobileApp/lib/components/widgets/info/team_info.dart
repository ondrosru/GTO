import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/text/caption.dart';
import 'package:gtoserviceapp/components/widgets/text/headline.dart';
import 'package:gtoserviceapp/services/repo/team.dart';

class TeamInfo extends StatelessWidget {
  final Team team;

  TeamInfo({@required this.team});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        HeadlineText(team.name),
        CaptionText(
            "Количество участников: " + team.participantsCount.toString()),
      ],
    );
  }
}
