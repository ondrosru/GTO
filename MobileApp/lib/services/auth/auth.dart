import 'package:get_it/get_it.dart';
import 'package:gtoserviceapp/services/navigation/navigation.dart';
import 'package:gtoserviceapp/services/repo/user.dart';
import 'package:gtoserviceapp/services/storage/keys.dart';
import 'package:gtoserviceapp/services/storage/storage.dart';

class Auth {
  static Auth get I {
    return GetIt.I<Auth>();
  }

  bool get isLoggedIn {
    return Storage.I.has(Keys.accessToken) && Storage.I.has(Keys.refreshToken);
  }

  Future setToken(String token) {
    return Storage.I.write(Keys.accessToken, token);
  }

  Future<void> login(String email, String password) async {
    var response = await UserRepo.I.login(email, password);

    return Future.wait([
      Storage.I.write(Keys.accessToken, response.accessToken),
      Storage.I.write(Keys.refreshToken, response.refreshToken),
      Storage.I.write(Keys.role, response.role),
      Storage.I.write(Keys.orgId, response.orgId.toString()),
      Storage.I.write(Keys.userId, response.userID.toString()),
    ]);
  }

  Future<void> refresh() async {
    try {
      return await _refresh();
    } catch (e) {
      await _onRefreshError();
      rethrow;
    }
  }

  Future _onRefreshError() async {
    await logout();
    Navigation.I.popAll();
    Navigation.I.pushLoginScreen();
  }

  _refresh() async {
    var response = await UserRepo.I.refresh();

    return Future.wait([
      Storage.I.write(Keys.accessToken, response.accessToken),
      Storage.I.write(Keys.refreshToken, response.refreshToken),
    ]);
  }

  Future<void> logout() async {
    return Future.wait([
      Storage.I.delete(Keys.accessToken),
      Storage.I.delete(Keys.refreshToken),
      Storage.I.delete(Keys.role),
      Storage.I.delete(Keys.orgId),
      Storage.I.delete(Keys.userId),
    ]);
  }
}
