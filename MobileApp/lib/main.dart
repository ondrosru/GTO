import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gtoserviceapp/screens/initial/initial.dart';
import 'package:gtoserviceapp/services/api/api.dart';
import 'package:gtoserviceapp/services/auth/auth.dart';
import 'package:gtoserviceapp/services/cameras/cameras.dart';
import 'package:gtoserviceapp/services/linking/linking.dart';
import 'package:gtoserviceapp/services/navigation/navigation.dart';
import 'package:gtoserviceapp/services/repo/calculator.dart';
import 'package:gtoserviceapp/services/repo/event.dart';
import 'package:gtoserviceapp/services/repo/local_admin.dart';
import 'package:gtoserviceapp/services/repo/org.dart';
import 'package:gtoserviceapp/services/repo/participant.dart';
import 'package:gtoserviceapp/services/repo/photo.dart';
import 'package:gtoserviceapp/services/repo/referee.dart';
import 'package:gtoserviceapp/services/repo/result.dart';
import 'package:gtoserviceapp/services/repo/secretary.dart';
import 'package:gtoserviceapp/services/repo/sport_object.dart';
import 'package:gtoserviceapp/services/repo/table.dart';
import 'package:gtoserviceapp/services/repo/team.dart';
import 'package:gtoserviceapp/services/repo/team_lead.dart';
import 'package:gtoserviceapp/services/repo/trial.dart';
import 'package:gtoserviceapp/services/repo/user.dart';
import 'package:gtoserviceapp/services/storage/storage.dart';
import 'package:gtoserviceapp/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();

  runApp(GTOServiceApp());
}

class GTOServiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Navigation.I.navigatorKey,
      title: 'GTO Service',
      theme: buildTheme(),
      home: InitialScreen(),
    );
  }

  dispose() {
    Linking.stopListening();
  }
}

setup() async {
  GetIt.I.registerSingleton<API>(API());
  setupRepos();
  GetIt.I.registerSingleton<Navigation>(Navigation());
  await Storage.I.init();
  Linking.startListening();
}

void setupRepos() {
  GetIt.I.registerSingleton<Storage>(Storage());
  GetIt.I.registerSingleton<Auth>(Auth());
  GetIt.I.registerSingleton<Cameras>(Cameras());
  GetIt.I.registerSingleton<OrgRepo>(OrgRepo());
  GetIt.I.registerSingleton<LocalAdminRepo>(LocalAdminRepo());
  GetIt.I.registerSingleton<EventRepo>(EventRepo());
  GetIt.I.registerSingleton<UserRepo>(UserRepo());
  GetIt.I.registerSingleton<SecretaryRepo>(SecretaryRepo());
  GetIt.I.registerSingleton<SportObjectRepo>(SportObjectRepo());
  GetIt.I.registerSingleton<RefereeRepo>(RefereeRepo());
  GetIt.I.registerSingleton<CalculatorRepo>(CalculatorRepo());
  GetIt.I.registerSingleton<TrialRepo>(TrialRepo());
  GetIt.I.registerSingleton<TableRepo>(TableRepo());
  GetIt.I.registerSingleton<ResultRepo>(ResultRepo());
  GetIt.I.registerSingleton<TeamRepo>(TeamRepo());
  GetIt.I.registerSingleton<TeamLeadRepo>(TeamLeadRepo());
  GetIt.I.registerSingleton<ParticipantRepo>(ParticipantRepo());
  GetIt.I.registerSingleton<PhotoRepo>(PhotoRepo());
}
