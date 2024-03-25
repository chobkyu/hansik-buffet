// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:kakao_map_plugin_example/src/screen/home_screen.dart';
//import 'package:kakao_map_plugin_example/src/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await dotenv.load(fileName: 'assets/env/.env');

  /// 라이브러리 메모리에 appKey 등록
  /// 지도가 호출되기 전에만 세팅해 주면 됩니다.
  await dotenv.load(fileName: 'assets/env/.env');
  String? appKey = dotenv.env['APP_KEY'].toString();
  print(appKey);
  AuthRepository.initialize(appKey: appKey);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late DateTime _lastPressedAt;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //여기는 조금 더 봐야됨
      onWillPop: () async {
        final now = DateTime.now();
        if (now.difference(_lastPressedAt) > const Duration(seconds: 2)) {
          _lastPressedAt = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('한번 더 뒤로가기를 누를 시 종료됩니다'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus(); // 키보드 닫기 이벤트
        },
        child: MaterialApp(
          theme: ThemeData(fontFamily: 'hangul'),
          home: const Scaffold(
            body: HomeScreen(),
          ),
        ),
      ),
    );
  }
}


/*todo
-공통
에러 처리
하단바 정리

-user





-review
리뷰 리스트 페이지 ui
리뷰 상세 보기 페이지 ui 및 이미지 업로드
댓글 기능

-owner
사업자 회원가입 페이지
메뉴 업로드 하기 페이지
사업자 메뉴 페이지

*/