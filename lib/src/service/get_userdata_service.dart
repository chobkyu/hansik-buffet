// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin_example/src/models/user_data.dart';
import 'package:http/http.dart' as http;

class GetUserData {
  String? baseUrl = dotenv.env['BASE_URL'];

  Future<UserData> getUserData(String token) async {
    Uri uri = Uri.parse("$baseUrl/users/userinfo");

    String auth = 'Bearer $token';
    //header
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/josn',
      'Authorization': auth
    };

    final response = await http.get(uri, headers: headers);

    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      //에러 처리 추가
      throw Exception(statusCode);
    }

    Map<String, dynamic> resBody = jsonDecode(utf8.decode(response.bodyBytes));

    print(resBody['data']);

    UserData userData = UserData.fromMap(resBody['data']);

    return userData;
  }
}
