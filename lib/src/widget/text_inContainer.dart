// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class TextInContainer extends StatefulWidget {
  TextInContainer({
    super.key,
    required this.text,
    required this.color,
    required this.circular,
    required this.fontSize,
    required this.width,
    required this.height,
  });

  String text;
  Color color;
  double circular;
  double fontSize;
  double width;
  double height;

  @override
  State<TextInContainer> createState() => _TextInContainerState();
}

class _TextInContainerState extends State<TextInContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(
          style: BorderStyle.solid,
          color: widget.color,
        ),
        borderRadius: BorderRadius.circular(widget.circular),
      ),
      padding: const EdgeInsets.all(16),
      child: Text(
        widget.text,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
