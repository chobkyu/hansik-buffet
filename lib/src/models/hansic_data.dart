class HansicData {
  late int id;
  late String name;
  late String addr;
  late String userStar;
  late String googleStar;
  late int locationId;
  late double lat;
  late double lng;
  late String location;
  late String imgUrl;

  HansicData({
    required this.id,
    required this.name,
    required this.addr,
    required this.userStar,
    required this.googleStar,
    required this.locationId,
    required this.lat,
    required this.lng,
    required this.location,
    required this.imgUrl,
  });

  factory HansicData.fromMap(Map<String, dynamic> json) {
    return HansicData(
      id: json["id"],
      name: json["name"],
      addr: json["addr"],
      userStar: json["userStar"] ?? '0',
      googleStar: json["google_star"],
      locationId: json["location_id"],
      lat: json["lat"].toDouble(),
      lng: json["lng"].toDouble(),
      location: json["location"],
      imgUrl: json["imgUrl"] ?? '',
    );
  }
}
