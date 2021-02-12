import 'package:get_it/get_it.dart';
import 'package:gtoserviceapp/services/api/api.dart';
import 'package:gtoserviceapp/services/api/routes.dart';
import 'package:gtoserviceapp/services/utils/utils.dart';

class Team {
  int id;
  int eventId;
  String name;
  int orgId;
  String nameOfEvent;
  int participantsCount;

  Team({
    this.id,
    this.eventId,
    this.name,
    this.orgId,
    this.nameOfEvent,
    this.participantsCount,
  });

  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['eventId'];
    name = json['name'];
    orgId = json['organizationId'];
    nameOfEvent = json['nameofEvent'];
    participantsCount = json['countOfPlayers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['eventId'] = this.eventId;
    data['name'] = this.name;
    data['organizationId'] = this.orgId;
    data['nameofEvent'] = this.nameOfEvent;
    data['countOfPlayers'] = this.participantsCount;
    return data;
  }
}

class AddOrUpdateTeamArgs {
  String name;

  AddOrUpdateTeamArgs({this.name});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class TeamRepo {
  static TeamRepo get I {
    return GetIt.I<TeamRepo>();
  }

  Future addToEvent(int orgId, int eventId, String teamName) {
    return API.I.post(
      Routes.EventTeams.withArgs(orgId: orgId, eventId: eventId),
      args: AddOrUpdateTeamArgs(name: teamName).toJson(),
      auth: true,
    );
  }

  Future<List<Team>> getAllFromEvent(int orgId, int eventId) async {
    List<dynamic> json = await API.I.get(
      Routes.EventTeams.withArgs(orgId: orgId, eventId: eventId),
      auth: true,
    );
    return Utils.map(json, (json) => Team.fromJson(json));
  }

  Future<List<Team>> getAllForUser() async {
    List<dynamic> json = await API.I.get(
      Routes.UserTeams.toStr(),
      auth: true,
    );
    return Utils.map(json, (json) => Team.fromJson(json));
  }

  Future<Team> get(int teamId) async {
    var json = await API.I.get(
      Routes.Team.withArgs(teamId: teamId),
      auth: true,
    );
    return Team.fromJson(json);
  }

  Future update(int teamId, String teamName) {
    return API.I.put(
      Routes.Team.withArgs(teamId: teamId),
      AddOrUpdateTeamArgs(name: teamName),
    );
  }

  Future confirm(int teamId) {
    return API.I.post(
      Routes.ConfirmTeam.withArgs(teamId: teamId),
      auth: true,
    );
  }

  Future delete(int teamId) {
    return API.I.delete(Routes.Team.withArgs(teamId: teamId));
  }
}
