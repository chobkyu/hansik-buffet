class FavoriteHansicDto {
  late String name;
  late String addr;
  late String googleStar;
  late String userStar;
  late int id;
  late double lat;
  late double lng;
  late dynamic location;
  late int locationId;
  late List<dynamic> sicdangImgs;

  FavoriteHansicDto({
    required this.name,
    required this.addr,
    required this.googleStar,
    required this.userStar,
    required this.id,
    required this.lat,
    required this.lng,
    required this.location,
    required this.locationId,
    required this.sicdangImgs,
  });

  factory FavoriteHansicDto.fromMap(Map<String, dynamic> json) {
    return FavoriteHansicDto(
      name: json["name"],
      addr: json["addr"],
      googleStar: json["google_star"],
      userStar: json["userStar"] ?? '0',
      id: json["id"],
      lat: json["lat"].toDouble(),
      lng: json["lng"].toDouble(),
      location: json["location"],
      locationId: json["location_id"],
      sicdangImgs: json["sicdangImgs"],
    );
  }
}
