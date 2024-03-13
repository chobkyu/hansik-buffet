// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin_example/src/models/enroll_hansic.dart';
import 'package:http/http.dart' as http;

class EnrollHansicService {
  Future<int> enrollHansic(
      EnrollHansicDto enrollHansicDto, String token) async {
    try {
      String? baseUrl = dotenv.env['TEST_URL'];
      String auth = 'Bearer $token';
      Uri uri = Uri.parse("$baseUrl/hansic/enroll");

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': auth
        },
        body: jsonEncode(<String, dynamic>{
          'name': enrollHansicDto.name,
          'addr': enrollHansicDto.addr,
          'location': enrollHansicDto.location,
          'imgUrl': "추가 예정"
        }),
      );

      return response.statusCode;
    } catch (err) {
      print(err);
      throw Exception('error');
    }
  }
}
