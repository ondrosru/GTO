import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/info/team_info.dart';
import 'package:gtoserviceapp/screens/info/catalog.dart';
import 'package:gtoserviceapp/screens/info/team.dart';
import 'package:gtoserviceapp/services/repo/team.dart';

class TeamLeadTeamsScreen extends StatefulWidget {
  @override
  _TeamLeadTeamsScreenState createState() => _TeamLeadTeamsScreenState();
}

class _TeamLeadTeamsScreenState extends State<TeamLeadTeamsScreen> {
  @override
  Widget build(BuildContext context) {
    return CatalogScreen<Team>(
      title: "Мои команды",
      getData: () => TeamRepo.I.getAllForUser(),
      buildInfo: (Team team) => TeamInfo(team: team),
      onTapped: _onTapped,
    );
  }

  void _onTapped(context, Team team) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return TeamScreen(
        eventId: null,
        teamId: team.id,
        onUpdate: _onUpdate,
        resultsEditable: false,
        canModerate: false,
      );
    }));
  }

  void _onUpdate() {
    setState(() {});
  }
}
