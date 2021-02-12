import 'package:get_it/get_it.dart';
import 'package:gtoserviceapp/models/gender.dart';
import 'package:gtoserviceapp/services/api/api.dart';
import 'package:gtoserviceapp/services/api/routes.dart';
import 'package:gtoserviceapp/services/utils/utils.dart';

class GetUserInfoResponse {
  String email;
  String name;
  String gender;
  DateTime dateOfBirth;

  GetUserInfoResponse({this.email, this.name, this.gender, this.dateOfBirth});

  GetUserInfoResponse.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    gender = json['gender'];
    dateOfBirth = DateTime.parse(json['dateOfBirth']);
  }
}

class LoginArgs {
  String email;
  String password;

  LoginArgs({this.email, this.password})
      : assert(email != null),
        assert(password != null);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}

class LoginResponse {
  String accessToken;
  String refreshToken;
  String role;
  int orgId;
  int userID;

  LoginResponse({this.accessToken, this.refreshToken, this.role, this.orgId});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    role = json['role'];
    orgId = json['organizationId'];
    userID = json['userId'];
  }
}

class RefreshResponse {
  String accessToken;
  String refreshToken;

  RefreshResponse({this.accessToken, this.refreshToken});

  RefreshResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }
}

class InviteUserArgs {
  String name;
  String email;
  DateTime dateOfBirth;
  Gender gender;

  InviteUserArgs({this.name, this.email, this.dateOfBirth, this.gender});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['dateOfBirth'] = Utils.dateToJson(this.dateOfBirth);
    data['gender'] = this.gender.toInt();
    return data;
  }
}

class ConfirmAccountArgs {
  String password;

  ConfirmAccountArgs({this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = this.password;
    return data;
  }
}

class UserRepo {
  static UserRepo get I {
    return GetIt.I<UserRepo>();
  }

  Future invite(InviteUserArgs args) async {
    return API.I.post(
      Routes.Invite.toStr(),
      args: args.toJson(),
    );
  }

  Future register(String password) async {
    return API.I.post(
      Routes.Confirm.toStr(),
      args: ConfirmAccountArgs(password: password),
      auth: true,
    );
  }

  Future<GetUserInfoResponse> getUserInfo() async {
    var json = await API.I.post(
      Routes.Info.toStr(),
      auth: true,
    );
    return GetUserInfoResponse.fromJson(json);
  }

  Future<LoginResponse> login(String email, String password) async {
    var json = await API.I.post(
      Routes.Login.toStr(),
      args: LoginArgs(email: email, password: password).toJson(),
    );
    return LoginResponse.fromJson(json);
  }

  Future<RefreshResponse> refresh() async {
    var json = await API.I.post(
      Routes.Refresh.toStr(),
      refresh: true,
    );
    return RefreshResponse.fromJson(json);
  }
}
