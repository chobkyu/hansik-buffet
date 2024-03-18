// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:kakao_map_plugin_example/src/models/hansic_list.dart';
import 'package:kakao_map_plugin_example/src/models/location.dart';
import 'package:kakao_map_plugin_example/src/screen/hansic_detail.dart';
import 'package:kakao_map_plugin_example/src/screen/hansic_screen.dart';
import 'package:kakao_map_plugin_example/src/service/geolocator_service.dart';
import 'package:kakao_map_plugin_example/src/service/get_hansicdata_service.dart';
import 'package:kakao_map_plugin_example/src/service/update_user_service.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin_example/src/widget/home_button.dart';
import 'package:kakao_map_plugin_example/src/widget/location_dropdown.dart';

/// 여러개 마커에 이벤트 등록하기1
/// https://apis.map.kakao.com/web/sample/multipleMarkerEvent/
class Overlay12MarkersEvent1Screen extends StatefulWidget {
  const Overlay12MarkersEvent1Screen(
      {Key? key, this.title, required this.lat, required this.lng})
      : super(key: key);

  final String? title;
  final double lat;
  final double lng;

  @override
  State<Overlay12MarkersEvent1Screen> createState() =>
      _Overlay12MarkersEvent1ScreenState();
}

class _Overlay12MarkersEvent1ScreenState
    extends State<Overlay12MarkersEvent1Screen> {
  late KakaoMapController mapController;
  static GetHansicService hansicService = GetHansicService();
  static GeolocatorService geolocatorService = GeolocatorService();
  static UpdateUserService updateUserService = UpdateUserService();

  //지역 별 조회
  late List<LocationDto> locationList = [];
  LocationDto? locationDto;
  LocationDto? searchLocationDto;

  Set<Marker> markers = {};

  List<HansicList>? hansics;

  late double lat = 37.4916927972275;
  late double lng = 126.899358119287;

  @override
  void initState() {
    super.initState();
    try {
      getHansics();
    } catch (err) {
      print(err);
    }
  }

  LatLng getGeo() {
    if (widget.lng < 0) {
      LatLng latLng = LatLng(lat, lng);
      return latLng;
    } else {
      LatLng latLng = LatLng(widget.lat, widget.lng);
      return latLng;
    }
  }

  void getHansics() async {
    try {
      //await geolocatorService.getLocation();
      print('getHansics 호출');
      hansics = await hansicService.getHansicData();
      print(hansics?.length);

      //지역 리스트 조회
      locationList = await updateUserService.getLocation();
      locationDto = locationList[0];

      setState(() {});
    } catch (err) {
      print(err);
    }
  }

  //지역 별 조회
  void getHansicsLoc(int id) async {
    try {
      print('지역 별 조회');
      print(hansics?.length);

      print(hansics?[0].location);
      hansics!.clear();
      setState(() {});
      //print(hansics![0].name);

      hansics = await hansicService.getHansicDataFromLoc(id);
      lat = hansics![0].lat;
      lng = hansics![0].lng;

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HansicScreen(
              lat: lat,
              lng: lng,
              locId: id,
            );
          },
        ),
      );
      setState(() {});
    } catch (err) {
      print(err);
    }
  }

  void getLocation(LocationDto selectedLoc) {
    print(selectedLoc.location);
    searchLocationDto = selectedLoc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: Column(
          children: [
            const CustomAppBar(title: '한식 뷔페'),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.55,
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
      body: KakaoMap(
        onMapCreated: ((controller) async {
          mapController = controller;
          for (int i = 0; i < hansics!.length; i++) {
            markers.add(Marker(
                markerId: markers.length.toString(),
                latLng: LatLng(hansics![i].lat, hansics![i].lng),
                infoWindowContent:
                    '<div style="width:200px;"><div style="background-color:orange;">${hansics?[i].name}</div><div style="marginTop:0.5rem;"><span style="display:block;">${hansics?[i].userStar}</span><span style="display:block">${hansics?[i].location}</span> <span style="display:block;">${hansics?[i].addr}</span></div></div>'));
          }

          setState(() {});
        }),
        markers: markers.toList(),
        center: getGeo(),
        onMarkerTap: (markerId, latLng, zoomLevel) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 1),
              backgroundColor: Colors.white,
              content: ElevatedButton(
                onPressed: () {
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
                            HansicDetail(
                          latLng: latLng,
                        ),
                      ));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, elevation: 1),
                child: const Text(
                  '자세히 보기',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // Text(
              //   'marker click:\n\n$latLng\n$markerId',
              //   style: const TextStyle(color: Colors.black),
              // ),
            ),
          );
        },
      ),
    );
  }
}
