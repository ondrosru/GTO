import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/text/caption.dart';
import 'package:gtoserviceapp/components/widgets/text/headline.dart';
import 'package:gtoserviceapp/services/repo/referee.dart';
import 'package:gtoserviceapp/services/utils/utils.dart';

class RefereeInfo extends StatelessWidget {
  final Referee referee;

  RefereeInfo(this.referee);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        HeadlineText(referee.name),
        CaptionText(referee.email),
        CaptionText(Utils.formatDate(referee.dateOfBirth)),
      ],
    );
  }
}
