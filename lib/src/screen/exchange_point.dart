import 'package:flutter/material.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';
import 'package:kakao_map_plugin_example/src/widget/home_button.dart';

class ExchangePoint extends StatefulWidget {
  const ExchangePoint({
    super.key,
    required this.userNickName,
    required this.accountNo,
    required this.point,
  });

  final String userNickName;
  final String accountNo;
  final int point;

  @override
  State<ExchangePoint> createState() => _ExchangePointState();
}

class _ExchangePointState extends State<ExchangePoint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(title: '포인트 전환'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${widget.userNickName}님의 포인트는',
              style: const TextStyle(
                fontSize: 40,
              ),
            ),
            Text(
              '${widget.point} 포인트 입니다',
              style: const TextStyle(
                fontSize: 60,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            HomeButton(
              text: '포인트 전환하기',
              move: () {},
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}
