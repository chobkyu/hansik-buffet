// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:kakao_map_plugin_example/src/models/review_write.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReviewWriteService {
  Future<int> writeReview(
      ReviewCreate reviewWrite, String token, String imgUrl) async {
    try {
      String? baseUrl = dotenv.env['BASE_URL'];
      int id = reviewWrite.id;
      String auth = 'Bearer $token';
      Uri uri = Uri.parse("$baseUrl/review/$id");

      String body;

      if (imgUrl == '') {
        body = jsonEncode(
          <String, dynamic>{
            'review': reviewWrite.detailReview,
            'star': reviewWrite.userRating
          },
        );
      } else {
        body = jsonEncode(
          <String, dynamic>{
            'review': reviewWrite.detailReview,
            'star': reviewWrite.userRating,
            'img': imgUrl,
          },
        );
      }

      print(body);

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': auth
        },
        body: body,
      );

      // Map<String, dynamic> resBody = jsonDecode(utf8.decode(response.bodyBytes));

      return response.statusCode;
    } catch (err) {
      print(err);
      throw Exception('error');
    }
  }
}
