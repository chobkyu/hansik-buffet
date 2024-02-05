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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                color: Colors.amber,
                height: 380,
                width: 320,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                '수라 한식 뷔폐 응암점',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '후기 (25)',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '구글 별점  0',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const Divider(
                thickness: 1.2,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 30,
                          color: Colors.amber[400],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          '서울시 은평구 응암동 45-10 101호',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 30,
                          color: Colors.amber[400],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          '사용자 별점 3.7 (참여자 100)',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.reviews,
                          size: 30,
                          color: Colors.amber[400],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          '리뷰 보기 (참여자 25)',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.food_bank_rounded,
                          size: 30,
                          color: Colors.amber[400],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          '메뉴',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                ),
                child: const Text(
                  '리뷰 작성하기',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
