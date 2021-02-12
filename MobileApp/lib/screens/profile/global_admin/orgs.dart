import 'package:flutter/material.dart';
import 'package:gtoserviceapp/screens/info/catalog.dart';
import 'package:gtoserviceapp/screens/info/org.dart';
import 'package:gtoserviceapp/screens/profile/global_admin/add_edit_org.dart';
import 'package:gtoserviceapp/services/repo/org.dart';

class OrgsScreen extends StatefulWidget {
  @override
  _OrgsScreenState createState() => _OrgsScreenState();
}

class _OrgsScreenState extends State<OrgsScreen> {
  @override
  Widget build(BuildContext context) {
    return CatalogScreen<Org>(
      title: "Организации",
      getData: () => OrgRepo.I.getAll(),
      buildInfo: (org) => _buildOrg(context, org),
      onTapped: _onOrgTapped,
      onFabPressed: _onFabPressed,
      onDeletePressed: _onDeletePressed,
    );
  }

  Widget _buildOrg(BuildContext context, Org org) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(org.name),
        Text(
          org.address,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }

  _onFabPressed(context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return AddEditOrgScreen(onUpdate: _onUpdate);
    }));
  }

  _onOrgTapped(context, Org org) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => OrgScreen(
        orgId: org.id,
        canModerate: false,
      ),
    ));
  }

  Future<void> _onDeletePressed(Org org) {
    return OrgRepo.I.delete(org.id);
  }

  void _onUpdate() {
    setState(() {});
  }
}
