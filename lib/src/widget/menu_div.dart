import 'package:flutter/material.dart';

class MenuDiv extends StatelessWidget {
  final String text;
  final Function move;

  const MenuDiv({super.key, required this.text, required this.move});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            move();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: 50,
                margin: const EdgeInsets.fromLTRB(20, 8, 0, 8),
                child: Text(text),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 8, 20, 8),
                child: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
        const Divider(thickness: 1.2),
      ],
    );
  }
}
