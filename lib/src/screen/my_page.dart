// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin_example/src/models/user_data.dart';
import 'package:kakao_map_plugin_example/src/overlay_12_markers_event1_screen.dart';
import 'package:kakao_map_plugin_example/src/screen/favorite_mylist.dart';
import 'package:kakao_map_plugin_example/src/screen/home_screen.dart';
import 'package:kakao_map_plugin_example/src/screen/login.dart';
import 'package:kakao_map_plugin_example/src/screen/update_myinfo.dart';
import 'package:kakao_map_plugin_example/src/service/geolocator_service.dart';
import 'package:kakao_map_plugin_example/src/service/get_userdata_service.dart';
import 'package:kakao_map_plugin_example/src/widget/dialog_builder.dart';
import 'package:kakao_map_plugin_example/src/widget/menu_div.dart';
// ignore: depend_on_referenced_packages
import 'package:geolocator/geolocator.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  static GetUserData getUserData = GetUserData();
  static const storage = FlutterSecureStorage();
  static GeolocatorService geolocatorService = GeolocatorService();
  bool _isLogined = false;

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
      print("this is initState");
      print(userData);
    } catch (err) {
      print(err);
    }
  }

  void getUser() async {
    print("this is getUser");
    String? token = await storage.read(key: 'token');
    print(token);
    try {
      print("this is try");
      userData = await getUserData.getUserData(token!);
      print("I want userData");
      print(userData);
      _isLogined = true;
      setState(() {});
    } catch (err) {
      print("this is catch");
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
  dynamic getImg(List<dynamic> img) {
    if (img.isNotEmpty) {
      return Image.network(img[0].toString());
    } else {
      return Image.asset('assets/images/defaultProfileImg.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLogined ? logined() : notLogined(),
    );
  }

  Widget notLogined() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[800],
              foregroundColor: Colors.white,
            ),
            onPressed: getUser,
            child: const Text("Login"),
          ),
          const Text("Please Login.."),
        ],
      ),
    );
  }

  Widget logined() {
    return SingleChildScrollView(
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
                    child: getImg(userData.userImgs),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.food_bank),
                        InkWell(
                          onTap: () async {
                            Position position =
                                await geolocatorService.getLocation();
                            double lat = position.latitude;
                            double lng = position.longitude;

                            print(lat);
                            print(lng);
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
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
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        Overlay12MarkersEvent1Screen(
                                  lat: lat,
                                  lng: lng,
                                ),
                              ),
                            );
                          },
                          child: const Text('한식 뷔페 찾기'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.soup_kitchen),
                        InkWell(
                          onTap: () {
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
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
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const UpdateMyInfo(),
                              ),
                            );
                          },
                          child: const Text('내 정보 수정하기'),
                        ),
                      ],
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
                fontSize: 18,
                move: () async {
                  Position position = await geolocatorService.getLocation();
                  double lat = position.latitude;
                  double lng = position.longitude;

                  print(lat);
                  print(lng);
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
                          Overlay12MarkersEvent1Screen(
                        lat: lat,
                        lng: lng,
                      ),
                    ),
                  );
                },
              ),
              MenuDiv(
                text: '즐겨 찾는 한식 뷔페',
                fontSize: 18,
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
                          const FavoriteMyList(),
                    ),
                  );
                },
              ),
              MenuDiv(
                text: '메뉴 등록 하기',
                fontSize: 18,
                move: () {
                  print('object');
                },
              ),
              MenuDiv(
                text: '내 정보 수정하기',
                fontSize: 18,
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
              MenuDiv(
                text: '로그아웃 하기',
                fontSize: 18,
                move: () {
                  DialogBuilder.dialogBuild(
                      context: context,
                      text: '로그아웃 하시겠습니까?',
                      needOneButton: false,
                      move: () {
                        const storage = FlutterSecureStorage();
                        storage.delete(key: 'token');
                        _isLogined = false;
                        setState(() {});
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (route) => false);
                      });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
