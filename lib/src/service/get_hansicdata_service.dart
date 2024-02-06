// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:kakao_map_plugin_example/src/models/hansic_data.dart';
import 'package:http/http.dart' as http;

class GetHansicService {
  Future<List<HansicData>> getHansicData() async {
    String? baseUrl = dotenv.env['BASE_URL'];
    Uri uri = Uri.parse("$baseUrl/hansic/loc/1");

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
    String? baseUrl = dotenv.env['BASE_URL'];

    Uri uri = Uri.parse("$baseUrl/hansic/loc/$id");

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

  Future<HansicData> getHansicDetailData(LatLng latlng) async {
    try {
      String? baseUrl = dotenv.env['BASE_URL'];

      double lat = latlng.latitude;
      double lng = latlng.longitude;

      print(latlng);

      Uri uri =
          Uri.parse("http://192.168.208.1:5000/hansic/place?lat=$lat&lng=$lng");
      final response = await http.get(uri);

      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        //에러 처리 추가
        throw Exception(statusCode);
      }

      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

      print(data);
      print(data["data"]);
      HansicData hansicData = HansicData.fromMap(data["data"]);

      List<HansicData> result = [];

      // for (int i = 0; i < data.length; i++) {
      //   HansicData hansicData = HansicData.fromMap(data["data"][i]);
      //   result.add(hansicData);
      // }

      print(result);
      return hansicData;
    } catch (err) {
      print(err);
      throw Exception('error');
    }
  }
}
