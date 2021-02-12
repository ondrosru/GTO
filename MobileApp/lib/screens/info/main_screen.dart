import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_list_view.dart';
import 'package:gtoserviceapp/components/widgets/future_widget_builder.dart';
import 'package:gtoserviceapp/components/widgets/info/org_info.dart';
import 'package:gtoserviceapp/components/widgets/navigation/nav_bar.dart';
import 'package:gtoserviceapp/components/widgets/navigation/tabs.dart';
import 'package:gtoserviceapp/services/repo/org.dart';

import 'org.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GTO Service"),
        automaticallyImplyLeading: false,
      ),
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(Tabs.Main),
    );
  }

  Widget _buildBody() {
    return FutureWidgetBuilder(OrgRepo.I.getAll(), _buildList);
  }

  Widget _buildList(context, List<Org> orgs) {
    return CardListView<Org>(
      orgs,
      (context, Org org) => OrgInfo(org: org),
      onTap: _onTap,
    );
  }

  void _onTap(context, Org org) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return OrgScreen(
        orgId: org.id,
        editable: false,
        canModerate: false,
      );
    }));
  }
}
