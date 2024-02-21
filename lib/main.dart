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
  /// dotEnv 대신 appKey 를 직접 넣어주셔도 됩니다.
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus(); // 키보드 닫기 이벤트
      },
      child: const MaterialApp(
        home: Scaffold(
          body: HomeScreen(),
        ),
      ),
    );
  }
}


/*todo
-공통
사진 업로드
에러 처리

-user
프로필 사진 변경
즐겨찾기 한뷔 페이지
오늘 먹은 메뉴 등록하기


-hansic
즐겨찾기 ui
별점 주기
location list 가져오기

-review
리뷰 리스트 페이지
리뷰 상세 보기 페이지

-owner
사업자 회원가입 페이지
메뉴 업로드 하기 페이지
사업자 메뉴 페이지

*/