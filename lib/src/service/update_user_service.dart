// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UpdateUserService {
  Future<dynamic> updateUser(String? userId, String? userPw, String? userName,
      String? userNickName, int? locationId, String token) async {
    String? baseUrl = dotenv.env['BASE_URL'];
    String auth = 'Bearer $token';

    Uri uri = Uri.parse("$baseUrl/users/info");

    final response = await http.patch(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': auth
      },
      body: jsonEncode(<String, dynamic>{
        'userId': userId,
        'userPw': userPw,
        'userName': userName,
        'userNickName': userNickName,
        'location_id': locationId
      }),
    );

    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      //에러 처리 추가
      throw Exception(statusCode);
    }
    print(response);

    return response;
  }
}
