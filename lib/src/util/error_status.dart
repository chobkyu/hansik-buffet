import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin_example/src/screen/login.dart';
import 'package:kakao_map_plugin_example/src/widget/dialog_builder.dart';

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
        await DialogBuilder.dialogBuild(
          context: context,
          text: "권한이 없습니다.",
          needOneButton: true,
        );
        if (context.mounted) Navigator.pop(context);
        break;
      case "400":
        if (!mounted) return;
        await DialogBuilder.dialogBuild(
          context: context,
          text: "잘못된 요청입니다.",
          needOneButton: true,
        );
        if (context.mounted) Navigator.pop(context);
        break;
      case "404":
        if (!mounted) return;
        await DialogBuilder.dialogBuild(
          context: context,
          text: "페이지를 찾을 수 없습니다.",
          needOneButton: true,
        );
        if (context.mounted) Navigator.pop(context);
        break;
      case "500":
        if (!mounted) return;
        await DialogBuilder.dialogBuild(
          context: context,
          text: "내부 서버 오류!",
          needOneButton: true,
        );
        if (context.mounted) Navigator.pop(context);
        break;
    }
  }
}
