import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/card_padding.dart';
import 'package:gtoserviceapp/components/widgets/failure.dart';

class FutureWidgetBuilder<T> extends StatelessWidget {
  final Future<T> _future;
  final Widget Function(BuildContext, T) _builder;
  final Widget Function() _placeholderBuilder;

  FutureWidgetBuilder(this._future, this._builder, {placeholderBuilder})
      : _placeholderBuilder =
            placeholderBuilder ?? (() => _buildDefaultPlaceholder());

  static Widget _buildDefaultPlaceholder() {
    return Padding(
      padding: DefaultMargin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            var error = snapshot.error;
            print(error.toString());
            if (error is Error) {
              print(error.stackTrace);
            }
            return Failure(error);
          }
          return _builder(context, snapshot.data);
        }

        return _placeholderBuilder();
      },
    );
  }
}
