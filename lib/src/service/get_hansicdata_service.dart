// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:kakao_map_plugin_example/src/models/hansic_data.dart';
import 'package:http/http.dart' as http;

class GetHansicService {
  Future<List<HansicData>> getHansicData() async {
    Uri uri = Uri.parse("http://192.168.208.1:8080/hansic/all");

    final response = await http.get(uri);

    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      //에러 처리 추가
      throw Exception(statusCode);
    }

    Map<String, dynamic> data = json.decode(response.body);

    List<HansicData> result = [];

    for (int i = 0; i < data["data"].length; i++) {
      HansicData hansicData = HansicData.fromMap(data["data"][i]);
      result.add(hansicData);
    }

    print(result);
    return result;
  }

  //지역별 조회
  Future<List<HansicData>> getHansicDataFromLoc(int id) async {
    Uri uri = Uri.parse("http://192.168.208.1:8080/hansic/loc/$id");

    final response = await http.get(uri);

    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      //에러 처리 추가
      throw Exception(statusCode);
    }

    Map<String, dynamic> data = json.decode(response.body);

    List<HansicData> result = [];

    for (int i = 0; i < data["data"].length; i++) {
      HansicData hansicData = HansicData.fromMap(data["data"][i]);
      result.add(hansicData);
    }

    print(result);
    return result;
  }
}
