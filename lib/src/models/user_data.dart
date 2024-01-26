import 'dart:ffi';

class UserData {
  late int id;
  late String userName;
  late String userNickName;
  late String userId;
  late Array userImgs;

  UserData({
    required this.id,
    required this.userName,
    required this.userNickName,
    required this.userId,
    required this.userImgs,
  });

  UserData.fromMap(Map<String, dynamic>? map) {
    id = map?['id'];
    userName = map?['userName'];
    userNickName = map?['userNickName'];
    userId = map?['userId'];
    userImgs = map?['userImgs'];
  }
}
