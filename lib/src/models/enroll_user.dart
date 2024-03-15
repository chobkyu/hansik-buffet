class EnrollUserDto {
  late int id;
  late String userName;
  late String userNickName;
  late String userId;

  EnrollUserDto({
    required this.id,
    required this.userName,
    required this.userNickName,
    required this.userId,
  });

  factory EnrollUserDto.fromMap(Map<String, dynamic> json) {
    return EnrollUserDto(
      id: json["id"],
      userName: json["userName"],
      userNickName: json["userNickName"],
      userId: json["userId"],
    );
  }
}
