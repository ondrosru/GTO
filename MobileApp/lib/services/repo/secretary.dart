import 'package:get_it/get_it.dart';
import 'package:gtoserviceapp/models/gender.dart';
import 'package:gtoserviceapp/services/api/api.dart';
import 'package:gtoserviceapp/services/api/routes.dart';
import 'package:gtoserviceapp/services/utils/utils.dart';

class Secretary {
  int secretaryOnOrganizationId;
  int organizationId;
  int userId;
  String name;
  Gender gender;
  DateTime dateOfBirth;
  String email;
  int secretaryId;

  Secretary(
      {this.secretaryOnOrganizationId,
      this.organizationId,
      this.userId,
      this.name,
      this.gender,
      this.dateOfBirth,
      this.email,
      this.secretaryId});

  Secretary.fromJson(Map<String, dynamic> json) {
    secretaryOnOrganizationId = json['secretaryOnOrganizationId'];
    organizationId = json['organizationId'];
    userId = json['userId'];
    name = json['name'];
    gender = GenderEx.fromInt(json['gender']);
    dateOfBirth = DateTime.parse(json['dateOfBirth']);
    email = json['email'];
    secretaryId = json['secretaryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['secretaryOnOrganizationId'] = this.secretaryOnOrganizationId;
    data['organizationId'] = this.organizationId;
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['gender'] = this.gender.toInt();
    data['dateOfBirth'] = Utils.dateToJson(this.dateOfBirth);
    data['email'] = this.email;
    data['secretaryId'] = this.secretaryId;
    return data;
  }
}

class AddSecretaryArgs {
  String email;

  AddSecretaryArgs({this.email});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    return data;
  }
}

class SecretaryRepo {
  static SecretaryRepo get I {
    return GetIt.I<SecretaryRepo>();
  }

  Future addToOrg(int orgId, String email) {
    return API.I.post(
      Routes.OrgSecretaries.withArgs(orgId: orgId),
      auth: true,
      args: AddSecretaryArgs(email: email).toJson(),
    );
  }

  Future addToEvent(int orgId, int eventId, int secretaryOnOrgId) {
    return API.I.post(
      Routes.EventSecretary.withArgs(
        orgId: orgId,
        eventId: eventId,
        secretaryId: secretaryOnOrgId,
      ),
      auth: true,
    );
  }

  Future<List<Secretary>> getFromOrg(int orgId) async {
    List json = await API.I.get(
      Routes.OrgSecretaries.withArgs(orgId: orgId),
      auth: true,
    );
    return Utils.map(json, (json) => Secretary.fromJson(json));
  }

  Future<List<Secretary>> getFromEvent(int orgId, int eventId) async {
    List json = await API.I.get(
      Routes.EventSecretaries.withArgs(orgId: orgId, eventId: eventId),
      auth: true,
    );
    return Utils.map(json, (json) => Secretary.fromJson(json));
  }

  Future deleteFromOrg(int orgId, int secretaryId) async {
    return API.I.delete(Routes.OrgSecretary.withArgs(
      orgId: orgId,
      secretaryId: secretaryId,
    ));
  }

  Future deleteFromEvent(int orgId, int eventId, int secretaryId) async {
    return API.I.delete(Routes.EventSecretary.withArgs(
      orgId: orgId,
      eventId: eventId,
      secretaryId: secretaryId,
    ));
  }
}
