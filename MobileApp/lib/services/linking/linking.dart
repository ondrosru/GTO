import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gtoserviceapp/screens/info/main_screen.dart';
import 'package:gtoserviceapp/screens/register/confirm.dart';
import 'package:gtoserviceapp/services/navigation/navigation.dart';
import 'package:uni_links/uni_links.dart';

abstract class Linking {
  static StreamSubscription<Uri> _sub;

  static Widget linkToScreen(Uri link) {
    print(link.toString());
    var params = link.queryParameters;

    switch (link.path) {
      case "/registration/confirm":
        if (!params.containsKey("token") || !params.containsKey("email")) {
          break;
        }
        return RegisterCompleteScreen(params["email"], params["token"]);
    }
    return MainScreen();
  }

  static void startListening() {
    stopListening();
    _sub = getUriLinksStream().listen(_onLinkEvent);
  }

  static void stopListening() {
    _sub?.cancel();
    _sub = null;
  }

  static void _onLinkEvent(Uri event) {
    Navigation.I.pushScreen(linkToScreen(event));
  }
}
