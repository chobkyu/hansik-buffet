//import 'package:kakao_map_plugin_example/src/models/image_data.dart';

class UserData {
  late int id;
  late String userName;
  late String userNickName;
  late String userId;
  late List<dynamic> userImgs;

  UserData({
    required this.id,
    required this.userName,
    required this.userNickName,
    required this.userId,
    required this.userImgs,
  });

  factory UserData.fromMap(Map<String, dynamic> json) {
    return UserData(
      id: json["id"],
      userName: json["userName"],
      userNickName: json["userNickName"],
      userId: json["userId"],
      userImgs: json["userImgs"],
    );
  }
}
