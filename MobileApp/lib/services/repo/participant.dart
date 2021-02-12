import 'package:get_it/get_it.dart';
import 'package:gtoserviceapp/models/gender.dart';
import 'package:gtoserviceapp/services/api/api.dart';
import 'package:gtoserviceapp/services/api/routes.dart';
import 'package:gtoserviceapp/services/utils/utils.dart';

class Participant {
  int eventParticipantId;
  int userId;
  int eventId;
  int teamId;
  bool isConfirmed;
  String name;
  String email;
  Gender gender;
  DateTime dateOfBirth;
  bool isActivity;

  Participant(
      {this.eventParticipantId,
      this.userId,
      this.eventId,
      this.teamId,
      this.isConfirmed,
      this.name,
      this.email,
      this.gender,
      this.dateOfBirth,
      this.isActivity});

  Participant.fromJson(Map<String, dynamic> json) {
    eventParticipantId = json['EventParticipantId'];
    userId = json['userId'];
    eventId = json['eventId'];
    teamId = json['teamId'];
    isConfirmed = json['isConfirmed'];
    name = json['name'];
    email = json['email'];
    gender = GenderEx.fromInt(json['gender']);
    dateOfBirth = DateTime.parse(json['dateOfBirth']);
//    isActivity = json['isActivity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EventParticipantId'] = this.eventParticipantId;
    data['userId'] = this.userId;
    data['eventId'] = this.eventId;
    data['teamId'] = this.teamId;
    data['isConfirmed'] = this.isConfirmed;
    data['name'] = this.name;
    data['email'] = this.email;
    data['gender'] = this.gender.toInt();
    data['dateOfBirth'] = Utils.dateToJson(this.dateOfBirth);
    data['isActivity'] = this.isActivity;
    return data;
  }
}

class AddParticipantArgs {
  String email;

  AddParticipantArgs({this.email});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    return data;
  }
}

class ParticipantRepo {
  static ParticipantRepo get I {
    return GetIt.I<ParticipantRepo>();
  }

  Future addToTeam(int teamId, String email) async {
    return API.I.post(
      Routes.TeamParticipants.withArgs(teamId: teamId),
      args: AddParticipantArgs(email: email).toJson(),
      auth: true,
    );
  }

  Future addToEvent(int eventId, String email) async {
    return API.I.post(
      Routes.EventParticipants.withArgs(eventId: eventId),
      args: AddParticipantArgs(email: email).toJson(),
      auth: true,
    );
  }

  Future<List<Participant>> getAllFromTeam(int teamId) async {
    List<dynamic> json = await API.I.get(
      Routes.TeamParticipants.withArgs(teamId: teamId),
    );
    return Utils.map(json, (json) => Participant.fromJson(json));
  }

  Future<List<Participant>> getAllFromEvent(int eventId) async {
    List<dynamic> json = await API.I.get(
      Routes.EventParticipants.withArgs(eventId: eventId),
    );
    return Utils.map(json, (json) => Participant.fromJson(json));
  }

  Future confirm(int participantId) {
    return API.I.post(
      Routes.Participant.withArgs(participantId: participantId),
      auth: true,
    );
  }

  Future update(int participantId, Participant participant) {
    return API.I.put(
      Routes.Participant.withArgs(participantId: participantId),
      participant.toJson(),
    );
  }

  Future delete(int participantId) {
    return API.I.delete(
      Routes.Participant.withArgs(
        participantId: participantId,
      ),
    );
  }
}
