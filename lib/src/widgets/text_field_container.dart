import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;

  const TextFieldContainer({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: LightColor.purpleExtraLight,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
