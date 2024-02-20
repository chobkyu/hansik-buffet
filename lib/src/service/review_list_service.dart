// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_map_plugin_example/src/models/review_list.dart';

class ReviewListService {
  Future<List<ReviewDto>> getReviewList(int id) async {
    try {
      String? baseUrl = dotenv.env['TEST_URL'];
      Uri uri = Uri.parse("$baseUrl/review/list/$id");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/josn',
      };

      final response = await http.get(uri, headers: headers);

      print(response.body);

      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        //에러 처리 추가
        throw Exception(statusCode);
      }

      //print(jsonDecode(utf8.decode(response.bodyBytes)));
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      List<ReviewDto> result = [];

      for (int i = 0; i < data.length; i++) {
        ReviewDto reviewDto = ReviewDto.fromMap(data[i]);
        result.add(reviewDto);
      }

      return result;
    } catch (err) {
      print(err);
      throw Exception('error');
    }
  }
}
