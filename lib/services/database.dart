import 'dart:convert';

import 'package:akyam/models/user.dart';
import 'package:akyam/services/server_response.dart';
import 'package:http/http.dart' as http;

class Auth {
  static Future<ServerResponse> login(String email, String password) async {
    ServerResponseType srt;
    Uri url = Uri.parse("https://akyam.herokuapp.com/api/auth/login");
    Map<String, String> customHeaders = {"content-type": "application/json"};

    Map body = {
      "email": email,
      "password": password,
    };

    var bodyJ = jsonEncode(body);
    try {
      var response = await http.post(url, headers: customHeaders, body: bodyJ);
      if (response.statusCode == 200) {
        srt = ServerResponseType.serverResponseSuccess;
        User user = User.fromMap(jsonDecode(response.body));
        return ServerResponse(
            type: srt, data: user, statusCode: response.statusCode);
      } else if (response.statusCode == 400 || response.statusCode == 403) {
        srt = ServerResponseType.serverResponseClientError;
        return ServerResponse(
            type: srt, data: response.body, statusCode: response.statusCode);
      }
    } catch (e) {
      print(e);
    }
    return ServerResponse(
        type: ServerResponseType.serverResponseError,
        data: {"msg": "Some error has occured"},
        statusCode: 500);
  }

  static Future<ServerResponse> register(
      {required String username,
      required String email,
      required String password}) async {
    ServerResponseType srt;
    Uri url = Uri.parse("https://akyam.herokuapp.com/api/auth/register");
    Map<String, String> customHeaders = {"content-type": "application/json"};

    Map body = {"email": email, "password": password, "username": username};

    var bodyJ = jsonEncode(body);
    try {
      var response = await http.post(url, headers: customHeaders, body: bodyJ);
      if (response.statusCode == 200) {
        srt = ServerResponseType.serverResponseSuccess;
        User user = User.fromMap(jsonDecode(response.body));
        return ServerResponse(
            type: srt, data: user, statusCode: response.statusCode);
      } else if (response.statusCode == 400 || response.statusCode == 403) {
        srt = ServerResponseType.serverResponseClientError;
        return ServerResponse(
            type: srt, data: response.body, statusCode: response.statusCode);
      }
    } catch (e) {
      print(e);
    }

    return ServerResponse(
        type: ServerResponseType.serverResponseError,
        data: {"msg": "Some error has occured!"},
        statusCode: 500);
  }
}
