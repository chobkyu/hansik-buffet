// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin_example/src/models/review_user_list.dart';
import 'package:kakao_map_plugin_example/src/service/review_list_service.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';

class ReviewUserList extends StatefulWidget {
  const ReviewUserList({super.key});

  @override
  State<ReviewUserList> createState() => _ReviewUserListState();
}

class _ReviewUserListState extends State<ReviewUserList> {
  static ReviewListService reviewListService = ReviewListService();
  static const storage = FlutterSecureStorage();

  List<ReviewUserListDto> reviewList = [];

  @override
  void initState() {
    super.initState();
    try {
      getReviewData();
    } catch (err) {
      print(err);
    }
  }

  void getReviewData() async {
    try {
      String? token = await storage.read(key: 'token');
      if (token == null) {
        //go to login page
      }
      reviewList = await reviewListService.getUserReviewList(token!);
      print(reviewList.length);
      setState(() {});
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(title: '마이 리뷰'),
        ),
        body: Text('data'));
  }
}
