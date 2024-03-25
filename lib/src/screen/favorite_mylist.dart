// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:kakao_map_plugin_example/src/models/favorite_list.dart';
import 'package:kakao_map_plugin_example/src/models/favorites_data.dart';
import 'package:kakao_map_plugin_example/src/screen/hansic_detail.dart';
import 'package:kakao_map_plugin_example/src/screen/login.dart';
import 'package:kakao_map_plugin_example/src/service/favorites_list_service.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';

class FavoriteMyList extends StatefulWidget {
  const FavoriteMyList({super.key});

  @override
  State<FavoriteMyList> createState() => _FavoriteMyListState();
}

class _FavoriteMyListState extends State<FavoriteMyList> {
  static const storage = FlutterSecureStorage();
  static FavoriteListService favoriteListService = FavoriteListService();

  List<FavoritesDataDto> favorites = [];
  @override
  void initState() {
    super.initState();

    try {
      getFavoriteList();
    } catch (err) {
      print(err);
    }
  }

  bool isLoading = false;

  void getFavoriteList() async {
    try {
      String? token = await storage.read(key: 'token');
      print(token);
      //토큰이 없을 시 로그인 화면으로
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

      FavoriteListDto favoriteListDto =
          await favoriteListService.getFavoriteList(token);
      print('object');
      print(favoriteListDto.favorites[0].hansics.name);
      print(favoriteListDto.favorites.runtimeType);
      favorites = favoriteListDto.favorites;
      if (favorites.isNotEmpty) isLoading = true;
      // for (int i = 0; i < data.length; i++) {
      //   print(favoriteListDto.favorites[i]['id']);

      //   FavoritesDataDto test1 = FavoritesDataDto.fromMap(data[i]);

      //   favorites.add(test1);
      // }

      // // List<FavoritesDataDto> favorites = favoriteListDto.favorites;
      // print(favorites[0]);
      setState(() {});
    } catch (err) {
      print("this is catch");
      print(err.toString());
      //에러 처리 예정
      // await storage.delete(key: 'token');
      // if (!mounted) return;
      // Navigator.push(
      //   context,
      //   PageRouteBuilder(
      //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //       var begin = const Offset(0.0, 1.0);
      //       var end = Offset.zero;
      //       var curve = Curves.ease;
      //       var tween =
      //           Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      //       return SlideTransition(
      //         position: animation.drive(tween),
      //         child: child,
      //       );
      //     },
      //     pageBuilder: (context, animation, secondaryAnimation) =>
      //         const LoginScreen(),
      //   ),
      //);
    }
  }

  double getUserStar(String userStar) {
    print(userStar);
    if (userStar == "NULL") {
      return 0.0;
    } else {
      return double.parse(userStar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: favorites.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      height: 100,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 189, 189, 189),
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            SizedBox(
                              child: ClipRRect(
                                child: Image.network(
                                  'https://puda.s3.ap-northeast-2.amazonaws.com/client/2840159_2891102_2258.png',
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    LatLng latLng = LatLng(
                                        favorites[index].hansics.lat,
                                        favorites[index].hansics.lng);
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          var begin = const Offset(0.0, 1.0);
                                          var end = Offset.zero;
                                          var curve = Curves.ease;
                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));
                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            HansicDetail(
                                          latLng: latLng,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    favorites[index].hansics.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Text(
                                  favorites[index].hansics.googleStar,
                                ),
                                RatingBar.builder(
                                  initialRating: getUserStar(
                                      favorites[index].hansics.userStar),
                                  itemSize: 18,
                                  ignoreGestures: true,
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 0.5),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '즐겨찾는 한식뷔페가 없어요..',
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(
                    '좋아하는 한식뷔페를 즐겨찾기로 추가하세요!',
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
    );
  }
}
