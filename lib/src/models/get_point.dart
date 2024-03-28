class GetPointDto {
  late int point;
  late int randNum;

  GetPointDto({
    required this.point,
    required this.randNum,
  });

  factory GetPointDto.fromMap(Map<String, dynamic> json) {
    return GetPointDto(
      point: json["point"],
      randNum: json["randNum"],
    );
  }
}
