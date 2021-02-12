import 'package:get_it/get_it.dart';
import 'package:gtoserviceapp/models/badge.dart';
import 'package:gtoserviceapp/models/gender.dart';
import 'package:gtoserviceapp/services/api/api.dart';
import 'package:gtoserviceapp/services/api/routes.dart';

class Result {
  List<Group> groups;
  String ageCategory;
  Badge badge;
  int countTestsForBronze;
  int countTestForSilver;
  int countTestsForGold;
  int orgId;
  int eventId;

  Result(
      {this.groups,
      this.ageCategory,
      this.badge,
      this.countTestsForBronze,
      this.countTestForSilver,
      this.countTestsForGold,
      this.orgId,
      this.eventId});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['groups'] != null) {
      groups = new List<Group>();
      json['groups'].forEach((v) {
        groups.add(new Group.fromJson(v));
      });
    }
    ageCategory = json['ageCategory'];
    badge = BadgeEx.fromString(json['badge']);
    countTestsForBronze = json['countTestsForBronze'];
    countTestForSilver = json['countTestForSilver'];
    countTestsForGold = json['countTestsForGold'];
    orgId = json['orgId'];
    eventId = json['eventId'];
  }
}

class Group {
  List<Trial> trials;
  bool necessary;

  Group({this.trials, this.necessary});

  Group.fromJson(Map<String, dynamic> json) {
    if (json['group'] != null) {
      trials = new List<Trial>();
      json['group'].forEach((v) {
        trials.add(new Trial.fromJson(v));
      });
    }
    necessary = json['necessary'];
  }
}

class Trial {
  String trialName;
  int trialId;
  bool typeTime;
  String firstResult;
  int secondResult;
  Badge badge;
  String resultForBronze;
  String resultForSilver;
  String resultForGold;
  int resultInTrialId;

  Trial(
      {this.trialName,
      this.trialId,
      this.typeTime,
      this.firstResult,
      this.secondResult,
      this.badge,
      this.resultForBronze,
      this.resultForSilver,
      this.resultForGold});

  Trial.fromJson(Map<String, dynamic> json) {
    trialName = json['trialName'];
    trialId = json['trialId'];
    typeTime = json['typeTime'];
    firstResult = json['firstResult'];
    secondResult = json['secondResult'];
    resultInTrialId = json['resultTrialOnEventId'];
    badge = BadgeEx.fromString(json['badge']);
    resultForBronze = json['resultForBronze'];
    resultForSilver = json['resultForSilver'];
    resultForGold = json['resultForGold'];
  }
}

class Results {
  List<ParticipantResult> participants;
  String trialName;
  bool isTypeTime;
  String eventStatus;

  Results({
    this.participants,
    this.trialName,
    this.isTypeTime,
    this.eventStatus,
  });

  Results.fromJson(Map<String, dynamic> json) {
    if (json['participants'] != null) {
      participants = new List<ParticipantResult>();
      json['participants'].forEach((v) {
        participants.add(new ParticipantResult.fromJson(v));
      });
    }
    trialName = json['trialName'];
    isTypeTime = json['isTypeTime'];
    eventStatus = json['eventStatus'];
  }
}

class ParticipantResult {
  int userId;
  int resultOfTrialInEventId;
  String userName;
  int teamId;
  String teamName;
  DateTime dateOfBirth;
  Gender gender;
  String firstResult;
  int secondResult;
  Badge badge;
  int orgId;
  int eventId;

  ParticipantResult({
    this.userId,
    this.resultOfTrialInEventId,
    this.userName,
    this.teamId,
    this.teamName,
    this.dateOfBirth,
    this.gender,
    this.firstResult,
    this.secondResult,
    this.badge,
    this.orgId,
    this.eventId,
  });

  ParticipantResult.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    resultOfTrialInEventId = json['resultOfTrialInEventId'];
    userName = json['userName'];
    teamId = json['teamId'];
    teamName = json['teamName'];
    dateOfBirth = DateTime.parse(json['dateOfBirth']);
    gender = GenderEx.fromInt(json['gender']);
    firstResult = json['firstResult'];
    secondResult = json['secondResult'];
    badge = BadgeEx.fromString(json['badge']);
    orgId = json['orgId'];
    eventId = json['eventId'];
  }
}

class ChangeResultArgs {
  String result;

  ChangeResultArgs({this.result});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstResult'] = this.result;
    return data;
  }
}

class ResultRepo {
  static ResultRepo get I {
    return GetIt.I<ResultRepo>();
  }

  Future<Result> getEventUserResult(int eventId, int userId) async {
    var json = await API.I.get(
      Routes.EventUserResult.withArgs(
        eventId: eventId,
        userId: userId,
      ),
      auth: true,
    );
    return Result.fromJson(json);
  }

  Future<List<Results>> getEventResults(int eventId) async {
    List<dynamic> json = await API.I.get(
      Routes.EventResults.withArgs(
        eventId: eventId,
      ),
      auth: true,
    );
    return json.map((json) => Results.fromJson(json));
  }

  Future<Results> getTrialResults(int trialInEventId) async {
    var json = await API.I.get(
      Routes.TrialResults.withArgs(
        trialInEventId: trialInEventId,
      ),
      auth: true,
    );
    return Results.fromJson(json);
  }

  Future changeTrialResult(int resultId, String result) {
    return API.I.put(
      Routes.TrialResult.withArgs(resultId: resultId),
      ChangeResultArgs(result: result),
    );
  }
}
