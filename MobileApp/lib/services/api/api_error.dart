import 'dart:convert';

import 'package:http/http.dart';

class APIErrors implements Exception {
  int statusCode;
  List<APIError> errors;

  APIErrors(
    Map<String, dynamic> json, {
    int statusCode,
  }) {
    this.statusCode = statusCode;
    errors = new List<APIError>();

    if (json['description'] != null) {
      // TODO: используется в микросервисе фотографий
      errors.add(APIError.fromJson(json));
    }
    if (json['error'] != null) {
      // TODO: недокументировано
      errors.add(APIError.fromJson(json['error']));
    }
    if (json['errors'] != null) {
      json['errors'].forEach((v) {
        errors.add(APIError.fromJson(v));
      });
    }
  }

  APIErrors.fromJson(Map<String, dynamic> json) : this(json);

  APIErrors.fromResponse(Response response)
      : this(
          response.body.isNotEmpty ? jsonDecode(response.body) : {},
          statusCode: response.statusCode,
        );

  @override
  String toString() {
    String result = "";
    if (statusCode != null) {
      result += statusCode.toString() + ": ";
    }

    result += errors.map((e) => e.toString()).join(", ");
    return result;
  }

  String toText() {
    if (statusCode >= 500) {
      return "Ошибка сервера";
    } else
    /*if (statusCode >= 400)*/ {
      return errors.map((e) => e.toText()).join(", ");
    }
  }
}

class APIError {
  String type;
  String description;

  APIError.fromJson(Map<String, dynamic> json) {
    type = json['type'] ?? "ERROR";
    description = json['description'];
  }

  String toString() {
    return "$type: $description";
  }

  String toText() {
    return description;
  }
}
