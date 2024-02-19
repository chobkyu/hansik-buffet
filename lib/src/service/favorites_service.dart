import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FavoriteService {
  Future<int> favoriteStar(int hansicId, String token) async {
    String? baseUrl = dotenv.env['TEST_URL'];
    Uri uri = Uri.parse("$baseUrl/hansic/star/$hansicId");
    String auth = 'Bearer $token';

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': auth
      },
    );

    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      //에러 처리 추가
      throw Exception(statusCode);
    }

    return statusCode;
  }
}
