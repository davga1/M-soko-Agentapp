import 'package:flutter/material.dart';

Widget hSpacer(double vheight) => SizedBox(height: vheight);
Widget wSpacer(double vwidth) => SizedBox(width: vwidth);
Color appColor = const Color(0xFF08215E);
Color boxColor = const Color(0xFF0C2769);
Color logoColor = const Color(0xFFF08000);
Color sellColor = const Color(0xFFF7931D);

Color orangeColor = Colors.orange;
Color redColor = Colors.red;
Color pinkColor = Colors.pink.shade300;
Color blackColor = Colors.black;
Color textColor = const Color(0xFF5E5E5E);
Color greenColor = const Color(0xFF10BC55);
Color whiteColor = Colors.white;
Color blueColor = Colors.blue;
Color yellowColor = Colors.yellow;
Color greyColor = Colors.grey;
Color greyColor1 = const Color(0xFFE8E8E8);
List<String> sellItemList = [
  "Get Help Anytime",
  "Selling on Tanzania",
  "Higher Profit",
  "Higher Availability",
  "Higher Credibility"
];
List<IconData> sellItemIcon = [
  Icons.support_agent,
  Icons.shopping_cart_outlined,
  Icons.percent,
  Icons.percent,
  Icons.person,
];
List<String> filterEvent = [
  "All",
  "MakeUp",
  "Nail Care",
  "Hair Care",
  "Face Care",
  "Transplant",
  "EyeLash Care"
];
List<String> paymentOption = [
  "Next Payment",
  "Last Payment",
  "Total Outstandings Payment",
  "Recent Order",
];
List<String> paymentdOptionDetails = [
  "Estimated value of next payment.This may change due to returns that come in before the next payout.",
  "These payments have been initiated and may take up to 48 hours to reflect in your bank account.",
  "Total amount you are to receive from Sokoni for dispatched orders. It includes the “Next Payment” amounts shown above.",
  "These are orders yet to be dispatched. Once dispatched, payments will be secluded and they will reflect in ‘Total Outstanding Payments’ section.  ",
];
