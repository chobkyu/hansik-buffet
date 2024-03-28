// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin_example/src/models/enroll_hansic.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_map_plugin_example/src/models/enroll_list.dart';

class EnrollHansicService {
  Future<int> enrollHansic(
      EnrollHansicDto enrollHansicDto, String token) async {
    try {
      String? baseUrl = dotenv.env['BASE_URL'];
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

  //enroll 리스트 조회
  Future<List<EnrollListDto>> getEnrollList(String token) async {
    try {
      String? baseUrl = dotenv.env['BASE_URL'];
      String auth = 'Bearer $token';
      Uri uri = Uri.parse("$baseUrl/admin/enroll");

      final response = await http.get(
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
      print(response.body);
      Map<String, dynamic> resBody =
          jsonDecode(utf8.decode(response.bodyBytes));
      //print(data);
      List<dynamic> data = resBody['data'];
      List<EnrollListDto> result = [];

      for (int i = 0; i < data.length; i++) {
        EnrollListDto enrollListDto = EnrollListDto.fromMap(data[i]);
        result.add(enrollListDto);
      }

      return result;
    } catch (err) {
      print(err.toString().split(': ')[1]);
      throw HttpException(err.toString());
    }
  }
}
