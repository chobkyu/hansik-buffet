// ignore_for_file: avoid_print, duplicate_ignore

import 'dart:convert';

import 'package:kakao_map_plugin_example/src/models/LoginRes.dart';
import 'package:http/http.dart' as http;

class Login {
  Uri uri = Uri.parse("http://192.168.208.1:8080/users/login");

  Future<LoginRes> getToken(String userId, String userPw) async {
    print('object');
    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'userId': userId, 'userPw': userPw}),
    );
    // ignore: avoid_print
    //print(response.statusCode);
    Map<String, dynamic> resBody = jsonDecode(utf8.decode(response.bodyBytes));

    //print(resBody);
    if (response.statusCode != 201) {}

    LoginRes loginRes = LoginRes.fromMap(resBody);

    print(loginRes.token);
    return loginRes;
  }
}
