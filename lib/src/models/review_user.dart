class ReviewUserDto {
  late int id;
  late String userNickName;

  ReviewUserDto({
    required this.id,
    required this.userNickName,
  });

  factory ReviewUserDto.fromMap(Map<String, dynamic> json) {
    return ReviewUserDto(
      id: json["id"],
      userNickName: json["userNickName"],
    );
  }
}
