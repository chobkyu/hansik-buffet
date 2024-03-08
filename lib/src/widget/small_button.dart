import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function move;
  final IconData icon;

  const SmallButton({
    super.key,
    required this.text,
    required this.move,
    required this.color,
    required this.icon,
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
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        padding: const EdgeInsets.all(13),
        backgroundColor: color,
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(
            width: 5,
          ),
          Text(
            text,
          ),
        ],
      ),
    );
  }
}
