import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:gtoserviceapp/services/api/api_error.dart';
import 'package:gtoserviceapp/services/auth/auth.dart';
import 'package:http/http.dart';

import 'headers.dart';


class API {
  final baseURL = Uri.parse("http://petrodim.beget.tech/api/v1");
  final baseURL2 = Uri.parse("http://213.139.208.11:5000/api/v1"); // TODO
  final Client _httpClient = Client();

  static API get I {
    return GetIt.I<API>();
  }

  Future<dynamic> get(
    String path, {
    auth = false,
  }) async {
    print("GET $path");
    final response = await _sendRequest(false, () => _get(path, auth));
    return _jsonDecode(response);
  }

  Future<dynamic> _get(String path, bool auth) {
    final url = Uri.parse("$baseURL$path");
    var headers = buildHeaders(
      auth: auth,
    );

    return _httpClient.get(url, headers: headers);
  }

  Future<Uint8List> getRaw(
    String path, {
    auth = false,
  }) async {
    print("GET $path");
    final response = await _sendRequest(false, () => _get2(path, auth));
    return response.bodyBytes;
  }

  Future<dynamic> _get2(String path, bool auth) {
    final url = Uri.parse("$baseURL2$path");
    var headers = buildHeaders(
      auth: auth,
    );

    return _httpClient.get(url, headers: headers);
  }

  Future<dynamic> post(
    String path, {
    dynamic args,
    bool auth = false,
    bool refresh = false,
  }) async {
    print("POST $path");
    Response response =
        await _sendRequest(auth, () => _post(path, args, auth, refresh));
    return _jsonDecode(response);
  }

  Future<Response> _post(
    String path,
    dynamic args,
    bool auth,
    bool refresh,
  ) async {
    final url = Uri.parse("$baseURL$path");
    var headers = buildHeaders(
      content: args != null,
      auth: auth,
      refresh: refresh,
    );

    return _httpClient.post(url, body: jsonEncode(args), headers: headers);
  }

  Future delete(String path) async {
    print("DELETE $path");
    await _sendRequest(true, _withRefresh(() => _delete(path)));
    return;
  }

  Future<Response> _delete(String path) {
    final url = Uri.parse("$baseURL$path");
    var headers = buildHeaders(
      auth: true,
    );

    return _httpClient.delete(url, headers: headers);
  }

  Future delete2(String path) async {
    print("DELETE $path");
    await _sendRequest(true, _withRefresh(() => _delete2(path)));
    return;
  }

  Future<Response> _delete2(String path) {
    final url = Uri.parse("$baseURL2$path");
    var headers = buildHeaders(
      auth: true,
    );

    return _httpClient.delete(url, headers: headers);
  }

  Future put(
    String path,
    args, {
    bool auth,
  }) async {
    print("PUT $path");
    await _sendRequest(true, _withRefresh(() => _put(path, args)));
    return;
  }

  Future<Response> _put(String path, dynamic args) async {
    final url = Uri.parse("$baseURL$path");
    var headers = buildHeaders(
      content: true,
      auth: true,
    );

    return _httpClient.put(url, body: jsonEncode(args), headers: headers);
  }

  Future<dynamic> multipartRequest(
      String method, String path, List<MultipartFile> files) async {
    print("$method $path");

    var response = await  _sendRequest(false, () => _multipartRequest(method, path, files));
    return _jsonDecode(response);
  }

  Future<Response> _multipartRequest(
      String method, String path, List<MultipartFile> files) async {
    final url = Uri.parse("$baseURL2$path");
    var req = MultipartRequest(method, url)..files.addAll(files);
    return await Response.fromStream(await _httpClient.send(req));
  }

  Future<Response> _sendRequest(
      bool refresh, Future<Response> Function() request) {
    return _withErrorHandling(
        _withOrWithoutRefresh(refresh, () => request()))();
  }

  Future<Response> Function() _withOrWithoutRefresh(
      bool refresh, Future<Response> Function() request) {
    if (refresh) {
      return _withRefresh(request);
    } else {
      return request;
    }
  }

  Future<Response> Function() _withRefresh(
      Future<Response> Function() request) {
    return () async {
      var response = await request();

      if (response.statusCode != 200) {
        await Auth.I.refresh();
        return request();
      }

      return response;
    };
  }

  Future<Response> Function() _withErrorHandling(
      Future<Response> Function() request) {
    return () async {
      var response = await request();

      if (response.statusCode == 404) {
        return null;
      }
      if (response.statusCode != 200) {
        throw APIErrors.fromResponse(response);
      }

      return response;
    };
  }

  _jsonDecode(Response response) {
    if (response == null) {
      return null;
    }

    if (response.body.isEmpty) {
      return null;
    }

    return jsonDecode(response.body);
  }
}
