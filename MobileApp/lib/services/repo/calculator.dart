import 'package:get_it/get_it.dart';
import 'package:gtoserviceapp/models/gender.dart';
import 'package:gtoserviceapp/services/api/api.dart';
import 'package:gtoserviceapp/services/api/routes.dart';

class Trials {
  List<Group> groups;
  String ageCategory;

  Trials({this.groups, this.ageCategory});

  Trials.fromJson(Map<String, dynamic> json) {
    if (json['groups'] != null) {
      groups = new List<Group>();
      json['groups'].forEach((v) {
        groups.add(Group.fromJson(v));
      });
    }
    ageCategory = json['ageCategory'];
  }
}

class Group {
  bool necessary;
  List<Trial> trials;

  Group({this.necessary, this.trials});

  Group.fromJson(Map<String, dynamic> json) {
    necessary = json['necessary'];
    if (json['group'] != null) {
      trials = List<Trial>();
      json['group'].forEach((v) {
        trials.add(Trial.fromJson(v));
      });
    }
  }
}

class Trial {
  String name;
  int id;
  String resultForBronze;
  String resultForSilver;
  String resultForGold;
  bool typeTime;

  Trial({
    this.name,
    this.id,
    this.resultForBronze,
    this.resultForSilver,
    this.resultForGold,
    this.typeTime,
  });

  Trial.fromJson(Map<String, dynamic> json) {
    name = json['trialName'];
    id = json['trialId'];
    resultForBronze = json['resultForBronze'];
    resultForSilver = json['resultForSilver'];
    resultForGold = json['resultForGold'];
    typeTime = json['typeTime'];
  }
}

class SecondaryResultResponse {
  int secondaryResult;

  SecondaryResultResponse({this.secondaryResult});

  SecondaryResultResponse.fromJson(Map<String, dynamic> json) {
    secondaryResult = json['secondResult'];
  }
}

class CalculatorRepo {
  static CalculatorRepo get I {
    return GetIt.I<CalculatorRepo>();
  }

  Future<Trials> fetchTrials(int age, Gender gender) async {
    var json = await API.I.get(Routes.Trial.withArgs(age: age, gender: gender));
    return Trials.fromJson(json);
  }

  Future<SecondaryResultResponse> fetchSecondaryResult(
    int trialId,
    String primaryResult,
  ) async {
    var json = await API.I.get(Routes.TrialSecondaryResult.withArgs(
      trialId: trialId,
      primaryResult: primaryResult,
    ));
    return SecondaryResultResponse.fromJson(json);
  }
}
