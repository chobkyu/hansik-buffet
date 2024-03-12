// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';
import 'package:kakao_map_plugin_example/src/widget/home_button.dart';
import 'package:http/http.dart' as http;

class EnrollHansic extends StatefulWidget {
  const EnrollHansic({super.key});

  @override
  State<EnrollHansic> createState() => _EnrollHansicState();
}

class _EnrollHansicState extends State<EnrollHansic> {
  final ImagePicker picker = ImagePicker();
  List<XFile?> images = []; // 가져온 사진들을 보여주기 위한 변수
  XFile? image; // 카메라로 촬영한 이미지를 저장할 변수
  List<XFile?> multiImage = []; // 갤러리에서 여러장의 사진을 선택해서 저장할 변수
  late String imgUrl = '';

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
              width: MediaQuery.of(context).size.width * 0.8,
              margin: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    '여러분이 알고 있는 한식 뷔페를 소개해주세요',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    '운영에 큰 도움이 됩니다!!',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
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
                    height: 40,
                  ),
                  TextFormField(
                    key: const ValueKey(1),
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
                    height: 15,
                  ),
                  HomeButton(
                    text: '등록하기',
                    move: () {},
                    color: Colors.amber,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
