import 'package:flutter/material.dart';

class BoldText extends StatelessWidget {
  const BoldText({
    super.key,
    required this.name,
    required this.fontsize,
    this.fontWeight = FontWeight.w700,
    this.color,
    this.textAlign = TextAlign.start,
  });
  final String name;
  final double fontsize;
  final TextAlign textAlign;

  final FontWeight? fontWeight;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      textAlign: textAlign,
      style: TextStyle(
        // fontFamily: 'Sans-serif',
        fontSize: fontsize,
        fontWeight: fontWeight,

        color: color,
      ),
    );
  }
}
