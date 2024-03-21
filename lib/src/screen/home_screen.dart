// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin_example/src/overlay_12_markers_event1_screen.dart';
import 'package:kakao_map_plugin_example/src/screen/enroll_admin.dart';
import 'package:kakao_map_plugin_example/src/screen/hansic_enroll.dart';
import 'package:kakao_map_plugin_example/src/screen/img_upload.dart';
import 'package:kakao_map_plugin_example/src/screen/index_screen.dart';
import 'package:kakao_map_plugin_example/src/screen/login.dart';
import 'package:kakao_map_plugin_example/src/screen/my_page.dart';
import 'package:kakao_map_plugin_example/src/screen/review_list.dart';
import 'package:kakao_map_plugin_example/src/screen/review_write.dart';
import 'package:kakao_map_plugin_example/src/screen/test_home.dart';
import 'package:kakao_map_plugin_example/src/service/geolocator_service.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';
import 'package:kakao_map_plugin_example/src/widget/home_button.dart';
// ignore: depend_on_referenced_packages
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin_example/src/widget/dialog_builder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  static const storage = FlutterSecureStorage();
  static GeolocatorService geolocatorService = GeolocatorService();
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(
        () => setState(() => _selectedIndex = _tabController.index));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(
          title: _selectedIndex == 0
              ? '한사장'
              : _selectedIndex == 1
                  ? "Search"
                  : _selectedIndex == 2
                      ? "MyPage"
                      : "TestHome",
        ),
      ),
      //body 바꿀거임 ㅇㅇ
      body: _selectedIndex == 0
          ? const IndexScreen()
          : _selectedIndex == 1
              ? testContainer()
              : _selectedIndex == 2
                  ? const MyPage()
                  : testHome(),
      bottomNavigationBar: SizedBox(
        height: 90,
        child: TabBar(
          indicatorColor: Colors.amber[800],
          labelColor: Colors.black,
          controller: _tabController,
          tabs: [
            Tab(
              icon:
                  Icon(_selectedIndex == 0 ? Icons.home : Icons.home_outlined),
              text: "Home",
            ),
            const Tab(
              icon: Icon(Icons.search),
              text: "Search",
            ),
            Tab(
              icon: Icon(
                  _selectedIndex == 2 ? Icons.person : Icons.person_outline),
              text: "MyPage",
            ),
            Tab(
              icon: Icon(_selectedIndex == 3
                  ? Icons.directions_run
                  : Icons.directions_walk_outlined),
              text: "TestHome",
            ),
          ],
        ),
      ),
    );
  }

  Widget testContainer() {
    return Container(
      child: const Center(child: Text("hi")),
    );
  }

  // 기존에 있던 홈
  Widget testHome() {
    return SingleChildScrollView(
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
              text: '이미지',
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
                        const ImgUpload(),
                  ),
                );
              },
              color: Colors.amber,
            ),
            const SizedBox(
              height: 10,
            ),
            HomeButton(
              text: '홈 화면',
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
                        const IndexScreen(),
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
            HomeButton(
              text: 'test Review',
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
                          const ReviewList(id: 1804, hansicName: "알랄라"),
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
              text: 'test Review Write',
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
                          const ReviewWrite(id: 1804, hansicName: ""),
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
              text: '내가 아는 한뷔 등록',
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
                        const EnrollHansic(),
                  ),
                );
              },
              color: Colors.amber,
            ),
            const SizedBox(
              height: 10,
            ),
            HomeButton(
              text: '한뷔 등록 관리자 페이지',
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
                        const EnrollAdmin(),
                  ),
                );
              },
              color: Colors.amber,
            ),
            OutlinedButton(
              onPressed: () => {
                DialogBuilder.dialogBuild(
                  context: context,
                  text: "confirm?",
                  needOneButton: false,
                ),
              },
              child: const Text("two button"),
            ),
            const SizedBox(
              height: 10,
            ),
            OutlinedButton(
              onPressed: () => {
                DialogBuilder.dialogBuild(
                  context: context,
                  text: "error!",
                  needOneButton: true,
                ),
              },
              child: const Text("one button"),
            ),
            const SizedBox(
              height: 10,
            ),
            OutlinedButton(
              onPressed: () => {
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
                        const TestHome(),
                  ),
                )
              },
              child: const Text("one button"),
            ),
          ],
        ),
      ),
    );
  }
}
