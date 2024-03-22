import 'package:kakao_map_plugin_example/src/models/hansic_name.dart';
import 'package:kakao_map_plugin_example/src/models/image_data.dart';

class ReviewUserListDto {
  late int id;
  late String review;
  late double star;
  late HansicNameDto hansics;
  late List<ImgDataDto> reviewImgs;

  ReviewUserListDto({
    required this.id,
    required this.review,
    required this.star,
    required this.hansics,
    required this.reviewImgs,
  });

  factory ReviewUserListDto.fromMap(Map<String, dynamic> json) {
    return ReviewUserListDto(
      id: json["id"] ?? 0,
      review: json["review"] ?? "",
      star: json["star"].toDouble() ?? 0,
      hansics: HansicNameDto.fromMap(json['hansics']),
      reviewImgs: (json["reviewImgs"]
              .map<ImgDataDto>((i) => ImgDataDto.fromMap(i))
              .toList() ??
          []),
    );
  }
}
