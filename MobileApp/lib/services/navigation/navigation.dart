import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gtoserviceapp/screens/login/login.dart';

class Navigation {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Navigation get I {
    return GetIt.I<Navigation>();
  }

  popAll() {
    navigatorKey.currentState.popUntil((route) => route.isFirst);
  }

  pushLoginScreen() {
    navigatorKey.currentState.push(MaterialPageRoute(builder: (_) {
      return LoginScreen();
    }));
  }

  pushScreen(Widget screen) {
    navigatorKey.currentState.push(MaterialPageRoute(builder: (_) {
      return screen;
    }));
  }
}
