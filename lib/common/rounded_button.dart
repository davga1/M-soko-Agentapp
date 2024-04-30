import 'package:agentapp/common/bold_text.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final Widget? widget;
  final double fontsize;
  final double radius;
  final double? leftWidth;
  final VoidCallback onTap;
  final Color buttonColor;
  final Color textColor;
  final Color borderColor;
  final Color iconColor;
  final IconData? iconsDataLeft;
  final IconData? iconsDataRight;
  const RoundedButton({
    super.key,
    required this.title,
    required this.onTap,
    this.buttonColor = const Color(0xFF0F7BDF),
    this.textColor = Colors.white,
    this.iconColor = Colors.black,
    this.borderColor = Colors.white,
    this.iconsDataLeft,
    this.iconsDataRight,
    this.radius = 10,
    this.fontsize = 16,
    this.leftWidth,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(width: 0, color: borderColor),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget ?? SizedBox.shrink(),
                Icon(
                  iconsDataLeft,
                  color: iconColor,
                ),
                SizedBox(width: leftWidth),
                BoldText(
                  name: title,
                  fontsize: fontsize,
                  color: textColor,
                ),
                Icon(
                  iconsDataRight,
                  color: iconColor,
                ),
              ],
            ),
          ),
        ));
  }
}
