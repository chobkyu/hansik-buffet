// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin_example/src/models/user_data.dart';
import 'package:kakao_map_plugin_example/src/screen/login.dart';
import 'package:kakao_map_plugin_example/src/screen/update_myinfo.dart';
import 'package:kakao_map_plugin_example/src/service/get_userdata_service.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';
import 'package:kakao_map_plugin_example/src/widget/menu_div.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  static GetUserData getUserData = GetUserData();
  static const storage = FlutterSecureStorage();
  UserData userData = UserData(
    id: 0,
    userName: 'tq',
    userNickName: '',
    userId: '',
    userImgs: [],
  );

  @override
  void initState() {
    super.initState();
    try {
      getUser();
    } catch (err) {
      print(err);
    }
  }

  void getUser() async {
    String? token = await storage.read(key: 'token');
    print(token);
    try {
      userData = await getUserData.getUserData(token!);
      print(userData);
      setState(() {});
    } catch (err) {
      print(err.toString());
      await storage.delete(key: 'token');
      if (!mounted) return;
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
    }
  }

  //imgurl get
  String getImgUrl(List<dynamic> img) {
    if (img.isNotEmpty) {
      return img[0].toString();
    } else {
      return 'https://puda.s3.ap-northeast-2.amazonaws.com/client/U_nuVL__0tNfEPk8Eb9PXISEad-qOs4aOEI0u-Zclq928dHx835CxJjMk3HKzg4ieprrKff_42Th2Tao7yezAg.webp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(title: 'My Page'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Column(
              children: [
                const Text(
                  '회원 정보',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(getImgUrl(userData.userImgs)),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  userData.userNickName,
                  style: const TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [Icon(Icons.food_bank), Text('한식 뷔페 찾기')],
                    ),
                    Row(
                      children: [Icon(Icons.soup_kitchen), Text('내 정보 수정하기')],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Divider(thickness: 1.2),
              MenuDiv(
                text: '한식 뷔페 찾기',
                move: () {
                  print('object');
                },
              ),
              MenuDiv(
                text: '즐겨 찾는 한식 뷔페',
                move: () {
                  print('object');
                },
              ),
              MenuDiv(
                text: '메뉴 등록 하기',
                move: () {
                  print('object');
                },
              ),
              MenuDiv(
                text: '내 정보 수정하기',
                move: () {
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var begin = const Offset(0.0, 1.0);
                        var end = Offset.zero;
                        var curve = Curves.ease;
                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const UpdateMyInfo(),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      )),
    );
  }
}
