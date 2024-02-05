// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:kakao_map_plugin_example/src/models/hansic_data.dart';
import 'package:kakao_map_plugin_example/src/service/get_hansicdata_service.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';

/// 여러개 마커에 이벤트 등록하기1
/// https://apis.map.kakao.com/web/sample/multipleMarkerEvent/
class Overlay12MarkersEvent1Screen extends StatefulWidget {
  const Overlay12MarkersEvent1Screen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<Overlay12MarkersEvent1Screen> createState() =>
      _Overlay12MarkersEvent1ScreenState();
}

class _Overlay12MarkersEvent1ScreenState
    extends State<Overlay12MarkersEvent1Screen> {
  late KakaoMapController mapController;
  static GetHansicService hansicService = GetHansicService();

  Set<Marker> markers = {};

  List<HansicData>? hansics;

  @override
  void initState() {
    super.initState();
    try {
      getHansics();
    } catch (err) {
      print(err);
    }
  }

  void getHansics() async {
    try {
      hansics = await hansicService.getHansicData();
      print(hansics?.length);
      setState(() {});
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Column(
          children: [
            CustomAppBar(title: '한식 뷔페'),
            Text('data'),
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
          // markers.add(Marker(
          //     markerId: markers.length.toString(),
          //     latLng: LatLng(33.450705, 126.570677),
          //     infoWindowContent: '<div>카카오</div>'));

          // markers.add(Marker(
          //     markerId: markers.length.toString(),
          //     latLng: LatLng(33.450936, 126.569477),
          //     infoWindowContent: '<div>생태연못</div>'));

          // markers.add(Marker(
          //     markerId: markers.length.toString(),
          //     latLng: LatLng(33.450879, 126.569940),
          //     infoWindowContent: '<div>텃밭</div>'));

          // markers.add(Marker(
          //     markerId: markers.length.toString(),
          //     latLng: LatLng(33.451393, 126.570738),
          //     infoWindowContent: '<div>근린공원</div>'));

          setState(() {});
        }),
        markers: markers.toList(),
        center: LatLng(37.4860146411306, 126.89329203683),
        onMarkerTap: (markerId, latLng, zoomLevel) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('marker click:\n\n$latLng')));
        },
      ),
    );
  }
}
