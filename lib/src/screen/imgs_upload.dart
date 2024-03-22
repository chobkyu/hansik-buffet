// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';
import 'package:kakao_map_plugin_example/src/widget/dialog_builder.dart';

class ImgsUpload extends StatefulWidget {
  const ImgsUpload({super.key, required this.limit});

  final int limit;

  @override
  State<ImgsUpload> createState() => _ImgsUploadState();
}

class _ImgsUploadState extends State<ImgsUpload> {
  final ImagePicker picker = ImagePicker();
  XFile? image; // 카메라로 촬영한 이미지를 저장할 변수
  List<XFile?> multiImage = []; // 갤러리에서 여러장의 사진을 선택해서 저장할 변수
  List<XFile?> images = []; // 가져온 사진들을 보여주기 위한 변수
  // ignore: prefer_final_fields

  String s3Url = ''; // for문 내에서 사용할 url 변수
  dynamic bytes; // for문 내에서 사용할 image를 byte로 불러오는 변수

  List<String> urls = []; // 이전 페이지에 넘겨줄 url

  Future<void> _uploadToSignedURL() async {
    try {
      for (int i = 0; i < images.length; i++) {
        print(i);
        s3Url = await getUrl();
        print(s3Url);
        print(image.runtimeType);
        print(images[i].runtimeType);

        bytes = File(images[i]!.path).readAsBytesSync();
        print(images[i]?.path);

        http.Response response = await http.put(Uri.parse(s3Url),
            headers: {
              'Content-Type': 'image/*',
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Credentials': 'true',
              'Access-Control-Allow-Headers': 'Content-Type',
              'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
            },
            body: bytes);
        // print(response);
        print(response.body);
        urls.add(s3Url.split("?")[0]);
      }
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
        child: CustomAppBar(title: 'Image'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              "최대 ${widget.limit}장",
              style: const TextStyle(fontSize: 25),
            ),
            Row(
              children: [
                //카메라로 촬영하기
                Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0.5,
                            blurRadius: 5)
                      ],
                    ),
                    child: IconButton(
                        onPressed: () async {
                          image = await picker.pickImage(
                              source: ImageSource.camera);
                          //카메라로 촬영하지 않고 뒤로가기 버튼을 누를 경우, null값이 저장되므로 if문을 통해 null이 아닐 경우에만 images변수로 저장하도록 합니다
                          if (image != null) {
                            setState(() {
                              images.add(image);
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.add_a_photo,
                          size: 30,
                          color: Colors.white,
                        ))),
                //갤러리에서 가져오기
                Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0.5,
                          blurRadius: 5,
                        )
                      ],
                    ),
                    child: IconButton(
                        onPressed: () async {
                          multiImage = await picker.pickMultiImage();
                          setState(() {
                            //갤러리에서 가지고 온 사진들은 리스트 변수에 저장되므로 addAll()을 사용해서 images와 multiImage 리스트를 합쳐줍니다.
                            images.addAll(multiImage);
                          });
                        },
                        icon: const Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 30,
                          color: Colors.white,
                        ))),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: GridView.builder(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                itemCount:
                    images.length, //보여줄 item 개수. images 리스트 변수에 담겨있는 사진 수 만큼.
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, //1 개의 행에 보여줄 사진 개수
                  childAspectRatio: 1 / 1, //사진 의 가로 세로의 비율
                  mainAxisSpacing: 10, //수평 Padding
                  crossAxisSpacing: 10, //수직 Padding
                ),
                itemBuilder: (BuildContext context, int index) {
                  // 사진 오른 쪽 위 삭제 버튼을 표시하기 위해 Stack을 사용함
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                fit: BoxFit.cover, //사진을 크기를 상자 크기에 맞게 조절
                                image: FileImage(File(images[index]!
                                        .path // images 리스트 변수 안에 있는 사진들을 순서대로 표시함
                                    )))),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        //삭제 버튼
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 15),
                          onPressed: () {
                            //버튼을 누르면 해당 이미지가 삭제됨
                            setState(() {
                              images.remove(images[index]);
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (images.length > widget.limit) {
                  DialogBuilder.dialogBuild(
                      context: context,
                      text: "${widget.limit}장 까지만 가능합니다.",
                      needOneButton: true);
                } else {
                  await _uploadToSignedURL();
                  print("onPressed");
                  Navigator.pop(
                    context,
                    urls,
                  );
                }
              },
              child: const Text("등록하기"),
            ),
          ],
        ),
      ),
    );
  }
}
