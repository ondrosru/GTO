import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:gtoserviceapp/services/api/api.dart';
import 'package:gtoserviceapp/services/api/routes.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

class FindFaceResponse {
  int statusCode;
  int userId;
  String description;

  FindFaceResponse({this.statusCode, this.userId, this.description});

  FindFaceResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    userId = json['user_id'] != null ? int.tryParse(json['user_id']) : null;
    description = json['user_id'] != null ? json['description'] : null;
  }
}

class PhotoRepo {
  static PhotoRepo get I {
    return GetIt.I.get<PhotoRepo>();
  }

  Future<Uint8List> get(int userId) async {
    try {
      return await API.I.getRaw(Routes.GetUserPhoto.withArgs(userId: userId));
    } catch (e) {
      if (!e.toString().contains("Для user_id нет записи с фотографией в БД")) {
        print(e.toString());
      }

      return null;
    }
  }

  Future<void> add(int userId, Uint8List photo) async {
    try {
      await delete(userId);
    } catch (e) {
      print(e.toString());
    }

    var file = MultipartFile.fromBytes(
      "image",
      photo,
      filename: "image.jpg",
      contentType: MediaType.parse("image/jpeg"),
    );
    await API.I.multipartRequest(
      "POST",
      Routes.AddUserPhoto.withArgs(userId: userId),
      [file],
    );
  }

  Future<int> findFace(Uint8List photo) async {
    var file = MultipartFile.fromBytes(
      "image",
      photo,
      filename: "image.jpg",
      contentType: MediaType.parse("image/jpeg"),
    );

    var json = await API.I.multipartRequest(
      "GET",
      Routes.FindFaceOnPhoto.toStr(),
      [file],
    );

    var resp = FindFaceResponse.fromJson(json);
    return resp.userId;
  }

  Future<void> delete(int userId) async {
    return API.I.delete2(Routes.DeleteUserPhoto.withArgs(userId: userId));
  }
}
