import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/info/secretary_info.dart';
import 'package:gtoserviceapp/screens/info/catalog.dart';
import 'package:gtoserviceapp/screens/profile/common/invite_user.dart';
import 'package:gtoserviceapp/services/repo/secretary.dart';
import 'package:gtoserviceapp/services/storage/storage.dart';

class SecretaryCatalogScreen extends StatefulWidget {
  @override
  _SecretaryCatalogScreenState createState() => _SecretaryCatalogScreenState();
}

class _SecretaryCatalogScreenState extends State<SecretaryCatalogScreen> {
  @override
  Widget build(BuildContext context) {
    return CatalogScreen<Secretary>(
      title: "Секретари",
      getData: _getList,
      buildInfo: (data) => SecretaryInfo(data),
      onDeletePressed: _onDeletePressed,
      onFabPressed: _onFabPressed,
    );
  }

  Future<List<Secretary>> _getList() {
    return SecretaryRepo.I.getFromOrg(Storage.I.orgId);
  }

  _onFabPressed(context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => InviteUserScreen(
        title: "Приглашение секретаря",
        addUser: (String email) {
          return SecretaryRepo.I.addToOrg(Storage.I.orgId, email);
        },
        onUpdate: _onUpdate,
      ),
    ));
  }

  Future<void> _onDeletePressed(Secretary secretary) {
    return SecretaryRepo.I.deleteFromOrg(
      Storage.I.orgId,
      secretary.secretaryOnOrganizationId,
    );
  }

  void _onUpdate() {
    setState(() {});
  }
}
