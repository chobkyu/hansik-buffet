class ImgDataDto {
  late String imgUrl;

  ImgDataDto({
    required this.imgUrl,
  });

  factory ImgDataDto.fromMap(Map<String, dynamic> json) {
    return ImgDataDto(imgUrl: json["imgUrl"]);
  }
}
