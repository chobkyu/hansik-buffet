// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin_example/src/models/review_list.dart';
import 'package:kakao_map_plugin_example/src/models/review_user_list.dart';
import 'package:kakao_map_plugin_example/src/screen/login.dart';
import 'package:kakao_map_plugin_example/src/screen/review_detail.dart';
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

  bool isLoading = false;

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
      reviewList = await reviewListService.getUserReviewList(token!);
      if (reviewList.isNotEmpty) isLoading = true;
      print(reviewList[0].reviewImgs);
      setState(() {});
    } catch (err) {
      print(err);
    }
  }

  dynamic getImg(List<dynamic> reviewImgs) {
    if (reviewImgs.isNotEmpty) {
      return Image.network(reviewImgs[0].imgUrl);
    } else {
      return Image.asset('assets/images/defaultReviewImg.png');
    }
  }

  void goToDetail(ReviewUserListDto reviewOneDto) {
    ReviewDto review = ReviewDto(
      id: reviewOneDto.id,
      review: reviewOneDto.review,
      star: reviewOneDto.star,
      user: reviewOneDto.user,
      reviewComments: reviewOneDto.reviewComments,
      reviewImg: reviewOneDto.reviewImgs,
    );
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
        pageBuilder: (context, animation, secondaryAnimation) => ReviewDetail(
          reviewId: reviewOneDto.id,
          reviewDto: review,
          hansicName: reviewOneDto.hansics.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: reviewList.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      height: 100,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color.fromARGB(255, 189, 189, 189),
                        ),
                        color: Colors.white,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: getImg(reviewList[index].reviewImgs),
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
                                    goToDetail(reviewList[index]);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        reviewList[index].hansics.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          reviewList[index].review,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                RatingBar.builder(
                                  initialRating: reviewList[index].star,
                                  itemSize: 15,
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                );
              },
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '작성하신 리뷰가 없어요..',
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(
                    '좋아하는 한식뷔페의 리뷰를 작성해주세요!',
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
    );
  }
}
