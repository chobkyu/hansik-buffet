// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin_example/src/models/login_res.dart';
import 'package:http/http.dart' as http;

class SignUpService {
  Future<LoginRes> signUp(
    String userId,
    String userPw,
    String userName,
    String userNickName,
  ) async {
    String? baseUrl = dotenv.env['BASE_URL'];

    Uri uri = Uri.parse("$baseUrl/users");

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': userId,
        'userPw': userPw,
        'userName': userName,
        'userNickName': userNickName
      }),
    );

    print(response.body);

    Map<String, dynamic> resBody = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != 201) {
      //에러 처리 추가 예정
      throw Exception(response.statusCode);
    }

    LoginRes loginRes = LoginRes.fromMap(resBody);

    print(loginRes);
    return loginRes;
  }
}
