class HansicNameDto {
  late int id;
  late String name;

  HansicNameDto({
    required this.id,
    required this.name,
  });

  factory HansicNameDto.fromMap(Map<String, dynamic> json) {
    return HansicNameDto(
      id: json["id"],
      name: json["name"],
    );
  }
}
