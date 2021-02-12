import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';
import 'package:gtoserviceapp/components/widgets/expanded_horizontally.dart';
import 'package:gtoserviceapp/components/widgets/future_widget_builder.dart';
import 'package:gtoserviceapp/components/widgets/text/caption.dart';
import 'package:gtoserviceapp/components/widgets/text/headline.dart';
import 'package:gtoserviceapp/models/role.dart';
import 'package:gtoserviceapp/services/repo/user.dart';
import 'package:gtoserviceapp/services/storage/storage.dart';
import 'package:gtoserviceapp/services/utils/utils.dart';

class ProfileUserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CardPadding(
      child: ExpandedHorizontally(
        child: _buildFutureUserInfo(context),
      ),
    );
  }

  Widget _buildFutureUserInfo(context) {
    return FutureWidgetBuilder(UserRepo.I.getUserInfo(), _buildUserInfo);
  }

  Widget _buildUserInfo(context, GetUserInfoResponse response) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        HeadlineText(response.name),
        CaptionText(response.email),
        CaptionText(Utils.formatDate(response.dateOfBirth)),
        CaptionText(Storage.I.role.toText()),
      ],
    );
  }
}
