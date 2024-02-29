import 'package:kakao_map_plugin_example/src/models/favorite_hansic.dart';

class FavoritesDataDto {
  late int id;
  late int userId;
  late int hansicsId;
  late bool useFlag;
  late FavoriteHansicDto hansics;

  FavoritesDataDto({
    required this.id,
    required this.userId,
    required this.useFlag,
    required this.hansics,
  });

  factory FavoritesDataDto.fromMap(Map<String, dynamic> json) {
    return FavoritesDataDto(
      id: json["id"],
      userId: json["userId"],
      useFlag: json["useFlag"],
      hansics: json["hansics"],
    );
  }
}
