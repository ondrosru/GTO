import 'package:get_it/get_it.dart';
import 'package:gtoserviceapp/models/gender.dart';
import 'package:gtoserviceapp/services/api/api.dart';
import 'package:gtoserviceapp/services/api/routes.dart';
import 'package:gtoserviceapp/services/utils/utils.dart';

class Referee {
  int id;
  int orgId;
  int userId;
  String name;
  Gender gender;
  DateTime dateOfBirth;
  String email;

  Referee(
      {this.id,
      this.orgId,
      this.userId,
      this.name,
      this.gender,
      this.dateOfBirth,
      this.email});

  Referee.fromJson(Map<String, dynamic> json) {
    id = json['refereeOnOrganizationId'];
    orgId = json['organizationId'];
    userId = json['userId'];
    name = json['name'];
    gender = GenderEx.fromInt(json['gender']);
    dateOfBirth = DateTime.parse(json['dateOfBirth']);
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['refereeOnOrganizationId'] = this.id;
    data['organizationId'] = this.orgId;
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['gender'] = this.gender.toInt();
    data['dateOfBirth'] = Utils.dateToJson(this.dateOfBirth);
    data['email'] = this.email;
    return data;
  }
}

class AddRefereeArgs {
  String email;

  AddRefereeArgs({this.email});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    return data;
  }
}

class RefereeRepo {
  static RefereeRepo get I {
    return GetIt.I<RefereeRepo>();
  }

  Future add(int orgId, String email) {
    return API.I.post(
      Routes.OrgReferees.withArgs(orgId: orgId),
      auth: true,
      args: AddRefereeArgs(email: email).toJson(),
    );
  }

  Future addToTrial(int trialId, int refereeId) {
    return API.I.post(
      Routes.EventTrialReferee.withArgs(
        trialId: trialId,
        refereeId: refereeId,
      ),
      auth: true,
    );
  }

  Future<List<Referee>> getAll(int orgId) async {
    List<dynamic> json = await API.I.get(
      Routes.OrgReferees.withArgs(orgId: orgId),
      auth: true,
    );

    return Utils.map(json, (json) => Referee.fromJson(json));
  }

  Future deleteFromTrial(int refereeInTrialInEvent) {
    return API.I.delete(Routes.Trial.withArgs(
      refereeId: refereeInTrialInEvent,
    ));
  }

  Future delete(int orgId, int refereeId) {
    return API.I.delete(
      Routes.OrgReferee.withArgs(orgId: orgId, refereeId: refereeId),
    );
  }
}
