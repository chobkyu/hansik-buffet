// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kakao_map_plugin_example/src/models/review_list.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';
import 'package:kakao_map_plugin_example/src/widget/text_incontainer.dart';

class ReviewDetail extends StatefulWidget {
  const ReviewDetail({
    super.key,
    required this.reviewId,
    required this.reviewDto,
    required this.hansicName,
  });

  final int reviewId;
  final ReviewDto reviewDto;
  final String hansicName;
  @override
  State<ReviewDetail> createState() => _ReviewDetailState();
}

class _ReviewDetailState extends State<ReviewDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(title: '${widget.hansicName} 리뷰'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                TextInContainer(
                  text: '${widget.reviewDto.user.userNickName}님의 리뷰',
                  color: Colors.amber,
                  circular: 30,
                  fontSize: 20,
                  width: 350,
                  height: 60,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextInContainer(
                  text: widget.reviewDto.review,
                  color: Colors.amber,
                  circular: 35,
                  fontSize: 20,
                  width: 350,
                  height: 350,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[350],
                  ),
                  child: RatingBar.builder(
                    initialRating: widget.reviewDto.star,
                    ignoreGestures: true,
                    itemSize: 30,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ));
  }
}
