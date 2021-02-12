import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';
import 'package:gtoserviceapp/components/widgets/dialogs/error_dialog.dart';
import 'package:gtoserviceapp/components/widgets/dialogs/yes_no_dialog.dart';
import 'package:gtoserviceapp/components/widgets/expanded_horizontally.dart';
import 'package:gtoserviceapp/components/widgets/future_widget_builder.dart';
import 'package:gtoserviceapp/components/widgets/shrunk_vertically.dart';
import 'package:gtoserviceapp/components/widgets/text/headline.dart';
import 'package:gtoserviceapp/models/event_state.dart';
import 'package:gtoserviceapp/services/repo/event.dart';
import 'package:gtoserviceapp/services/storage/storage.dart';

class ChangeEventStateScreen extends StatelessWidget {
  final int eventId;
  final void Function() onUpdate;

  ChangeEventStateScreen({
    @required this.eventId,
    @required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Изменение статуса мероприятия")),
      body: _buildBody(context),
    );
  }

  _buildBody(context) {
    return ShrunkVertically(
      child: ExpandedHorizontally(
        child: CardPadding(
          child: Column(
            children: <Widget>[
              _buildFutureText(),
              SizedBox(height: 16),
              _buildButton(context),
            ],
          ),
        ),
      ),
    );
  }

  RaisedButton _buildButton(context) {
    return RaisedButton(
      child: Text("Изменить статус"),
      onPressed: () {
        showDialog(
          context: context,
          child: _buildDialog(context),
        );
      },
    );
  }

  YesNoDialog _buildDialog(context) {
    return YesNoDialog("Изменить статус?", () {
      EventRepo.I.changeStatus(eventId).then((_) {
        onUpdate();
        Navigator.of(context).pop();
      }).catchError((error) {
        showDialog(
          context: context,
          child: ErrorDialog.fromError(error),
        );
      });
    });
  }

  FutureWidgetBuilder<Event> _buildFutureText() {
    return FutureWidgetBuilder(
      EventRepo.I.get(Storage.I.orgId, eventId),
      _buildText,
    );
  }

  Widget _buildText(context, Event event) {
    EventState state = event.state;
    return HeadlineText("${state.toText()} -> ${state.next().toText()}");
  }
}
