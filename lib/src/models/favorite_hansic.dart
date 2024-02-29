class FavoriteHansicDto {
  late String name;
  late String addr;
  late String googleStar;
  late double userStar;
  late int id;
  late dynamic location;
  late int locationId;
  late List<dynamic> sicdangImgs;

  FavoriteHansicDto({
    required this.name,
    required this.addr,
    required this.googleStar,
    required this.userStar,
    required this.id,
    required this.location,
    required this.locationId,
    required this.sicdangImgs,
  });

  factory FavoriteHansicDto.fromMap(Map<String, dynamic> json) {
    return FavoriteHansicDto(
      name: json["name"],
      addr: json["addr"],
      googleStar: json["google_star"],
      userStar: json["userStar"],
      id: json["id"],
      location: json["location"],
      locationId: json["location_id"],
      sicdangImgs: json["sicdangImgs"],
    );
  }
}
