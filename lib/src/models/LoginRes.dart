class LoginRes {
  late bool success;
  late int status;
  late String token;

  LoginRes({
    required this.success,
    required this.status,
    required this.token,
  });

  LoginRes.fromMap(Map<String, dynamic>? map) {
    success = map?['success'];
    status = map?['status'];
    token = map?['token'] ?? '';
  }
}
