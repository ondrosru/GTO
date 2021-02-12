import 'package:get_it/get_it.dart';
import 'package:gtoserviceapp/services/api/api.dart';
import 'package:gtoserviceapp/services/api/routes.dart';
import 'package:gtoserviceapp/services/utils/utils.dart';

class Org {
  int id;
  String name;
  String address;
  String leader;
  String phoneNumber;
  String oQRN;
  String paymentAccount;
  String branch;
  String bik;
  String correspondentAccount;
  int countOfAllEvents;
  int countOfActiveEvents;

  Org(
      {this.id,
      this.name,
      this.address,
      this.leader,
      this.phoneNumber,
      this.oQRN,
      this.paymentAccount,
      this.branch,
      this.bik,
      this.correspondentAccount,
      this.countOfAllEvents,
      this.countOfActiveEvents});

  Org.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']);
    name = json['name'];
    address = json['address'];
    leader = json['leader'];
    phoneNumber = json['phone_number'];
    phoneNumber ??= json['phoneNumber'];
    oQRN = json['OQRN'];
    paymentAccount = json['payment_account'];
    branch = json['branch'];
    bik = json['bik'];
    correspondentAccount = json['correspondent_account'];
    countOfAllEvents = json['countOfAllEvents'];
    countOfActiveEvents = json['countOfActiveEvents'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['leader'] = this.leader;
    data['phoneNumber'] = this.phoneNumber;
    data['oqrn'] = this.oQRN;
    data['OQRN'] = this.oQRN;
    data['paymentAccount'] = this.paymentAccount;
    data['payment_account'] = this.paymentAccount;
    data['branch'] = this.branch;
    data['bik'] = this.bik;
    data['correspondentAccount'] = this.correspondentAccount;
    data['correspondent_account'] = this.correspondentAccount;
    data['leader'] = this.leader;
    data['countOfAllEvents'] = this.countOfAllEvents;
    data['countOfActiveEvents'] = this.countOfActiveEvents;
    return data;
  }
}

class CreateOrgResponse {
  int id;

  CreateOrgResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }
}

class OrgRepo {
  static OrgRepo get I {
    return GetIt.I<OrgRepo>();
  }

  Future<CreateOrgResponse> add(Org org) async {
    var json = await API.I.post(
      Routes.Organizations.toStr(),
      args: org.toJson(),
      auth: true,
    );
    return CreateOrgResponse.fromJson(json);
  }

  Future<Org> get(int orgId) async {
    var json = await API.I.get(Routes.Organization.withArgs(orgId: orgId));
    return Org.fromJson(json);
  }

  Future<List<Org>> getAll() async {
    var json = await API.I.get(Routes.Organizations.toStr());
    return Utils.map(json, (json) => Org.fromJson(json));
  }

  Future update(Org org) async {
    await API.I.put(Routes.Organization.withArgs(orgId: org.id), org.toJson());
  }

  Future delete(int orgId) async {
    await API.I.delete(Routes.Organization.withArgs(orgId: orgId));
  }
}
