import 'package:flutter/material.dart';

class Selector<T, K> extends StatefulWidget {
  final K value;
  final List<T> data;
  final Widget Function(T) builder;
  final Function(K) onChanged;
  final K Function(T) getKey;
  final String hint;

  Selector({
    @required this.value,
    @required this.data,
    @required this.builder,
    @required this.onChanged,
    @required this.getKey,
    this.hint,
  });

  @override
  _SelectorState<T, K> createState() => _SelectorState<T, K>();
}

class _SelectorState<T, K> extends State<Selector<T, K>> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<K>(
      value: widget.value,
      isExpanded: true,
      itemHeight: null,
      onChanged: widget.onChanged,
      hint: Text(widget.hint ?? ""),
      items: _buildItems(),
    );
  }

  List<DropdownMenuItem<K>> _buildItems() {
    return widget.data.map(_buildItem).toList();
  }

  DropdownMenuItem<K> _buildItem(T data) {
    return DropdownMenuItem<K>(
      value: widget.getKey(data),
      child: Container(child: widget.builder(data)),
    );
  }
}
