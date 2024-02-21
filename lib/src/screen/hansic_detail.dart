// ignore_for_file: avoid_print

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:kakao_map_plugin_example/src/models/hansic_data.dart';
import 'package:kakao_map_plugin_example/src/screen/login.dart';
import 'package:kakao_map_plugin_example/src/screen/review_list.dart';
import 'package:kakao_map_plugin_example/src/screen/review_write.dart';
import 'package:kakao_map_plugin_example/src/service/favorites_service.dart';
import 'package:kakao_map_plugin_example/src/service/get_hansicdata_service.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';

class HansicDetail extends StatefulWidget {
  const HansicDetail({super.key, required this.latLng});

  final LatLng latLng;

  @override
  State<HansicDetail> createState() => _HansicDetailState();
}

class _HansicDetailState extends State<HansicDetail> {
  static GetHansicService hansicService = GetHansicService();
  static FavoriteService favoriteService = FavoriteService();
  static const storage = FlutterSecureStorage();

  late HansicData hansicData = HansicData(
    id: 0,
    name: '한식 뷔페 이름',
    addr: '한식 뷔페 주소',
    userStar: '사용자 별점',
    googleStar: '구글별점',
    locationId: 0,
    lat: 0,
    lng: 0,
    location: '한식 뷔페 지역',
    imgUrl: '대표 이미지 url',
    count: 0,
    favorite: false,
  );

  @override
  void initState() {
    super.initState();
    try {
      getHansic();
    } catch (err) {
      print(err);
    }
  }

  //한식 뷔페 데이터 받아오기
  void getHansic() async {
    try {
      String? token = await storage.read(key: 'token');
      hansicData =
          await hansicService.getHansicDetailData(widget.latLng, token);
      print(hansicData);
      setState(() {});
    } catch (err) {
      print(err);
    }
  }

  String starToString(String star) {
    // ignore: unnecessary_null_comparison
    if (star == null) {
      return "0 (참여자 100)";
    } else {
      return "$star (참여자 100)";
    }
  }

  //즐겨찾기
  void postFavorite() async {
    try {
      String? token = await storage.read(key: 'token');

      int status = await favoriteService.favoriteStar(hansicData.id, token!);

      if (status == 201) {
        //즐겨찾기 추가
        getHansic();
      } else if (status == 401) {
        //유효하지 않은 토큰 및 비로그인 유저
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
      } else {
        //error 처리
      }
    } catch (err) {
      print('err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(title: '한식 뷔페'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 380,
                width: 320,
                child: ClipRRect(
                  child: Image.network(
                      'https://puda.s3.ap-northeast-2.amazonaws.com/client/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7+2024-02-07+151707.png'),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                hansicData.name,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '후기 ${hansicData.count}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    hansicData.googleStar,
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (hansicData.favorite)
                    IconButton(
                      onPressed: () {
                        print(hansicData.favorite);
                        postFavorite();
                      },
                      icon: const Icon(
                        Icons.favorite,
                        size: 30,
                        color: Colors.red,
                      ),
                    ),
                  if (!hansicData.favorite)
                    IconButton(
                      onPressed: () {
                        print(hansicData.favorite);
                        postFavorite();
                      },
                      icon: const Icon(
                        Icons.favorite_border,
                        size: 30,
                      ),
                    ),
                ],
              ),
              const Divider(
                thickness: 1.2,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 30,
                          color: Colors.amber[400],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            hansicData.addr,
                            style: const TextStyle(fontSize: 15),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 30,
                          color: Colors.amber[400],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          hansicData.userStar,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.reviews,
                          size: 30,
                          color: Colors.amber[400],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {},
                          child: InkWell(
                            onTap: () {
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
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      ReviewList(
                                    id: hansicData.id,
                                    hansicName: hansicData.name,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              '리뷰 보기 (참여자 25)',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.food_bank_rounded,
                          size: 30,
                          color: Colors.amber[400],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          '메뉴',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
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
                          ReviewWrite(
                        id: hansicData.id,
                        hansicName: hansicData.name,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                ),
                child: const Text(
                  '리뷰 작성하기',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
