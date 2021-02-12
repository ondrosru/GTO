import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';
import 'package:gtoserviceapp/components/widgets/dialogs/error_dialog.dart';
import 'package:gtoserviceapp/components/widgets/future_widget_builder.dart';
import 'package:gtoserviceapp/components/widgets/info/secretary_info.dart';
import 'package:gtoserviceapp/components/widgets/shrunk_vertically.dart';
import 'package:gtoserviceapp/services/repo/secretary.dart';

class AddEventSecretaryScreen extends StatefulWidget {
  final int orgId;
  final int eventId;

  AddEventSecretaryScreen({@required this.orgId, @required this.eventId});

  @override
  _AddEventSecretaryScreenState createState() =>
      _AddEventSecretaryScreenState();
}

class _AddEventSecretaryScreenState extends State<AddEventSecretaryScreen> {
  int _selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Добавление секретаря")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ShrunkVertically(
      child: CardPadding(
        child: Column(
          children: <Widget>[
            _buildFutureSelector(),
            SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFutureSelector() {
    return FutureWidgetBuilder(
      SecretaryRepo.I.getFromOrg(widget.orgId),
      (_, List<Secretary> secretaryList) => _buildSelector(secretaryList),
    );
  }

  Widget _buildSelector(List<Secretary> secretaryList) {
    return DropdownButton(
      isExpanded: true,
      itemHeight: null,
      hint: Text("Выберите секретаря"),
      items: _buildSelectorItems(secretaryList),
      onChanged: _onChanged,
      value: _selectedId,
    );
  }

  List<DropdownMenuItem<int>> _buildSelectorItems(List<Secretary> list) {
    return list.map((Secretary secretary) {
      return DropdownMenuItem<int>(
        child: SecretaryInfo(secretary),
        value: secretary.secretaryOnOrganizationId,
      );
    }).toList();
  }

  void _onChanged(int id) {
    setState(() {
      _selectedId = id;
    });
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      onPressed: _onSubmitPressed,
      child: Text("Добавить"),
    );
  }

  void _onSubmitPressed() async {
    if (_selectedId == null) {
      return;
    }

    var future =
        SecretaryRepo.I.addToEvent(widget.orgId, widget.eventId, _selectedId);
    ErrorDialog.showOnFutureError(context, future);
    await future;
    Navigator.of(context).pop();
  }
}
