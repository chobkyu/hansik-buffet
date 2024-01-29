// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:kakao_map_plugin_example/src/models/user_data.dart';
import 'package:http/http.dart' as http;

class GetUserData {
  Uri uri = Uri.parse("http://192.168.208.1:8080/users/userinfo");

  Future<UserData> getUserData(String token) async {
    String auth = 'Bearer $token';
    //header
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/josn',
      'Authorization': auth
    };

    final respone = await http.get(uri, headers: headers);

    final int statusCode = respone.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      //에러 처리 추가
      throw Exception(statusCode);
    }

    Map<String, dynamic> resBody = jsonDecode(utf8.decode(respone.bodyBytes));

    print(resBody['data']);

    UserData userData = UserData.fromMap(resBody['data']);

    return userData;
  }
}
