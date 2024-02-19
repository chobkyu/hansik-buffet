import 'package:kakao_map_plugin_example/src/models/user_data.dart';

class ReviewDto {
  late int id;
  late String review;
  late double star;
  late UserData user;
  late List<dynamic> reviewCommnets;
  late List<dynamic> reviewImg;

  ReviewDto({
    required this.id,
    required this.review,
    required this.star,
    required this.user,
    required this.reviewCommnets,
    required this.reviewImg,
  });

  ReviewDto.fromMap(Map<String, dynamic>? map) {
    id = map?["id"];
    review = map?["review"];
    star = map?["star"];
    user = map?["user"];
    reviewCommnets = map?["reviewCommnets"];
    reviewImg = map?["reviewImg"];
  }
}
