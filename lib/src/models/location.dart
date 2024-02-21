class LocationDto {
  late int id;
  late String location;

  LocationDto({
    required this.id,
    required this.location,
  });

  factory LocationDto.fromMap(Map<String, dynamic> json) {
    return LocationDto(
      id: json["id"],
      location: json["location"],
    );
  }
}
