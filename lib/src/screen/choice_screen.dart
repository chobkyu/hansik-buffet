import 'package:flutter/material.dart';

class ChoiceScreen extends StatelessWidget {
  const ChoiceScreen({super.key});

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
              Container(
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
                      offset: const Offset(1, 0), // changes position of shadow
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
              const SizedBox(
                height: 15,
              ),
              Container(
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
                      offset: const Offset(1, 0), // changes position of shadow
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
                      width: 60,
                    ),
                    Icon(
                      Icons.map,
                      size: 80,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
