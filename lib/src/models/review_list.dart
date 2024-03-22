import 'package:kakao_map_plugin_example/src/models/image_data.dart';
import 'package:kakao_map_plugin_example/src/models/review_user.dart';

class ReviewDto {
  late int id;
  late String review;
  late double star;
  late ReviewUserDto user;
  late List<dynamic> reviewComments;
  late List<ImgDataDto> reviewImg;

  ReviewDto({
    required this.id,
    required this.review,
    required this.star,
    required this.user,
    required this.reviewComments,
    required this.reviewImg,
  });

  factory ReviewDto.fromMap(Map<String, dynamic> json) {
    return ReviewDto(
      id: json["id"],
      review: json["review"],
      star: json["star"].toDouble(),
      user: ReviewUserDto.fromMap(json["user"]),
      reviewComments: json["reviewComments"],
      reviewImg: (json["reviewImgs"]
              .map<ImgDataDto>((i) => ImgDataDto.fromMap(i))
              .toList() ??
          []),
    );
  }
  // ReviewDto.fromMap(Map<String, dynamic> map) {
  //   id = map["id"];
  //   review = map["review"];
  //   star = map["star"].toDouble();
  //   user = ReviewUserDto.fromMap(map["user"]);
  //   reviewComments =
  //       map["reviewComments"]; //List<dynamic>.from(map["reviewComments"]);
  //   reviewImg = map["reviewImg"]; //List<dynamic>.from(map["reviewImg"]); //
  // }
}
