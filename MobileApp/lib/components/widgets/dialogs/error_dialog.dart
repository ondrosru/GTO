import 'package:flutter/material.dart';
import 'package:gtoserviceapp/services/utils/utils.dart';

import 'ok_dialog.dart';

class ErrorDialog extends OkDialog {
  static const _title = "Ошибка";

  ErrorDialog.fromText(text) : super(_title, text: text) {
    print(text);
  }

  ErrorDialog.fromError(e) : super(_title, text: Utils.errorToString(e)) {
    print(e.toString());
  }

  static showOnFutureError<T>(BuildContext context, Future<T> future) {
    future.catchError(
      (error) => {
        showDialog(
          context: context,
          child: ErrorDialog.fromError(error),
        )
      },
    );
  }
}
