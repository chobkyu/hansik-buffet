import 'package:kakao_map_plugin_example/src/models/hansic_name.dart';
import 'package:kakao_map_plugin_example/src/models/image_data.dart';
import 'package:kakao_map_plugin_example/src/models/review_user.dart';

class ReviewUserListDto {
  late int id;
  late String review;
  late double star;
  late ReviewUserDto user;
  late List<dynamic> reviewComments;
  late HansicNameDto hansics;
  late List<ImgDataDto> reviewImgs;

  ReviewUserListDto({
    required this.id,
    required this.review,
    required this.star,
    required this.user,
    required this.reviewComments,
    required this.hansics,
    required this.reviewImgs,
  });

  factory ReviewUserListDto.fromMap(Map<String, dynamic> json) {
    return ReviewUserListDto(
      id: json["id"] ?? 0,
      review: json["review"] ?? "",
      star: json["star"].toDouble() ?? 0,
      user: ReviewUserDto.fromMap(json["user"]),
      reviewComments: json["reviewComments"] ?? [],
      hansics: HansicNameDto.fromMap(json['hansics']),
      reviewImgs: (json["reviewImgs"]
              .map<ImgDataDto>((i) => ImgDataDto.fromMap(i))
              .toList() ??
          []),
    );
  }
}
