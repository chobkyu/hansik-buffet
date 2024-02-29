class FavoriteListDto {
  late String userId;
  late String userNickName;
  late List<dynamic> favorites;

  FavoriteListDto({
    required this.userId,
    required this.userNickName,
    required this.favorites,
  });

  factory FavoriteListDto.fromMap(Map<String, dynamic> json) {
    return FavoriteListDto(
      userId: json["userId"],
      userNickName: json["userNickName"],
      favorites: json["favorites"],
    );
  }
}
