import 'package:flutter/material.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/theme/extention.dart';

class AppLogo extends StatefulWidget {
  final Color color;

  AppLogo({this.color = Colors.white});

  @override
  _AppLogoState createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/heartbeat.png",
          color: widget.color,
          height: 100,
        ),
        Text(
          "My Doctor",
          style: TextStyles.h1Style.white,
        ),
        Text(
          "By Codiste Pvt Ltd.",
          style: TextStyles.bodySm.white.bold,
        ),
      ],
    );
  }
}
