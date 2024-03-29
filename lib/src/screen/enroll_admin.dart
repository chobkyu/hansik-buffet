// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin_example/src/models/enroll_list.dart';
import 'package:kakao_map_plugin_example/src/screen/enroll_detail.dart';
import 'package:kakao_map_plugin_example/src/screen/login.dart';
import 'package:kakao_map_plugin_example/src/service/enroll_hansic_service.dart';
import 'package:kakao_map_plugin_example/src/util/error_status.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';

class EnrollAdmin extends StatefulWidget {
  const EnrollAdmin({super.key});

  @override
  State<EnrollAdmin> createState() => _EnrollAdminState();
}

class _EnrollAdminState extends State<EnrollAdmin> {
  static EnrollHansicService enrollHansicService = EnrollHansicService();
  static const storage = FlutterSecureStorage();
  static ErrorStatus errorStatus = ErrorStatus();

  List<EnrollListDto> enrollList = [];

  @override
  void initState() {
    super.initState();
    try {
      getEnrollList();
    } catch (err) {
      print(err);
    }
  }

  void getEnrollList() async {
    try {
      String? token = await storage.read(key: 'token');
      print('token : $token');
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
      } else {
        enrollList = await enrollHansicService.getEnrollList(token);
        setState(() {});
      }
    } catch (err) {
      print('--------------------');
      print(err.toString());
      // ignore: unnecessary_null_comparison
      if (err.toString() != null) {
        print('err 처리');
        String errCode = err.toString().split(': ')[2];
        // ignore: use_build_context_synchronously
        errorStatus.errStatus(errCode, context, mounted);
      } else {
        //에러 메세지 처리 예정
        goToLoginPage();
      }

      //에러 메세지 처리 예정
      //goToLoginPage();
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
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(title: '한뷔 등록 관리자 페이지'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: enrollList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              InkWell(
                onTap: () {
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
                          EnrollDetail(
                        enrollListDto: enrollList[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 120,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 189, 189, 189),
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          enrollList[index].name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          '등록자 : ${enrollList[index].user.userNickName}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          '주소 : ${enrollList[index].addr}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          '지역 : ${enrollList[index].location.location}',
                          style: const TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
