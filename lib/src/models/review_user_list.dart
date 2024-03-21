import 'package:kakao_map_plugin_example/src/models/hansic_name.dart';
import 'package:kakao_map_plugin_example/src/models/image_data.dart';

class ReviewUserDto {
  late int id;
  late String review;
  late double star;
  late HansicNameDto hansics;
  late List<ImgDataDto> reviewImgs;

  ReviewUserDto({
    required this.id,
    required this.review,
    required this.star,
    required this.hansics,
    required this.reviewImgs,
  });

  factory ReviewUserDto.fromMap(Map<String, dynamic> json) {
    return ReviewUserDto(
      id: json["id"],
      review: json["review"],
      star: json["star"],
      hansics: HansicNameDto.fromMap(json['hansics']),
      reviewImgs: (json["reviewImgs"] ?? [])
          .map<ImgDataDto>((i) => ImgDataDto.fromMap(i))
          .toList(),
    );
  }
}
