import 'package:kakao_map_plugin_example/src/models/enroll_user.dart';
import 'package:kakao_map_plugin_example/src/models/location.dart';

class EnrollListDto {
  late int id;
  late String name;
  late String addr;
  late LocationDto location;
  late EnrollUserDto user;

  EnrollListDto({
    required this.id,
    required this.name,
    required this.addr,
    required this.location,
    required this.user,
  });

  factory EnrollListDto.fromMap(Map<String, dynamic> json) {
    return EnrollListDto(
      id: json["id"],
      name: json["name"],
      addr: json["addr"],
      location: LocationDto.fromMap(json["location"]),
      user: EnrollUserDto.fromMap(json["user"]),
    );
  }
}
