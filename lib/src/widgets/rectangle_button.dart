import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:book_my_doctor/src/theme/extention.dart';

class RectangleButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double width;
  final bool tick;
  final EdgeInsets margin;

  const RectangleButton({
    Key key,
    this.text,
    this.width,
    this.press,
    this.color = LightColor.purple,
    this.textColor = Colors.white,
    this.tick = false,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: margin,
      padding: EdgeInsets.symmetric(horizontal: 12),
      width: width,
      height: 36,
      decoration: BoxDecoration(
          color: tick ? color : Colors.transparent,
          border: Border.all(color: tick ? color : LightColor.grey)),
      alignment: Alignment.center,
      child: Text(
        text,
        style:
            tick ? TextStyles.titleNormal.white : TextStyles.titleNormal.purple,
      ),
    ).ripple(
      press,
      borderRadius: BorderRadius.circular(0),
    );
  }
}
