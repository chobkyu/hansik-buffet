// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin_example/src/models/favorite_list.dart';
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
    } catch (err) {
      print("this is catch");
      print(err.toString());
      await storage.delete(key: 'token');
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: '즐겨 찾는 한식 뷔페')),
      body: SingleChildScrollView(),
    );
  }
}
