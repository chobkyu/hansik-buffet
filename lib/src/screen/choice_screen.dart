// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin_example/src/models/hansic_list.dart';
import 'package:kakao_map_plugin_example/src/overlay_12_markers_event1_screen.dart';
import 'package:kakao_map_plugin_example/src/screen/hansic_screen.dart';
import 'package:kakao_map_plugin_example/src/service/geolocator_service.dart';
import 'package:kakao_map_plugin_example/src/service/get_hansicdata_service.dart';
import 'package:kakao_map_plugin_example/src/widget/dialog_builder.dart';

class ChoiceScreen extends StatefulWidget {
  const ChoiceScreen({super.key});
  static GeolocatorService geolocatorService = GeolocatorService();

  @override
  State<ChoiceScreen> createState() => _ChoiceScreenState();
}

class _ChoiceScreenState extends State<ChoiceScreen> {
  static GetHansicService hansicService = GetHansicService();

  List<HansicList>? hansics;

  late double lat = 37.4916927972275;
  late double lng = 126.899358119287;

  //지역 별 조회
  void getHansicsLoc(int? id) async {
    try {
      print('지역 별 조회');
      print(hansics?.length);

      //print(hansics?[0].location);
      //hansics!.clear();
      setState(() {});
      //print(hansics![0].name);
      if (id != null) {
        hansics = await hansicService.getHansicDataFromLoc(id);
        lat = hansics![0].lat;
        lng = hansics![0].lng;

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
                HansicScreen(lat: lat, lng: lng, locId: id),
          ),
        );
        setState(() {});
      } else {
        //알람창 띄우기
        DialogBuilder.dialogBuild(
          context: context,
          text: "지역을 선택해주세요!!",
          needOneButton: true,
        );
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '원하시는 방식으로 한식 뷔페를 찾아보세요!!',
                style: TextStyle(fontSize: 27),
              ),
              const Text(
                '내 주변 식당, 혹은 지역 별로 찾을 수 있어요',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () async {
                  Position position =
                      await ChoiceScreen.geolocatorService.getLocation();
                  double lat = position.latitude;
                  double lng = position.longitude;

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
                          Overlay12MarkersEvent1Screen(lat: lat, lng: lng),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: BoxDecoration(
                    color: Colors.yellow[700],
                    border: Border.all(
                      color: Colors.grey,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset:
                            const Offset(1, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '내 주변 위치 한식 뷔페 찾기',
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                          Text(
                            '내 위치 주변의 식당을 찾아줘요!!',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.location_on_outlined,
                        size: 80,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  getHansicsLoc(1); //내가 설정한 지역으로 할지 default 값으로 갈지
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange[100],
                    border: Border.all(
                      color: Colors.grey,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset:
                            const Offset(1, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '지역 별로 찾기',
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                          Text(
                            '내가 원하는 지역의 식당을 찾아줘요!!',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Icon(
                        Icons.map,
                        size: 80,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
