// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:kakao_map_plugin_example/src/models/hansic_data.dart';
import 'package:http/http.dart' as http;

class GetHansicService {
  Uri uri = Uri.parse("http://192.168.208.1:8080/hansic/all");

  Future<List<HansicData>> getHansicData() async {
    final response = await http.get(uri);

    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      //에러 처리 추가
      throw Exception(statusCode);
    }

    Map<String, dynamic> data = json.decode(response.body);
    print(data["data"]);
    print(data["data"].length);
    print(data["data"][0]);
    print(data["data"][1000]);

    List<HansicData> result = [];

    for (int i = 0; i < data["data"].length; i++) {
      HansicData hansicData = HansicData.fromMap(data["data"][i]);
      result.add(hansicData);
    }

    print(result);
    return result;
  }
}
