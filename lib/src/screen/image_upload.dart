// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final List<PlatformFile> _files = [];

  //이미지 가져오기
  void _pickFiles() async {
    List<PlatformFile>? uploadedFiles = (await FilePicker.platform.pickFiles(
      allowMultiple: true,
    ))
        ?.files;
    setState(() {
      for (PlatformFile file in uploadedFiles!) {
        _files.add(file);
      }
    });
  }

  Future<int> _uploadToSignedURL(
      {required PlatformFile file, required String url}) async {
    String s3Url = await getUrl();
    print(s3Url);
    print(file);
    http.Response response = await http.put(Uri.parse(s3Url), body: file.bytes);
    print(response.body);
    return response.statusCode;
  }

  Future<String> getUrl() async {
    try {
      String? baseUrl = dotenv.env['TEST_URL'];

      Uri uri = Uri.parse("$baseUrl/users/imgUrl");

      final response = await http.get(uri);

      Map<String, dynamic> resBody =
          jsonDecode(utf8.decode(response.bodyBytes));

      String url = resBody['url'];

      return url;
    } catch (err) {
      print(err);
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('imgUpload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickFiles,
              child: const Text("Choose a file"),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                ),
              ),
              width: 350,
              height: 500,
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  itemCount: _files.isEmpty ? 1 : _files.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _files.isEmpty
                        ? const ListTile(
                            title:
                                Text("파일을 업로드해주세요 - 한 번에 여러 파일을 업로드할 수 있습니다"))
                        : ListTile(
                            title: Text(_files.elementAt(index).name),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  _files.removeAt(index);
                                });
                              },
                            ),
                          );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _uploadToSignedURL(
                    file: _files.elementAt(0), url: "url-you-have");
              },
              child: const Text("Upload to S3"),
            ),
          ],
        ),
      ),
    );
  }
}
