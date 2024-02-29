// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:kakao_map_plugin_example/src/models/favorite_list.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FavoriteListService {
  Future<FavoriteListDto> getFavoriteList(String? token) async {
    try {
      String? baseUrl = dotenv.env['BASE_URL'];
      Uri uri = Uri.parse("$baseUrl/hansic/star/user");

      String auth = 'Bearer $token';

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

      Map<String, dynamic> resBody =
          jsonDecode(utf8.decode(response.bodyBytes));
      print(resBody);
      FavoriteListDto favoriteListDto = FavoriteListDto.fromMap(resBody);
      //print(favoriteListDto);
      return favoriteListDto;
    } catch (err) {
      print(err);
      throw Exception('error at favorite list service');
    }
  }
}
