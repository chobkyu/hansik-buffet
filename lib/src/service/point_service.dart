// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin_example/src/models/get_point.dart';

class PointService {
  Future<GetPointDto> getPoint(String token) async {
    try {
      String? baseUrl = dotenv.env['BASE_URL'];
      String auth = 'Bearer $token';
      Uri uri = Uri.parse("$baseUrl/point");

      final response = await http.patch(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': auth,
        },
      );

      final int statusCode = response.statusCode;
      print(statusCode);
      if (statusCode < 200 || statusCode > 400) {
        //에러 처리 추가
        throw Exception(statusCode);
      }
      dynamic data = jsonDecode(utf8.decode(response.bodyBytes));
      GetPointDto getPointDto = GetPointDto.fromMap(data);

      return getPointDto;
    } catch (err) {
      print(err.toString().split(': ')[1]);
      throw HttpException(err.toString());
    }
  }
}
