// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kakao_map_plugin_example/src/models/review_list.dart';
import 'package:kakao_map_plugin_example/src/screen/review_detail.dart';
import 'package:kakao_map_plugin_example/src/service/review_list_service.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';

class ReviewList extends StatefulWidget {
  const ReviewList({
    super.key,
    required this.id,
    required this.hansicName,
  });

  final int id;
  final String hansicName;

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  static ReviewListService reviewListService = ReviewListService();

  List<ReviewDto>? reviewList = [];

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
      reviewList = await reviewListService.getReviewList(widget.id);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(title: '${widget.hansicName} 리뷰'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: reviewList?.length,
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
                        width: 70,
                        height: 70,
                        child: ClipRRect(
                          //borderRadius: BorderRadius.circular(100),
                          child: getImg(reviewList![index].reviewImg),
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
                                      ReviewDetail(
                                    reviewId: index,
                                    reviewDto: reviewList![index],
                                    hansicName: widget.hansicName,
                                  ),
                                ),
                              );
                            },
                            child: SizedBox(
                              width: 260,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.hansicName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23,
                                    ),
                                  ),
                                  Text(
                                    reviewList![index].review,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: reviewList![index].star,
                            itemSize: 16,
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
      ),
    );
  }
}
