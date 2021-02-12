import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_button.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';
import 'package:gtoserviceapp/components/widgets/expanded_horizontally.dart';
import 'package:gtoserviceapp/components/widgets/field.dart';
import 'package:gtoserviceapp/components/widgets/future_widget_builder.dart';
import 'package:gtoserviceapp/components/widgets/text/headline.dart';
import 'package:gtoserviceapp/models/role.dart';
import 'package:gtoserviceapp/screens/info/events.dart';
import 'package:gtoserviceapp/screens/profile/global_admin/add_edit_org.dart';
import 'package:gtoserviceapp/screens/profile/global_admin/local_admins.dart';
import 'package:gtoserviceapp/services/repo/org.dart';
import 'package:gtoserviceapp/services/storage/storage.dart';

class OrgScreen extends StatefulWidget {
  final int orgId;
  final bool editable;
  final bool canModerate;

  OrgScreen({@required this.orgId, bool editable, bool canModerate})
      : editable = editable ?? true,
        canModerate = canModerate ?? true;

  @override
  _OrgScreenState createState() => _OrgScreenState();
}

class _OrgScreenState extends State<OrgScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    bool canEdit = widget.editable && Storage.I.role == Role.GlobalAdmin;

    return AppBar(
      title: Text("Организация"),
      actions: canEdit
          ? <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _onEditPressed(context),
              ),
            ]
          : null,
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildFutureOrgCard(),
        ..._buildButtons(),
        SizedBox(height: 48),
      ],
    );
  }

  Widget _buildFutureOrgCard() {
    return FutureWidgetBuilder(OrgRepo.I.get(widget.orgId), _buildOrgCard);
  }

  Widget _buildOrgCard(context, Org org) {
    return CardPadding(
      child: ExpandedHorizontally(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildName(org, context),
            _buildTotalEventsCount(org),
            _buildActiveEventsCount(org),
            Field("Aдрес", child: Text(org.address)),
            Field("Ответственный", child: Text(org.leader)),
            Field("Номер телефона", child: Text(org.phoneNumber)),
            Field("ОГРН", child: Text(org.oQRN)),
            Field("Лицевой счёт", child: Text(org.paymentAccount)),
            Field("Филиал", child: Text(org.branch)),
            Field("БИК", child: Text(org.bik)),
            Field("Расчётный счёт", child: Text(org.correspondentAccount)),
          ],
        ),
      ),
    );
  }

  Widget _buildName(Org org, context) {
    return HeadlineText(org.name ?? "");
  }

  _onEditPressed(context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return AddEditOrgScreen(orgId: widget.orgId, onUpdate: _onUpdate);
    }));
  }

  _buildTotalEventsCount(Org org) {
    return Text("Всего мероприятий: ${org.countOfAllEvents}");
  }

  _buildActiveEventsCount(Org org) {
    return Text("Активных мероприятий: ${org.countOfActiveEvents}");
  }

  void _onUpdate() {
    setState(() {});
  }

  List<Widget> _buildButtons() {
    var buttons = <Widget>[];

    if (widget.editable && Storage.I.role == Role.GlobalAdmin) {
      buttons.add(_buildLocalAdminsButton());
    }

    buttons.add(_buildEventsButton());

    return buttons;
  }

  Widget _buildLocalAdminsButton() {
    return CardButton(
      text: "Администраторы",
      icon: Icons.person,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return LocalAdminsScreen(orgId: widget.orgId);
        }));
      },
    );
  }

  Widget _buildEventsButton() {
    return CardButton(
      text: "Мероприятия",
      icon: Icons.event,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return EventsScreen(
            orgId: widget.orgId,
            editable: widget.editable,
            canModerate: widget.canModerate,
          );
        }));
      },
    );
  }
}
