import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/text/caption.dart';
import 'package:gtoserviceapp/components/widgets/text/headline.dart';
import 'package:gtoserviceapp/services/repo/secretary.dart';
import 'package:gtoserviceapp/services/utils/utils.dart';

class SecretaryInfo extends StatelessWidget {
  final Secretary secretary;

  SecretaryInfo(this.secretary);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        HeadlineText(secretary.name),
        CaptionText(secretary.email),
        CaptionText(Utils.formatDate(secretary.dateOfBirth)),
      ],
    );
  }
}
