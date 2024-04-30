import 'package:flutter/material.dart';

class PlainText extends StatelessWidget {
  const PlainText({
    super.key,
    required this.name,
    required this.fontsize,
    this.fontWeight = FontWeight.w400,
    this.color,
    this.textAlign = TextAlign.start,
  });
  final String name;
  final TextAlign textAlign;
  final double fontsize;
  final FontWeight? fontWeight;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: 'Sans-serif',
        fontSize: fontsize,
        fontWeight: fontWeight,
        color: color,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
