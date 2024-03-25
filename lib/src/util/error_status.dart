import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin_example/src/screen/login.dart';

class ErrorStatus {
  static const storage = FlutterSecureStorage();

  void errStatus(String code, BuildContext context, bool mounted) async {
    switch (code) {
      case "401":
        await storage.delete(key: 'token');
        if (!mounted) return;
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(0.0, 1.0);
              var end = Offset.zero;
              var curve = Curves.ease;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LoginScreen(),
          ),
        );
        break;
      case "403":
        if (!mounted) return;
        Navigator.pop(context);
        break;
      case "400":
        break;
      case "500":
        break;
    }
  }
}
