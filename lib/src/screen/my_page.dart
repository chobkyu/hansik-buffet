// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin_example/src/models/user_data.dart';
import 'package:kakao_map_plugin_example/src/screen/login.dart';
import 'package:kakao_map_plugin_example/src/service/get_userdata_service.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  static GetUserData getUserData = GetUserData();
  static const storage = FlutterSecureStorage();
  Future<UserData>? userData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      getUser();
    } catch (err) {
      print(err);
    }
  }

  void getUser() async {
    String? token = await storage.read(key: 'token');

    try {
      userData = (await getUserData.getUserData(token!)) as Future<UserData>?;
      print(userData);
    } catch (err) {
      print(err);
    }

    // print(data);

    // // 토큰 만료 혹은 로그인이 안되어있을 시
    // if (data == 401) {
    //   await storage.delete(key: 'token');
    //   if (!mounted) return;
    //   Navigator.push(
    //     context,
    //     PageRouteBuilder(
    //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //         var begin = const Offset(0.0, 1.0);
    //         var end = Offset.zero;
    //         var curve = Curves.ease;
    //         var tween =
    //             Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    //         return SlideTransition(
    //           position: animation.drive(tween),
    //           child: child,
    //         );
    //       },
    //       pageBuilder: (context, animation, secondaryAnimation) =>
    //           const LoginScreen(),
    //     ),
    //   );
    // }
    // print('hyesun anal is so good');
    // print(data);
    // userData = data;
    //   userData = UserData.fromMap(data as Map<String, dynamic>?);
    //   print(userData);
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
            FutureBuilder<UserData>(
              //통신데이터 가져오기
              future: userData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return buildColumn(snapshot);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}에러!!");
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildColumn(snapshot) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text('고객번호:${snapshot.data!.id}', style: const TextStyle(fontSize: 20)),
      Text('고객명:${snapshot.data!.userName}',
          style: const TextStyle(fontSize: 20)),
      Text('계좌 아이디:${snapshot.data!.account}',
          style: const TextStyle(fontSize: 20)),
      Text('잔액:${snapshot.data!.balance}원',
          style: const TextStyle(fontSize: 20)),
    ],
  );
}
