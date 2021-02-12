import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/future_widget_builder.dart';
import 'package:gtoserviceapp/screens/info/main_screen.dart';
import 'package:gtoserviceapp/services/linking/linking.dart';
import 'package:uni_links/uni_links.dart';

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureWidgetBuilder(
      getInitialUri(),
      (_, link) {
        if (link == null) {
          return MainScreen();
        }
        print(link.toString());
        return Linking.linkToScreen(link);
      },
      placeholderBuilder: () => Scaffold(
        appBar: AppBar(),
      ),
    );
  }
}
