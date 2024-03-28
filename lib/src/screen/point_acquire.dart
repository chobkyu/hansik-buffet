// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';

class PointAcquire extends StatefulWidget {
  const PointAcquire({
    super.key,
    required this.point,
    required this.randNum,
  });

  final int point;
  final int randNum;

  @override
  State<PointAcquire> createState() => _PointAcquireState();
}

class _PointAcquireState extends State<PointAcquire> {
  late Timer _timer;
  int originPoint = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    originPoint = (widget.point * 0.9).toInt();
    _timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => _incrementCounter(),
    );
  }

  void _incrementCounter() {
    print('called _incrementCounter');
    if (widget.point != originPoint) {
      setState(() {
        originPoint++;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
              Container(
                padding: const EdgeInsets.all(15),
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.yellow[600],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.yellow,
                        Color.fromRGBO(255, 241, 118, 1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.attach_money_outlined,
                      size: 180,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${widget.randNum} 포인트 획득',
                style: TextStyle(fontSize: 40),
              ),
              Text(
                '총 ${originPoint.toString()} 포인트',
                style: TextStyle(fontSize: 60),
              )
            ]),
      ),
    );
  }
}
