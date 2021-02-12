import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';
import 'package:gtoserviceapp/components/widgets/text/headline.dart';

class CardListView<T> extends StatelessWidget {
  final List<T> _data;
  final Widget Function(BuildContext, T) _builder;
  final void Function(BuildContext, T) _onTap;

  CardListView(
    this._data,
    this._builder, {
    void Function(BuildContext, T) onTap,
  }) : _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    if (_data.length == 0) {
      return Padding(
        padding: DefaultMargin,
        child: HeadlineText("Список пуст", color: Colors.black45),
      );
    }

    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        SizedBox(height: 14),
        ..._data.map((T data) => _buildTile(context, data)).toList(),
        SizedBox(height: 14),
      ],
    );
  }

  Widget _buildTile(context, T data) {
    return CardPadding(
      margin: ListMargin,
      onTap: _onTapWrapper(context, data),
      child: _builder(context, data),
    );
  }

  Function() _onTapWrapper(context, T data) {
    if (_onTap == null) {
      return null;
    }
    return () => _onTap(context, data);
  }
}
