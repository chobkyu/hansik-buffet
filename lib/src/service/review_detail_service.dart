// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:kakao_map_plugin_example/src/models/review_list.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReviewDetailService {
  Future<ReviewDto> getReview(int id) async {
    try {
      String? baseUrl = dotenv.env['BASE_URL'];
      Uri uri = Uri.parse("$baseUrl/review/$id");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/josn',
      };

      final response = await http.get(uri, headers: headers);
      dynamic data = jsonDecode(utf8.decode(response.bodyBytes));
      ReviewDto reviewDto = ReviewDto.fromMap(data);

      return reviewDto;
    } catch (err) {
      print(err);
      throw Exception('error');
    }
  }
}
