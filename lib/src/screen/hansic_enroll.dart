// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kakao_map_plugin_example/src/models/enroll_hansic.dart';
import 'package:kakao_map_plugin_example/src/models/location.dart';
import 'package:kakao_map_plugin_example/src/models/user_data.dart';
import 'package:kakao_map_plugin_example/src/screen/login.dart';
import 'package:kakao_map_plugin_example/src/service/enroll_hansic_service.dart';
import 'package:kakao_map_plugin_example/src/service/get_userdata_service.dart';
import 'package:kakao_map_plugin_example/src/service/update_user_service.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';
import 'package:kakao_map_plugin_example/src/widget/home_button.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_map_plugin_example/src/widget/location_dropdown.dart';

class EnrollHansic extends StatefulWidget {
  const EnrollHansic({super.key});

  @override
  State<EnrollHansic> createState() => _EnrollHansicState();
}

class _EnrollHansicState extends State<EnrollHansic> {
  static UpdateUserService updateUserService = UpdateUserService();
  static const storage = FlutterSecureStorage();
  static GetUserData getUserData = GetUserData();
  static EnrollHansicService enrollHansicService = EnrollHansicService();

  late List<LocationDto> locationList = [];
  LocationDto? searchLocationDto;

  final ImagePicker picker = ImagePicker();
  List<XFile?> images = []; // 가져온 사진들을 보여주기 위한 변수
  XFile? image; // 카메라로 촬영한 이미지를 저장할 변수
  List<XFile?> multiImage = []; // 갤러리에서 여러장의 사진을 선택해서 저장할 변수
  late String imgUrl = '';

  String name = '';
  String addr = '';

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
      getLocList();
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

  void getLocList() async {
    try {
      locationList = await updateUserService.getLocation();
      setState(() {});
    } catch (err) {
      print(err);
    }
  }

  void getLocation(LocationDto selectedLoc) {
    print(selectedLoc.location);
    searchLocationDto = selectedLoc;
  }

  Widget getImg(List<XFile?> image) {
    if (image.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(
              File(image[0]!.path),
            ),
          ),
        ),
      );
    } else {
      return Image.asset('assets/images/defaultReviewImg.png');
    }
  }

  Future<void> _uploadToSignedURL() async {
    try {
      String s3Url = await getUrl();
      print(s3Url);
      print(images[0].runtimeType);

      final bytes = File(images[0]!.path).readAsBytesSync(); //image 를 byte로 불러옴

      print(images[0]?.path);

      http.Response response = await http.put(Uri.parse(s3Url),
          headers: {
            'Content-Type': 'image/*',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Credentials': 'true',
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
          },
          body: bytes);
      print('??');

      setState(() {
        imgUrl = s3Url.split('?')[0];
      });
      // print(response);
      print(response.body);
    } catch (err) {
      print(err);
    }
  }

  Future<String> getUrl() async {
    try {
      String? baseUrl = dotenv.env['BASE_URL'];

      Uri uri = Uri.parse("$baseUrl/users/imgUrl");

      final response = await http.get(uri);

      print(response.body);

      Map<String, dynamic> resBody =
          jsonDecode(utf8.decode(response.bodyBytes));

      String url = resBody['url'];

      //print(url);
      return url;
    } catch (err) {
      print(err);
      throw Exception();
    }
  }

  void enrollHansic() async {
    try {
      if (name == '' || addr == '' || searchLocationDto == null) {
        //에러 처리 예정
        return;
      }
      String? token = await storage.read(key: 'token');
      EnrollHansicDto enrollHansicDto = EnrollHansicDto(
          name: name, addr: addr, location: searchLocationDto!.id);

      int status =
          await enrollHansicService.enrollHansic(enrollHansicDto, token!);

      if (status == 201) {
        if (!mounted) return;
        Navigator.of(context).pop();
      } else if (status == 401) {
        goToLoginPage();
      } else if (status == 400) {
        //알람 처리(입력값 잘못됨)
      }
    } catch (err) {
      print(err);
    }
  }

  int value = 0;
  Future<void> _dialogBuilder(BuildContext context) {
    // 현재 화면 위에 보여줄 다이얼로그 생성
    return showDialog<void>(
      context: context,
      builder: (context) {
        // 빌더로 AlertDialog 위젯을 생성
        return AlertDialog(
          title: const Text('소중한 등록 감사합니다.'),
          content: const Text('해당 식당은 운영진들의 검토 후 리스트에 등록됩니다.'),
          actions: [
            ElevatedButton(
              // 다이얼로그 내의 확인 버튼 터치 시 값 +1
              onPressed: () {
                enrollHansic();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
              ),
              child: const Text('확인'),
            ),
            // 다이얼로그 내의 취소 버튼 터치 시 다이얼로그 화면 제거
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: "내가 아는 한식 뷔페 등록하기"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    '여러분이 알고 있는 한식 뷔페를 소개해주세요',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    '운영에 큰 도움이 됩니다!!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: InkWell(
                      onTap: () async {
                        multiImage = await picker.pickMultiImage();
                        setState(() {
                          images.addAll(multiImage);
                        });
                        _uploadToSignedURL();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: getImg(images),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    '식당을 소개할 사진을 업로드 해주세요',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    key: const ValueKey(1),
                    onSaved: (value) {
                      name = value!;
                    },
                    onChanged: (value) {
                      name = value;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: Colors.amber,
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
                      hintText: '한식 뷔페 이름',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.amber,
                      ),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    key: const ValueKey(2),
                    onSaved: (value) {
                      addr = value!;
                    },
                    onChanged: (value) {
                      addr = value;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: Colors.amber,
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
                      hintText: '한식 뷔페 주소',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.amber,
                      ),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        //background color of dropdown button
                        border: Border.all(
                          color: Colors.amber,
                          // width: 3,
                        ), //border of dropdown button
                        borderRadius: BorderRadius.circular(
                            50), //border raiuds of dropdown button
                        boxShadow: const <BoxShadow>[
                          //apply shadow on Dropdown button
                          BoxShadow(
                            color: Colors.white, //shadow for button
                            blurRadius: 5,
                          ) //blur radius of shadow
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: LocationDropDown(
                          locationList: locationList,
                          getLocation: getLocation,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  HomeButton(
                    text: '등록하기',
                    move: () {
                      print('object');
                      _dialogBuilder(context);
                    },
                    color: Colors.amber,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
