import 'package:get_it/get_it.dart';
import 'package:gtoserviceapp/models/gender.dart';
import 'package:gtoserviceapp/services/api/api.dart';
import 'package:gtoserviceapp/services/api/routes.dart';
import 'package:gtoserviceapp/services/utils/utils.dart';

class TeamLead {
  int teamLeadId;
  int userId;
  int teamId;
  String name;
  String email;
  Gender gender;
  DateTime dateOfBirth;
  int isActivity;

  TeamLead(
      {this.teamLeadId,
      this.userId,
      this.teamId,
      this.name,
      this.email,
      this.gender,
      this.dateOfBirth,
      this.isActivity});

  TeamLead.fromJson(Map<String, dynamic> json) {
    teamLeadId = json['teamLeadId'];
    userId = json['userId'];
    teamId = json['teamId'];
    name = json['name'];
    email = json['email'];
    gender = GenderEx.fromInt(json['gender']);
    dateOfBirth = DateTime.parse(json['dateOfBirth']);
    isActivity = json['isActivity'];
  }
}

class AddTeamLeadArgs {
  String email;

  AddTeamLeadArgs({this.email});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    return data;
  }
}

class TeamLeadRepo {
  static TeamLeadRepo get I {
    return GetIt.I<TeamLeadRepo>();
  }

  Future<List<TeamLead>> getAll(int teamId) async {
    List<dynamic> json = await API.I.get(
      Routes.TeamLeads.withArgs(teamId: teamId),
      auth: true,
    );
    return Utils.map(json, (json) => TeamLead.fromJson(json));
  }

  Future add(int teamId, String email) {
    return API.I.post(
      Routes.TeamLeads.withArgs(teamId: teamId),
      args: AddTeamLeadArgs(email: email).toJson(),
      auth: true,
    );
  }

  Future delete(int teamLeadId) {
    return API.I.delete(Routes.TeamLead.withArgs(teamLeadId: teamLeadId));
  }
}
