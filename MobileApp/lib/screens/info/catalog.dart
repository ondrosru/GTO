import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_list_view.dart';
import 'package:gtoserviceapp/components/widgets/dialogs/error_dialog.dart';
import 'package:gtoserviceapp/components/widgets/dialogs/yes_no_dialog.dart';
import 'package:gtoserviceapp/components/widgets/future_widget_builder.dart';
import 'package:gtoserviceapp/services/utils/utils.dart';

class CatalogScreen<T> extends StatefulWidget {
  final String title;
  final Future<List<T>> Function() getData;
  final Widget Function(T) buildInfo;
  final void Function(BuildContext) onFabPressed;
  final Future<void> Function(T) onDeletePressed;
  final void Function(T) onEditPressed;
  final void Function(BuildContext, T) onTapped;
  final List<Widget> actions;

  CatalogScreen({
    @required this.title,
    @required this.getData,
    @required this.buildInfo,
    this.onFabPressed,
    this.onDeletePressed,
    this.onEditPressed,
    this.onTapped,
    this.actions,
  });

  @override
  _CatalogScreenState<T> createState() => _CatalogScreenState<T>();
}

class _CatalogScreenState<T> extends State<CatalogScreen<T>> {
  @override
  Widget build(BuildContext context) {
    return Utils.tryCatchLog(() {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: widget.actions,
        ),
        body: _buildBody(),
        floatingActionButton:
            widget.onFabPressed != null ? _buildFab(context) : null,
      );
    });
  }

  Widget _buildBody() {
    return ListView(
      children: <Widget>[
        _buildFutureList(),
      ],
    );
  }

  FutureWidgetBuilder<List<T>> _buildFutureList() {
    return FutureWidgetBuilder(
      widget.getData(),
      (context, List<T> data) => _buildList(data),
    );
  }

  Widget _buildList(List<T> data) {
    return CardListView<T>(
      data,
      _buildElement,
      onTap: widget.onTapped,
    );
  }

  Widget _buildElement(_, T data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(child: widget.buildInfo(data)),
        widget.onEditPressed != null ? _buildEditButton(data) : Container(),
        widget.onDeletePressed != null ? _buildDeleteButton(data) : Container(),
      ],
    );
  }

  Widget _buildEditButton(T data) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () => widget.onEditPressed(data),
    );
  }

  IconButton _buildDeleteButton(T data) {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () {
        showDialog(
          context: context,
          child: YesNoDialog(
            "Вы уверены?",
            _onDeletePressed(data),
          ),
        );
      },
    );
  }

  void Function() _onDeletePressed(T data) {
    return () {
      widget
          .onDeletePressed(data)
          .then((_) => setState(() {}))
          .catchError((error) {
        showDialog(context: context, child: ErrorDialog.fromError(error));
      });
    };
  }

  Widget _buildFab(context) {
    return FloatingActionButton(
      onPressed: () => widget.onFabPressed.call(context),
      child: Icon(Icons.add),
    );
  }
}
