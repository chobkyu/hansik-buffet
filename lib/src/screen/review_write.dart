// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kakao_map_plugin_example/src/models/review_write.dart';
import 'package:kakao_map_plugin_example/src/models/user_data.dart';
import 'package:kakao_map_plugin_example/src/screen/img_upload.dart';
import 'package:kakao_map_plugin_example/src/screen/login.dart';
import 'package:kakao_map_plugin_example/src/service/get_userdata_service.dart';
import 'package:kakao_map_plugin_example/src/service/review_write_service.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';
import 'package:kakao_map_plugin_example/src/widget/home_button.dart';

class ReviewWrite extends StatefulWidget {
  const ReviewWrite({super.key, required this.id, required this.hansicName});

  final int id;
  final String hansicName;

  @override
  State<ReviewWrite> createState() => _ReviewWriteState();
}

class _ReviewWriteState extends State<ReviewWrite> {
  static GetUserData getUserData = GetUserData();
  static const storage = FlutterSecureStorage();
  static ReviewWriteService reviewWriteService = ReviewWriteService();
  final ImagePicker picker = ImagePicker();
  List<XFile?> images = []; // 가져온 사진들을 보여주기 위한 변수
  XFile? image; // 카메라로 촬영한 이미지를 저장할 변수
  List<XFile?> multiImage = []; // 갤러리에서 여러장의 사진을 선택해서 저장할 변수

  String imgUrl = '';

  UserData userData = UserData(
    id: 0,
    userName: 'tq',
    userNickName: '',
    userId: '',
    userImgs: [],
  );

  ReviewCreate reviewCreate = ReviewCreate(
    id: 0,
    detailReview: '',
    userRating: 3,
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
      print(userData);
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
                  maxLines: 15,
                  //style: const TextStyle(color: Colors.white),
                  onSaved: (value) {
                    reviewCreate.detailReview = value!;
                  },
                  onChanged: (value) {
                    reviewCreate.detailReview = value;
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
                  initialRating: 3,
                  itemSize: 30,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
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
              HomeButton(
                text: '이미지 추가',
                move: () async {
                  imgUrl = await Navigator.push(
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
                          const ImgUpload(),
                    ),
                  );
                },
                color: Colors.amber,
              ),
              const SizedBox(
                height: 15,
              ),
              HomeButton(
                text: '등록하기',
                move: () async {
                  reviewCreate.id = widget.id;
                  print(reviewCreate.id);
                  print("등록하기!!!!!!!!!!!");
                  print(imgUrl);
                  String? token = await storage.read(key: 'token');

                  try {
                    int res = await reviewWriteService.writeReview(
                        reviewCreate, token!, imgUrl);
                    print("???????????????");
                    print(res);

                    if (res == 201) {
                      //등록 완료 팝업 예정
                      if (!mounted) return;
                      Navigator.pop(context);
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
