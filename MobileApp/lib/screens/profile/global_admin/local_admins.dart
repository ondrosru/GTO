import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/text/caption.dart';
import 'package:gtoserviceapp/screens/info/catalog.dart';
import 'package:gtoserviceapp/screens/profile/common/invite_user.dart';
import 'package:gtoserviceapp/services/repo/local_admin.dart';

class LocalAdminsScreen extends StatefulWidget {
  final int orgId;

  LocalAdminsScreen({@required this.orgId});

  @override
  _LocalAdminsScreenState createState() => _LocalAdminsScreenState();
}

class _LocalAdminsScreenState extends State<LocalAdminsScreen> {
  @override
  Widget build(BuildContext context) {
    return CatalogScreen<LocalAdmin>(
      title: "Администраторы",
      getData: () => LocalAdminRepo.I.getAll(widget.orgId),
      buildInfo: _buildLocalAdmin,
      onDeletePressed: _onDeletePressed,
      onFabPressed: _onAddPressed,
    );
  }

  Widget _buildLocalAdmin(LocalAdmin localAdmin) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(localAdmin.name),
        CaptionText(localAdmin.email),
      ],
    );
  }

  Future<void> _onDeletePressed(LocalAdmin localAdmin) {
    return LocalAdminRepo.I.delete(widget.orgId, localAdmin.id);
  }

  _onAddPressed(context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return InviteUserScreen(
        title: "Приглашение администратора",
        addUser: (String email) {
          return LocalAdminRepo.I.add(widget.orgId, email);
        },
        onUpdate: _onUpdate,
      );
    }));
  }

  void _onUpdate() {
    setState(() {});
  }
}
