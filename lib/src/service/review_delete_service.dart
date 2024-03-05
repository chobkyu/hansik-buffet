import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin_example/src/models/user_data.dart';

class ReviewDeleteService {
  Future<int> deleteReview(
    String token,
    int reviewId,
    UserData userData,
  ) async {
    try {
      String? baseUrl = dotenv.env['BASE_URL'];
      int id = reviewId;
      String auth = 'Bearer $token';
      Uri uri = Uri.parse('$baseUrl/review/$id');
      print('this is service');
      print(uri);
      print(userData.runtimeType);

      final response = await http.delete(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': auth
        },
        body: jsonEncode(
          <String, dynamic>{
            "userData": {
              "id": userData.id,
            }
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
