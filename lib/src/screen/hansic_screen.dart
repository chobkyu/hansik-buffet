import 'package:flutter/material.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';

class HansicScreen extends StatefulWidget {
  const HansicScreen({super.key});

  @override
  State<HansicScreen> createState() => _HansicScreenState();
}

class _HansicScreenState extends State<HansicScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(title: '한식뷔페'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('ㅎㅇ'),
            //Overlay12MarkersEvent1Screen(),
          ],
        ),
      ),
    );
  }
}
