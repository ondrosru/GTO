import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_button.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';
import 'package:gtoserviceapp/components/widgets/dialogs/error_dialog.dart';
import 'package:gtoserviceapp/components/widgets/dialogs/ok_dialog.dart';
import 'package:gtoserviceapp/components/widgets/expanded_horizontally.dart';
import 'package:gtoserviceapp/components/widgets/field.dart';
import 'package:gtoserviceapp/components/widgets/future_widget_builder.dart';
import 'package:gtoserviceapp/components/widgets/text/date.dart';
import 'package:gtoserviceapp/components/widgets/text/headline.dart';
import 'package:gtoserviceapp/models/event_state.dart';
import 'package:gtoserviceapp/models/role.dart';
import 'package:gtoserviceapp/screens/info/teams.dart';
import 'package:gtoserviceapp/screens/login/login.dart';
import 'package:gtoserviceapp/screens/profile/common/add_edit_event.dart';
import 'package:gtoserviceapp/screens/profile/common/add_trial_referee.dart';
import 'package:gtoserviceapp/screens/profile/local_admin/change_event_state.dart';
import 'package:gtoserviceapp/screens/profile/local_admin/select_table.dart';
import 'package:gtoserviceapp/services/auth/auth.dart';
import 'package:gtoserviceapp/services/repo/event.dart';
import 'package:gtoserviceapp/services/repo/table.dart';
import 'package:gtoserviceapp/services/storage/storage.dart';

import '../profile/common/event_secretaries.dart';
import 'event_participants.dart';
import 'event_trials.dart';

class EventScreen extends StatefulWidget {
  final int orgId;
  final int eventId;
  final bool editable;
  final bool canModerate;

  EventScreen(
      {@required this.orgId,
      @required this.eventId,
      bool editable,
      bool canModerate})
      : editable = editable ?? true,
        canModerate = canModerate ?? true;

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureWidgetBuilder(
      EventRepo.I.get(widget.orgId, widget.eventId),
      _build,
    );
  }

  Scaffold _build(_, Event event) {
    return Scaffold(
      appBar: _buildAppBar(event),
      body: _buildBody(event),
    );
  }

  Widget _buildBody(Event event) {
    return ListView(
      children: <Widget>[
        _buildEventCard(event),
        ..._buildButtons(event),
      ],
    );
  }

  AppBar _buildAppBar(Event event) {
    bool canEdit = widget.editable &&
        _canEdit(event) &&
        (Storage.I.role == Role.LocalAdmin || Storage.I.role == Role.Secretary);

    return AppBar(
      title: Text("Мероприятие"),
      actions: canEdit
          ? <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _onEditPressed(),
              ),
            ]
          : null,
    );
  }

  Widget _buildEventCard(Event event) {
    return ExpandedHorizontally(
      child: CardPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HeadlineText(event.name),
            Text(event.description),
            Row(
              children: <Widget>[
                Field("Начало", child: DateText(event.startDate)),
                SizedBox(width: 16),
                Field("Конец", child: DateText(event.expirationDate)),
              ],
            ),
            Field("Статус", child: Text(event.state.toText())),
            _buildTableField(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildButtons(Event event) {
    var buttons = <Widget>[];

    Role role = Storage.I.role;
    if (widget.editable && role == Role.LocalAdmin && _canChangeState(event)) {
      buttons.add(_buildChangeStateButton());
    }

    var canEdit = _canEdit(event);
    if (widget.editable &&
        (role == Role.LocalAdmin || role == Role.Secretary) &&
        canEdit) {
      buttons.add(_buildSelectTableButton());
    }
    buttons.add(_buildTrialsButton(event));
    buttons.add(_buildParticipantsButton(event));
    buttons.add(_buildTeamsButton(event));

    if (widget.editable && role == Role.LocalAdmin) {
      buttons.add(_buildEventSecretaryCatalogButton(editable: canEdit));
    }

    if (widget.editable &&
        (role == Role.LocalAdmin || role == Role.Secretary) &&
        canEdit) {
      buttons.add(_buildAddRefereeButton());
    }
    if (canEdit) {
      buttons.add(_buildApplyUnsubscribeButton());
    }

    buttons.add(SizedBox(height: 16));
    return buttons;
  }

  FutureWidgetBuilder<ConversionTable> _buildTableField() {
    return FutureWidgetBuilder(
      TableRepo.I.getFromEvent(widget.eventId),
      (context, ConversionTable table) {
        return Field(
          "Таблица перевода",
          child: Text(table?.name ?? "Не выбрана"),
        );
      },
    );
  }

  _onEditPressed() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return AddEditEventScreen(
        orgId: widget.orgId,
        eventId: widget.eventId,
        onUpdate: _onUpdate,
      );
    }));
  }

  Widget _buildChangeStateButton() {
    return CardButton(
      text: "Изменить статус",
      icon: Icons.fast_forward,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return ChangeEventStateScreen(
            eventId: widget.eventId,
            onUpdate: _onUpdate,
          );
        }));
      },
    );
  }

  Widget _buildSelectTableButton() {
    return CardButton(
      text: "Выбрать таблицу перевода",
      icon: Icons.table_chart,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return SelectTableScreen(
            eventId: widget.eventId,
            onUpdate: _onUpdate,
          );
        }));
      },
    );
  }

  Widget _buildTrialsButton(Event event) {
    return CardButton(
      text: "Виды спорта",
      icon: Icons.directions_run,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return EventTrialsScreen(
            orgId: widget.orgId,
            eventId: widget.eventId,
            editable: _canEdit(event) && widget.editable,
            resultsEditable: _canChangeResults(event) && widget.editable,
          );
        }));
      },
    );
  }

  Widget _buildParticipantsButton(Event event) {
    return CardButton(
      text: "Участники",
      icon: Icons.person,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return EventParticipantsScreen(
            eventId: widget.eventId,
            editable: _canEdit(event) && widget.editable,
            canModerate: widget.canModerate,
            resultsEditable: _canChangeResults(event) && widget.editable,
          );
        }));
      },
    );
  }

  Widget _buildTeamsButton(Event event) {
    return CardButton(
      text: "Команды",
      icon: Icons.group,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return EventTeamsScreen(
            orgId: widget.orgId,
            eventId: widget.eventId,
            editable: _canEdit(event) && widget.editable,
            resultsEditable: _canChangeResults(event) && widget.editable,
            canModerate: widget.canModerate,
          );
        }));
      },
    );
  }

  Widget _buildEventSecretaryCatalogButton({bool editable = true}) {
    return CardButton(
      text: "Секретари",
      icon: Icons.person,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return EventSecretaryCatalogScreen(
            orgId: widget.orgId,
            eventId: widget.eventId,
            editable: editable,
          );
        }));
      },
    );
  }

  Widget _buildAddRefereeButton() {
    return CardButton(
      text: "Добавить судью",
      icon: Icons.person_add,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return AddTrialRefereeScreen(
            orgId: widget.orgId,
            eventId: widget.eventId,
          );
        }));
      },
    );
  }

  Widget _buildApplyUnsubscribeButton() {
    if (!Auth.I.isLoggedIn) {
      return _buildApplyButton();
    }

    return FutureWidgetBuilder(
      EventRepo.I.isAppliedFor(widget.eventId),
      (context, bool applied) {
        if (applied) {
          return _buildUnsubscribeButton();
        } else {
          return _buildApplyButton();
        }
      },
    );
  }

  CardButton _buildApplyButton() {
    return CardButton(
      text: "Подать заявку на участие",
      icon: Icons.check,
      onTap: () {
        if (!Auth.I.isLoggedIn) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return LoginScreen(callback: () => _onApplyPressed());
          }));
        } else {
          _onApplyPressed();
        }
      },
    );
  }

  CardButton _buildUnsubscribeButton() {
    return CardButton(
      text: "Отменить заявку",
      icon: Icons.close,
      onTap: _onUnsubscribePressed,
    );
  }

  void _onApplyPressed() {
    setState(() {});
    EventRepo.I.apply(widget.eventId).then((_) {
      setState(() {});
      showDialog(
          context: context,
          child: OkDialog(
            "Успешно",
            text: "Заявка отправлена",
          ));
    }).catchError((error) {
      showDialog(context: context, child: ErrorDialog.fromError(error));
    });
  }

  void _onUnsubscribePressed() {
    EventRepo.I.unsubscribe(widget.eventId).then((_) {
      setState(() {});
      showDialog(
          context: context,
          child: OkDialog(
            "Успешно",
            text: "Заявка отменена",
          ));
    }).catchError((error) {
      showDialog(context: context, child: ErrorDialog.fromError(error));
    });
  }

  _onUpdate() {
    setState(() {});
  }

  bool _canEdit(Event event) {
    return event.state == EventState.Preparation;
  }

  bool _canChangeState(Event event) {
    return event.state != EventState.Finished;
  }

  bool _canChangeResults(Event event) {
    return event.state == EventState.InProgress;
  }
}
