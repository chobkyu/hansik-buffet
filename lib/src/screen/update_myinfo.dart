// ignore_for_file: avoid_print, unused_element

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kakao_map_plugin_example/src/models/location.dart';
import 'package:kakao_map_plugin_example/src/models/user_data.dart';
import 'package:kakao_map_plugin_example/src/screen/login.dart';
import 'package:kakao_map_plugin_example/src/screen/my_page.dart';
import 'package:kakao_map_plugin_example/src/service/get_userdata_service.dart';
import 'package:kakao_map_plugin_example/src/service/update_user_service.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';
import 'package:kakao_map_plugin_example/src/widget/home_button.dart';
import 'package:kakao_map_plugin_example/src/widget/location_dropdown.dart';

class UpdateMyInfo extends StatefulWidget {
  const UpdateMyInfo({super.key});

  @override
  State<UpdateMyInfo> createState() => _UpdateMyInfoState();
}

class _UpdateMyInfoState extends State<UpdateMyInfo> {
  static const storage = FlutterSecureStorage();
  static UpdateUserService updateUserService = UpdateUserService();
  static GetUserData getUserData = GetUserData();
  final ImagePicker picker = ImagePicker();
  List<XFile?> images = []; // 가져온 사진들을 보여주기 위한 변수
  XFile? image; // 카메라로 촬영한 이미지를 저장할 변수
  List<XFile?> multiImage = []; // 갤러리에서 여러장의 사진을 선택해서 저장할 변수

  final _formKey = GlobalKey<FormState>();

  bool signflag = false;
  late String userName = 'User Name';
  late String userNickName = 'User Nick Name';
  late String userPw = 'User Password';
  late String userId = 'User ID';

  final String? _selectedValue = '1';

  UserData userData = UserData(
    id: 0,
    userName: 'tq',
    userNickName: '',
    userId: '',
    userImgs: [],
  );

  String imgUrl = '';

  late List<LocationDto> locationList = [];
  LocationDto? locationDto;

  void _tryValidation() {
    final isValid =
        _formKey.currentState!.validate(); //폼필드 안 validator를 작동시킬 수 있음
    if (isValid) {
      _formKey.currentState!.save();
      signflag = true;
    }
  }

  @override
  void initState() {
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
      userName = userData.userName;
      userNickName = userData.userNickName;
      userId = userData.userId;

      if (userData.userImgs.isNotEmpty) {
        print('object');
        imgUrl = userData.userImgs[0]['imgUrl'];
      } else {
        imgUrl =
            'https://hansicbuffet.s3.ap-northeast-2.amazonaws.com/b0f790a446bb8255116e088aa8ae7abe';
      }

      //지역 리스트 조회
      locationList = await updateUserService.getLocation();
      locationDto = locationList[0];

      setState(() {});
    } catch (err) {
      print(err.toString());
      await storage.delete(key: 'token');
      if (!mounted) return;
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
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
        ),
      );
    }
  }

  String getImgUrl() {
    if (imgUrl != '') {
      print(imgUrl);
      return imgUrl;
    } else {
      return 'https://puda.s3.ap-northeast-2.amazonaws.com/client/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7+2024-02-07+152742.png';
    }
  }

  void updateUser() async {
    try {
      String? token = await storage.read(key: 'token');

      if (token == null) {
        if (!mounted) return;
        Navigator.of(context).pop(); //로그인 안되어있을 시 처리 예정
      }

      await updateUserService.updateUser(userId, userPw, userName, userNickName,
          int.parse(_selectedValue!), imgUrl, token!);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const MyPage();
          },
        ),
      );
    } catch (err) {
      print(err);
    }
  }

  void getLocation(LocationDto selectedLoc) {
    print(selectedLoc);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(title: 'My Page'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 600,
          height: 800,
          //color: Colors.amber[50],
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: InkWell(
                        onTap: () async {
                          multiImage = await picker.pickMultiImage();
                          setState(() {
                            images.addAll(multiImage);
                          });
                          _uploadToSignedURL();
                        },
                        child: Image.network(getImgUrl()),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    key: const ValueKey(1),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userName = value!;
                    },
                    onChanged: (value) {
                      userName = value;
                    },
                    style: const TextStyle(
                        //color: Colors.white,
                        ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.account_circle,
                        color: Colors.amber,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35),
                        ),
                      ),
                      hintText: userName,
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(137, 56, 54, 54),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    key: const ValueKey(2),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userId = value!;
                    },
                    onChanged: (value) {
                      userId = value;
                    },
                    style: const TextStyle(
                        //color: Colors.white,
                        ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.account_circle,
                        color: Colors.amber,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35),
                        ),
                      ),
                      hintText: userId,
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(137, 56, 54, 54),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    key: const ValueKey(3),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userNickName = value!;
                    },
                    onChanged: (value) {
                      userNickName = value;
                    },
                    style: const TextStyle(
                        //color: Colors.white,
                        ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.account_circle,
                        color: Colors.amber,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35),
                        ),
                      ),
                      hintText: userNickName,
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(137, 56, 54, 54),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    key: const ValueKey(4),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    readOnly: true, //비밀번호 설정 관련 회의 후 결정
                    onSaved: (value) {
                      userPw = value!;
                    },
                    onChanged: (value) {
                      userPw = value;
                    },
                    obscureText: true,
                    style: const TextStyle(
                        //color: Colors.white,
                        ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.account_circle,
                        color: Colors.amber,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35),
                        ),
                      ),
                      hintText: userPw,
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(137, 56, 54, 54),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // DropdownButton(
                  //   items: _valueList.map(
                  //     (value) {
                  //       return DropdownMenuItem(
                  //         value: value,
                  //         child: Text(value),
                  //       );
                  //     },
                  //   ).toList(),
                  //   onChanged: (value) {
                  //     setState(
                  //       () {
                  //         _selectedValue = value;
                  //       },
                  //     );
                  //   },
                  //   borderRadius: BorderRadius.circular(10),
                  //   style: const TextStyle(
                  //       //te
                  //       fontSize: 20 //font size on dropdown button
                  //       ),
                  // ),
                  // DecoratedBox(
                  //   decoration: BoxDecoration(
                  //       //background color of dropdown button
                  //       border: Border.all(
                  //         color: Colors.amber,
                  //         // width: 3,
                  //       ), //border of dropdown button
                  //       borderRadius: BorderRadius.circular(
                  //           50), //border raiuds of dropdown button
                  //       boxShadow: const <BoxShadow>[
                  //         //apply shadow on Dropdown button
                  //         BoxShadow(
                  //             color: Colors.white, //shadow for button
                  //             blurRadius: 5) //blur radius of shadow
                  //       ]),
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(left: 30, right: 30),
                  //     child: DropdownButton(
                  //       value: locationDto,
                  //       items: locationList.map(
                  //         (value) {
                  //           return DropdownMenuItem(
                  //             value: value,
                  //             child: Text(value.location),
                  //           );
                  //         },
                  //       ).toList(),
                  //       onChanged: (value) {
                  //         setState(
                  //           () {
                  //             locationDto = value;
                  //           },
                  //         );
                  //       },
                  //       icon: const Padding(
                  //           //Icon at tail, arrow bottom is default icon
                  //           padding: EdgeInsets.only(left: 20),
                  //           child: Icon(Icons.arrow_circle_down_sharp)),
                  //       iconEnabledColor: Colors.grey, //Icon color
                  //       style: const TextStyle(
                  //           //te
                  //           color: Colors.black, //Font color
                  //           fontSize: 20 //font size on dropdown button
                  //           ),

                  //       dropdownColor: Colors.white, //dropdown background color
                  //       underline: Container(), //remove underline
                  //       isExpanded: true, //make true to make width 100%
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  DecoratedBox(
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
                              blurRadius: 5) //blur radius of shadow
                        ]),
                    child: Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: LocationDropDown(
                          locationList: locationList,
                          getLocation: getLocation,
                        )),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  HomeButton(
                    text: 'update',
                    move: () async {
                      updateUser();
                    },
                    color: Colors.amber,
                  ),
                ],
                //column's children
              ),
            ),
          ),
        ),
      ),
    );
  }
}
