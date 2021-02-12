import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gtoserviceapp/services/api/api_error.dart';

class Utils {
  static String formatWidth(int value, int width) {
    return value.toString().padLeft(width, "0");
  }

  static String formatDate(DateTime date) {
    return "${formatWidth(date.day, 2)}.${formatWidth(date.month, 2)}.${date.year}";
  }

  static String formatDateTime(DateTime date) {
    return formatDate(date) +
        " ${formatWidth(date.hour, 2)}:${formatWidth(date.minute, 2)}";
  }

  static String dateToJson(DateTime date) {
    return "${date.year}-${formatWidth(date.month, 2)}-${formatWidth(date.day, 2)}";
  }

  static String dateTimeToJson(DateTime dateTime) {
    if (dateTime == null) {
      return null;
    }

    return dateToJson(dateTime) +
        " " +
        formatWidth(dateTime.hour, 2) +
        ":" +
        formatWidth(dateTime.minute, 2) +
        ":" +
        formatWidth(dateTime.second, 2);
  }

  static String errorToString(error) {
    if (!kReleaseMode) {
      // Debug
      return error.toString();
    }

    if (error is APIErrors) {
      return error.toText();
    } else if (error is SocketException) {
      return "Не удалось подключиться к серверу";
    } else if (error is FormatException) {
      return "Ошибка сервера";
    } else {
      return error.toString();
    }
  }

  static T tryCatchLog<T>(T Function() cb) {
    try {
      return cb();
    } catch (e, s) {
      print(e.toString());
      print(s.toString());
      rethrow;
    }
  }

  static List<T> map<T>(List<dynamic> list, T Function(dynamic) mapFn) {
    if (list == null) {
      return [];
    }
    return list.map(mapFn).toList();
  }
}
