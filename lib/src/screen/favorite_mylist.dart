// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin_example/src/models/favorite_list.dart';
import 'package:kakao_map_plugin_example/src/models/favorites_data.dart';
import 'package:kakao_map_plugin_example/src/screen/home_screen.dart';
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

  void getFavoriteList() async {
    try {
      String? token = await storage.read(key: 'token');

      FavoriteListDto favoriteListDto =
          await favoriteListService.getFavoriteList(token);
      print('object');
      print(favoriteListDto.favorites[0].hansics.name);
      print(favoriteListDto.favorites.runtimeType);
      favorites = favoriteListDto.favorites;
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
      // Navigator.pop(context);
    }
  }

  // String getDataTest(hansics) {

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: '즐겨 찾는 한식 뷔페')),
      body: ListView.builder(
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
                    child: Row(children: [
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
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Text(
                              favorites[index].hansics.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: favorites[index].hansics.userStar,
                            itemSize: 18,
                            ignoreGestures: true,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 0.5),
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
                    ]),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
