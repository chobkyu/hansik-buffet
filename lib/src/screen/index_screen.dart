// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin_example/src/models/hansic_list.dart';
import 'package:kakao_map_plugin_example/src/models/location.dart';
import 'package:kakao_map_plugin_example/src/overlay_12_markers_event1_screen.dart';
import 'package:kakao_map_plugin_example/src/screen/favorite_mylist.dart';
import 'package:kakao_map_plugin_example/src/screen/hansic_screen.dart';
import 'package:kakao_map_plugin_example/src/service/geolocator_service.dart';
import 'package:kakao_map_plugin_example/src/service/get_hansicdata_service.dart';
import 'package:kakao_map_plugin_example/src/service/update_user_service.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';
import 'package:kakao_map_plugin_example/src/widget/home_button.dart';
import 'package:kakao_map_plugin_example/src/widget/location_dropdown.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  static GetHansicService hansicService = GetHansicService();
  static UpdateUserService updateUserService = UpdateUserService();
  static GeolocatorService geolocatorService = GeolocatorService();

  late List<LocationDto> locationList = [];
  LocationDto? searchLocationDto;
  List<HansicList>? hansics;

  late double lat = 37.4916927972275;
  late double lng = 126.899358119287;

  @override
  void initState() {
    super.initState();
    try {
      getLocList();
    } catch (err) {
      print(err);
    }
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

  //지역 별 조회
  void getHansicsLoc(int id) async {
    try {
      print('지역 별 조회');
      print(hansics?.length);

      print(hansics?[0].location);
      //hansics!.clear();
      setState(() {});
      //print(hansics![0].name);

      hansics = await hansicService.getHansicDataFromLoc(id);
      lat = hansics![0].lat;
      lng = hansics![0].lng;

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
              HansicScreen(lat: lat, lng: lng, locId: id),
        ),
      );

      setState(() {});
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(title: '한사장'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.22,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                            const Offset(3, 5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Icon(
                        Icons.soup_kitchen_outlined,
                        size: 70,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        '한식 뷔페 찾기',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1.2,
                ),
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
                            const FavoriteMyList(),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.height * 0.22,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                              const Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Icon(
                          Icons.kitchen_outlined,
                          size: 70,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '즐겨찾는 한식 뷔페',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.12,
              decoration: BoxDecoration(
                color: Colors.white,
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
                    offset: const Offset(0, 5), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      Position position = await geolocatorService.getLocation();
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
                          pageBuilder: (context, animation,
                                  secondaryAnimation) =>
                              Overlay12MarkersEvent1Screen(lat: lat, lng: lng),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(20, 8, 0, 8),
                      child: const Text(
                        '내 주변 한식 뷔페 찾기',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 8, 20, 8),
                    child: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.18,
              decoration: BoxDecoration(
                color: Colors.white,
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
                    offset: const Offset(0, 5), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 100,
                    margin: const EdgeInsets.fromLTRB(20, 0, 0, 8),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.location_on),
                            Text(
                              '지역 별 한식 뷔페 찾기',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(Icons.location_on),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.65,
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
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 30),
                                  child: LocationDropDown(
                                    locationList: locationList,
                                    getLocation: getLocation,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            HomeButton(
                              text: '검색',
                              move: () {
                                //print(MediaQuery.of(context).size.width);
                                getHansicsLoc(searchLocationDto!.id);
                              },
                              color: Colors.amber,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.13,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                            const Offset(3, 5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Icon(
                        Icons.reviews_outlined,
                        size: 40,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '리뷰 많은 한식뷔페',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1.2,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.13,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                            const Offset(3, 5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Icon(
                        Icons.star_border,
                        size: 40,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        '별점 높은 한식뷔페',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1.2,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.13,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                            const Offset(3, 5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Icon(
                        Icons.note_alt_outlined,
                        size: 40,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        '리뷰 쓴 한식 뷔페',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
