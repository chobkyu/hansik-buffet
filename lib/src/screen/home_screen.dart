// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin_example/src/overlay_12_markers_event1_screen.dart';
import 'package:kakao_map_plugin_example/src/screen/login.dart';
import 'package:kakao_map_plugin_example/src/screen/my_page.dart';
import 'package:kakao_map_plugin_example/src/screen/review_list.dart';
import 'package:kakao_map_plugin_example/src/service/geolocator_service.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';
import 'package:kakao_map_plugin_example/src/widget/home_button.dart';
// ignore: depend_on_referenced_packages
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const storage = FlutterSecureStorage();
  static GeolocatorService geolocatorService = GeolocatorService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(
          title: 'Hansajang',
        ),
      ),
      //body 바꿀거임 ㅇㅇ
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              HomeButton(
                text: 'login',
                move: () {
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
                          const LoginScreen(),
                    ),
                  );
                },
                color: Colors.amber,
              ),
              const SizedBox(
                height: 10,
              ),
              HomeButton(
                text: 'myPage',
                move: () async {
                  String? token = await storage.read(key: 'token');
                  print(token);
                  if (token == null) {
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
                            const LoginScreen(),
                      ),
                    );
                  } else {
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
                            const MyPage(),
                      ),
                    );
                  }
                },
                color: Colors.amber,
              ),
              const SizedBox(
                height: 10,
              ),
              HomeButton(
                text: 'logout',
                move: () {
                  const storage = FlutterSecureStorage();
                  storage.delete(key: 'token');
                },
                color: Colors.amber,
              ),
              const SizedBox(
                height: 10,
              ),
              HomeButton(
                text: '지도',
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
                          Overlay12MarkersEvent1Screen(lat: lat, lng: lng),
                    ),
                  );
                },
                color: Colors.amber,
              ),
              const SizedBox(
                height: 10,
              ),
              HomeButton(
                text: 'review list',
                move: () {
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
                          const ReviewList(),
                    ),
                  );
                },
                color: Colors.amber,
              ),
              // HomeButton(
              //   text: '한식 스크린',
              //   move: () {
              //     Navigator.push(
              //       context,
              //       PageRouteBuilder(
              //         transitionsBuilder:
              //             (context, animation, secondaryAnimation, child) {
              //           var begin = const Offset(0.0, 1.0);
              //           var end = Offset.zero;
              //           var curve = Curves.ease;
              //           var tween = Tween(begin: begin, end: end)
              //               .chain(CurveTween(curve: curve));
              //           return SlideTransition(
              //             position: animation.drive(tween),
              //             child: child,
              //           );
              //         },
              //         pageBuilder: (context, animation, secondaryAnimation) =>
              //             const HansicScreen(),
              //       ),
              //     );
              //   },
              //   color: Colors.amber,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
