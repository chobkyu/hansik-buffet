import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin_example/src/models/review_list.dart';
import 'package:kakao_map_plugin_example/src/models/user_data.dart';
import 'package:kakao_map_plugin_example/src/screen/home_screen.dart';
import 'package:kakao_map_plugin_example/src/screen/login.dart';
import 'package:kakao_map_plugin_example/src/screen/review_list.dart';
import 'package:kakao_map_plugin_example/src/screen/review_update.dart';
import 'package:kakao_map_plugin_example/src/service/get_userdata_service.dart';
import 'package:kakao_map_plugin_example/src/service/review_delete_service.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';
import 'package:kakao_map_plugin_example/src/widget/dialog_builder.dart';
import 'package:kakao_map_plugin_example/src/widget/small_button.dart';
import 'package:kakao_map_plugin_example/src/widget/text_inContainer.dart';

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
  static GetUserData getUserData = GetUserData();
  static const storage = FlutterSecureStorage();

  var isRightUser = false;

  UserData userData = UserData(
    id: 0,
    userName: 'tq',
    userNickName: '',
    userId: '',
    userImgs: [],
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      getUser();
    } catch (err) {
      print(err);
    }
  }

  void getUser() async {
    String? token = await storage.read(key: 'token');
    print(token);
    try {
      userData = await getUserData.getUserData(token!);
      if (userData.id == widget.reviewDto.user.id) {
        isRightUser = true;
      }
      print(isRightUser);
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
                isRightUser
                    ? ForRightUser(
                        storage: storage,
                        reviewDto: widget.reviewDto,
                        userData: userData,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ));
  }
}

class ForRightUser extends StatefulWidget {
  const ForRightUser({
    super.key,
    required this.storage,
    required this.reviewDto,
    required this.userData,
  });

  final FlutterSecureStorage storage;
  final ReviewDto reviewDto;
  final UserData userData;

  @override
  State<ForRightUser> createState() => _ForRightUserState();
}

class _ForRightUserState extends State<ForRightUser> {
  static ReviewDeleteService reviewDeleteService = ReviewDeleteService();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SmallButton(
            text: '수정하기',
            move: () async {
              String? token = await widget.storage.read(key: 'token');
              print(token);
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
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
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
                if (!mounted) return;
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
                        ReviewUpdate(
                            id: 1804,
                            hansicName: "",
                            reviewDto: widget.reviewDto),
                  ),
                );
              }
            },
            color: Colors.amber,
            icon: Icons.edit),
        const SizedBox(
          width: 15,
        ),
        SmallButton(
            text: '삭제하기',
            move: () async {
              String? token = await widget.storage.read(key: 'token');
              print(token);
              print(widget.userData.id);
              print(widget.reviewDto.id);

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
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
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
                if (!mounted) return;
                DialogBuilder.dialogBuild(
                    context: context,
                    text: '삭제하시겠습니까?',
                    needOneButton: false,
                    move: () async {
                      // int res = await reviewDeleteService.deleteReview(
                      //     token, widget.reviewDto.id, widget.userData);
                      // print(res);
                      //일단 홈으로 가게. 나중에 페이지 구조화 되면 그때 적용
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false);
                    });
                // print(res);
                // if (res == 204) {
                //   //수정 완료 팝업 예정
                //   if (!mounted) return;
                //   Navigator.pop(context);
                // } else if (res == 401) {
                //   //로그인 페이지로
                // } else {
                //   //에러 처리 예정
                // }
              }
            },
            color: const Color.fromARGB(255, 238, 227, 212),
            icon: Icons.delete),
      ],
    );
  }
}
