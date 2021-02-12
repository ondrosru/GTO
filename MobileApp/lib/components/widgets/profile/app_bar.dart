import 'package:flutter/material.dart';
import 'package:gtoserviceapp/screens/login/login.dart';
import 'package:gtoserviceapp/services/auth/auth.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar _appBar = AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Профиль"),
      automaticallyImplyLeading: false,
      actions: <Widget>[_buildLogoutButton(context)],
    );
  }

  Widget _buildLogoutButton(context) {
    return IconButton(
      icon: Icon(Icons.arrow_forward),
      onPressed: () => _onLogoutButtonPressed(context),
    );
  }

  _onLogoutButtonPressed(context) {
    Auth.I.logout();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => LoginScreen(),
    ));
  }

  @override
  Size get preferredSize => new Size.fromHeight(_appBar.preferredSize.height);
}
