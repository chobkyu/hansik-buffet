import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function move;

  const HomeButton({
    super.key,
    required this.text,
    required this.move,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          move();
        },
        style: ElevatedButton.styleFrom(
          elevation: 10,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            fontFamily: 'hangul',
          ),
          padding: const EdgeInsets.all(13),
          backgroundColor: color,
        ),
        child: Text(
          text,
        ));
  }
}
