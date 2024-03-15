import 'package:flutter/material.dart';
import 'package:kakao_map_plugin_example/src/models/enroll_list.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';
import 'package:kakao_map_plugin_example/src/widget/home_button.dart';
import 'package:kakao_map_plugin_example/src/widget/text_inContainer.dart';

class EnrollDetail extends StatefulWidget {
  final EnrollListDto enrollListDto;
  const EnrollDetail({super.key, required this.enrollListDto});

  @override
  State<EnrollDetail> createState() => _EnrollDetailState();
}

class _EnrollDetailState extends State<EnrollDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(title: widget.enrollListDto.name),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                TextInContainer(
                  text: '이름  :  ${widget.enrollListDto.name}',
                  color: Colors.amber,
                  circular: 30,
                  fontSize: 20,
                  width: 350,
                  height: 60,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextInContainer(
                  text: '주소  :  ${widget.enrollListDto.addr}',
                  color: Colors.amber,
                  circular: 35,
                  fontSize: 20,
                  width: 350,
                  height: 60,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextInContainer(
                  text:
                      '지역 및 지역번호  :  ${widget.enrollListDto.location.location} , ${widget.enrollListDto.location.id} 번 ',
                  color: Colors.amber,
                  circular: 35,
                  fontSize: 20,
                  width: 350,
                  height: 60,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextInContainer(
                  text: '등록 유저  :  ${widget.enrollListDto.user.userNickName} ',
                  color: Colors.amber,
                  circular: 35,
                  fontSize: 20,
                  width: 350,
                  height: 60,
                ),
                const SizedBox(
                  height: 10,
                ),
                HomeButton(
                  text: '등록',
                  move: () {},
                  color: Colors.amber,
                ),
              ],
            ),
          ),
        ));
  }
}
