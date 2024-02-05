import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';

class HansicDetail extends StatefulWidget {
  const HansicDetail({super.key, required this.latLng});

  final LatLng latLng;

  @override
  State<HansicDetail> createState() => _HansicDetailState();
}

class _HansicDetailState extends State<HansicDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(title: '한식 뷔페'),
      ),
      body: Text(widget.latLng.toString()),
    );
  }
}
