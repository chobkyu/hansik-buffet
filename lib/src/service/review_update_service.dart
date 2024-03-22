// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin_example/src/models/review_write.dart';

class ReviewUpdateService {
  Future<int> updateReview(
      ReviewCreate reviewUpdate, String token, int reviewId) async {
    try {
      String? baseUrl = dotenv.env['BASE_URL'];
      int id = reviewId;
      String auth = 'Bearer $token';
      Uri uri = Uri.parse('$baseUrl/review/update/$id');

      final response = await http.patch(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': auth
        },
        body: jsonEncode(
          <String, dynamic>{
            'review': reviewUpdate.detailReview,
            'star': reviewUpdate.userRating
          },
        ),
      );

      return response.statusCode;
    } catch (err) {
      print(err);
      throw Exception('error');
    }
  }
}
