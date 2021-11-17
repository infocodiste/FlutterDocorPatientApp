import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:book_my_doctor/src/theme/extention.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double radius;
  final double width;

  const RoundedButton({
    Key key,
    this.text,
    this.press,
    this.color = LightColor.purple,
    this.textColor = Colors.white,
    this.radius = 29,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 12),
      width: width ?? size.width * 0.8,
      height: 36,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(radius))),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyles.titleNormal.white,
      ),
    ).ripple(
      press,
      borderRadius: BorderRadius.circular(radius),
    );
  }
}
