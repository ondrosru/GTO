import 'package:flutter/material.dart';

ThemeData buildTheme() {
  return ThemeData(
    primarySwatch: Colors.blue,
    buttonColor: Colors.blue.shade200,
    canvasColor: Colors.grey.shade100,
    textTheme: TextTheme(
      bodyText2: TextStyle(
        fontSize: 16,
      ),
    ),
  );
}
