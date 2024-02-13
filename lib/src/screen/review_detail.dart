import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';
import 'package:kakao_map_plugin_example/src/widget/text_inContainer.dart';

class ReviewDetail extends StatefulWidget {
  const ReviewDetail({super.key, required this.reviewId});

  final int reviewId;
  @override
  State<ReviewDetail> createState() => _ReviewDetailState();
}

class _ReviewDetailState extends State<ReviewDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: 'Review'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                TextInContainer(
                  text: widget.reviewId.toString(),
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
                  text: '게시글',
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
                    initialRating: 3,
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
