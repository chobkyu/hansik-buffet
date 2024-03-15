// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin_example/src/models/review_list.dart';
import 'package:kakao_map_plugin_example/src/models/review_write.dart';
import 'package:kakao_map_plugin_example/src/models/user_data.dart';
import 'package:kakao_map_plugin_example/src/screen/home_screen.dart';
import 'package:kakao_map_plugin_example/src/screen/login.dart';
import 'package:kakao_map_plugin_example/src/service/get_userdata_service.dart';
import 'package:kakao_map_plugin_example/src/service/review_update_service.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';
import 'package:kakao_map_plugin_example/src/widget/dialog_builder.dart';
import 'package:kakao_map_plugin_example/src/widget/small_button.dart';

class ReviewUpdate extends StatefulWidget {
  const ReviewUpdate({
    super.key,
    required this.id,
    required this.hansicName,
    required this.reviewDto,
  });

  final int id;
  final String hansicName;
  final ReviewDto reviewDto;

  @override
  State<ReviewUpdate> createState() => _ReviewUpdateState();
}

class _ReviewUpdateState extends State<ReviewUpdate> {
  static GetUserData getUserData = GetUserData();
  static const storage = FlutterSecureStorage();
  static ReviewUpdateService reviewUpdateService = ReviewUpdateService();

  UserData userData = UserData(
    id: 0,
    userName: 'tq',
    userNickName: '',
    userId: '',
    userImgs: [],
  );

  ReviewCreate reviewCreate = ReviewCreate(
    id: 0,
    detailReview: 'a',
    userRating: 0,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      getUser();
      print("this is review update");
    } catch (err) {
      print(err);
    }
  }

  void getUser() async {
    String? token = await storage.read(key: 'token');
    print(token);
    try {
      userData = await getUserData.getUserData(token!);
      print(userData);
      print(widget.reviewDto.review);
      print(widget.reviewDto.star);
      reviewCreate.detailReview = widget.reviewDto.review;
      reviewCreate.userRating = widget.reviewDto.star;
      setState(() {});
    } catch (err) {
      print(err.toString());
      goToLoginPage();
    }
  }

  void goToLoginPage() async {
    await storage.delete(key: 'token');
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const LoginScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(title: 'review'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                widget.hansicName,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  initialValue: widget.reviewDto.review,
                  maxLines: 15,
                  //style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {
                      reviewCreate.detailReview = value;
                    });
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.supervised_user_circle_outlined,
                      color: Colors.white,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                      borderRadius: BorderRadius.all(
                        Radius.circular(35),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(35),
                      ),
                    ),
                    hintText: 'User NickName',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.white54),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[350],
                ),
                child: RatingBar.builder(
                  initialRating: widget.reviewDto.star,
                  itemSize: 30,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                    reviewCreate.userRating = rating;
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmallButton(
                    text: '수정하기',
                    move: () async {
                      reviewCreate.id = widget.id;
                      print(reviewCreate.detailReview);
                      print(reviewCreate.userRating);
                      String? token = await storage.read(key: 'token');
                      print(token);
                      try {
                        int res = await reviewUpdateService.updateReview(
                            reviewCreate, token!, widget.reviewDto.id);

                        print(res);
                        if (res == 200) {
                          //여기도 일단 홈으로 가게
                          DialogBuilder.dialogBuild(
                              context: context,
                              text: '수정되었습니다.',
                              needOneButton: true,
                              move: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                  (route) => false,
                                );
                              });
                          if (!mounted) return;
                        } else if (res == 401) {
                          goToLoginPage();
                        } else {
                          //에러 처리 예정
                        }
                      } catch (err) {
                        print(err);
                      }
                    },
                    color: Colors.amber,
                    icon: Icons.edit,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
