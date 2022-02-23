import 'dart:convert';
import 'dart:developer';
import 'package:akyam/models/post.dart';
import 'package:akyam/models/user.dart';
import 'package:akyam/models/server_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Auth {
  static const storage = FlutterSecureStorage();

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
        User user = User.fromMap(jsonDecode(response.body),
            response.headers['auth_token'].toString());
        await storage.write(key: "authToken", value: user.authToken);
        await storage.write(
            key: "refresh_token", value: response.headers['refresh_token']);
        return ServerResponse(
            type: srt, data: user, statusCode: response.statusCode);
      } else if (response.statusCode == 400 || response.statusCode == 403) {
        srt = ServerResponseType.serverResponseClientError;
        return ServerResponse(
            type: srt, data: response.body, statusCode: response.statusCode);
      }
    } catch (e) {
      log(e.toString());
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
        return ServerResponse(
            type: srt,
            data: {"msg": "Registered successfully! Please login."},
            statusCode: response.statusCode);
      } else if (response.statusCode == 400 || response.statusCode == 403) {
        srt = ServerResponseType.serverResponseClientError;
        return ServerResponse(
            type: srt, data: response.body, statusCode: response.statusCode);
      }
    } catch (e) {
      log(e.toString());
    }

    return ServerResponse(
        type: ServerResponseType.serverResponseError,
        data: {"msg": "Some error has occured!"},
        statusCode: 500);
  }

  static Future<ServerResponse> verify(
      {required String authToken, required String refreshToken}) async {
    Uri url = Uri.parse("https://akyam.herokuapp.com/api/auth/verify");

    Map<String, String> customHeaders = {
      "content-type": "application/json",
      "auth_token": authToken
    };

    try {
      var response = await http.post(url, headers: customHeaders);
      if (response.statusCode == 200) {
        return ServerResponse(
            type: ServerResponseType.serverResponseSuccess,
            data: {"msg": "Access granted"},
            statusCode: response.statusCode);
      } else if (response.statusCode == 401 ||
          response.statusCode == 400 ||
          response.statusCode == 403) {
        return await renewToken(refreshToken);
      }
    } catch (e) {
      log("Verify" + e.toString());
    }

    return ServerResponse(
        type: ServerResponseType.serverResponseError,
        data: {"msg": "something has gone wrong!"},
        statusCode: 500);
  }

  static Future<ServerResponse> renewToken(String refreshToken) async {
    Uri url = Uri.parse("https://akyam.herokuapp.com/api/auth/token");

    Map<String, String> customHeaders = {
      "content-type": "application/json",
      "refresh_token": refreshToken
    };

    try {
      var response = await http.post(url, headers: customHeaders);
      if (response.statusCode == 200) {
        await storage.write(
            key: 'authToken', value: response.headers['auth_token'].toString());
        return ServerResponse(
            type: ServerResponseType.serverResponseSuccess,
            data: User.fromMap(
                jsonDecode(response.body), response.headers['auth_token']!),
            statusCode: response.statusCode);
      } else if (response.statusCode == 401 ||
          response.statusCode == 400 ||
          response.statusCode == 403) {
        return ServerResponse(
            type: ServerResponseType.serverResponseError,
            data: {response.body},
            statusCode: response.statusCode);
      }
    } catch (e) {
      log("Refresh" + e.toString());
    }

    return ServerResponse(
        type: ServerResponseType.serverResponseError,
        data: {"msg": "something has gone wrong!"},
        statusCode: 500);
  }
}

class PostDB {
  static Future<ServerResponse?> getPosts(
      {required List<String> ids, required String auth_token}) async {
    Uri url = Uri.parse("https://akyam.herokuapp.com/api/posts/feed");

    Map<String, String> customHeaders = {
      "content-type": "application/json",
      'Authorization': 'Bearer $auth_token',
    };

    var body = jsonEncode({"ids": ids});

    try {
      var response = await http.post(url, headers: customHeaders, body: body);
      if (response.statusCode == 200) {
        List<Map> postsJson = List.from(jsonDecode(response.body) as List);
        List<Post> posts = [];
        for (Map postJson in postsJson) {
          posts.add(Post.fromMap(postJson));
        }
        return ServerResponse(
            type: ServerResponseType.serverResponseSuccess,
            data: posts,
            statusCode: response.statusCode);
      } else if (response.statusCode == 401 ||
          response.statusCode == 400 ||
          response.statusCode == 403) {
        return ServerResponse(
            type: ServerResponseType.serverResponseError,
            data: {response.body},
            statusCode: response.statusCode);
      }
    } catch (e) {
      log("Post Feed" + e.toString());
    }

    return null;
  }
}
