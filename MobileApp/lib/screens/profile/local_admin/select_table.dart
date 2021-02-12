import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';
import 'package:gtoserviceapp/components/widgets/dialogs/error_dialog.dart';
import 'package:gtoserviceapp/components/widgets/expanded_horizontally.dart';
import 'package:gtoserviceapp/components/widgets/forms/selector.dart';
import 'package:gtoserviceapp/components/widgets/future_widget_builder.dart';
import 'package:gtoserviceapp/components/widgets/shrunk_vertically.dart';
import 'package:gtoserviceapp/services/repo/table.dart';

class SelectTableScreen extends StatefulWidget {
  final int eventId;
  final Function() onUpdate;
  final tables = TableRepo.I.getAll();

  SelectTableScreen({
    @required this.eventId,
    @required this.onUpdate,
  });

  @override
  _SelectTableScreenState createState() => _SelectTableScreenState();
}

class _SelectTableScreenState extends State<SelectTableScreen> {
  int _tableId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Выбор таблицы перевода")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ShrunkVertically(
      child: ExpandedHorizontally(
        child: CardPadding(
          child: Column(
            children: <Widget>[
              _buildSelector(),
              SizedBox(height: 16),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  FutureWidgetBuilder<List<ConversionTable>> _buildSelector() {
    return FutureWidgetBuilder(
      widget.tables,
      (context, List<ConversionTable> tables) {
        return Selector<ConversionTable, int>(
          hint: "Выберите таблицу перевода",
          data: tables,
          value: _tableId,
          onChanged: _onChanged,
          getKey: (ConversionTable table) => table.id,
          builder: (ConversionTable table) {
            return Text(table.name);
          },
        );
      },
    );
  }

  _onChanged(int tableId) {
    setState(() {
      _tableId = tableId;
    });
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      child: Text("Выбрать"),
      onPressed: _validate() ? _onPressed : null,
    );
  }

  bool _validate() {
    return _tableId != null;
  }

  void _onPressed() async {
    TableRepo.I.setForEvent(widget.eventId, _tableId).then((_) {
      widget.onUpdate();
      Navigator.of(context).pop();
    }).catchError((error) {
      showDialog(
        context: context,
        child: ErrorDialog.fromError(error),
      );
    });
  }
}
