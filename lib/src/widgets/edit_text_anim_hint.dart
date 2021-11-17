import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:flutter/material.dart';

class EditTextAnimHint extends StatelessWidget {
  final String hint;
  final String text;
  final double width;
  final double height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color borderColor;
  final Color bgColor;
  final double radius;
  final Color fontColor;
  final double fontSize;
  final FontWeight fontWeight;
  final bool obscure;
  final Widget suffixIcon;
  final TextEditingController controller;
  final TextInputType textInputType;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final bool enable;

  EditTextAnimHint(
      {this.text,
      this.hint,
      this.width,
      this.height = 44,
      this.margin,
      this.padding = const EdgeInsets.symmetric(vertical: 4),
      this.borderColor = LightColor.purple,
      this.bgColor = Colors.transparent,
      this.radius = 18,
      this.fontColor = LightColor.black,
      this.fontSize = 16,
      this.fontWeight = FontWeight.w500,
      this.obscure = false,
      this.controller,
      this.suffixIcon,
      this.textInputType = TextInputType.text,
      this.textAlign = TextAlign.left,
      this.textCapitalization = TextCapitalization.words,
      this.enable = true});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (text != null && text.isNotEmpty) {
      controller.text = text;
    }
    return Container(
      width: width ?? size.width * 0.8,
      // height: height,
      margin: margin,
      alignment: Alignment.center,
      padding: EdgeInsets.all(2),
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: borderColor))),
      child: TextField(
        enabled: enable,
        maxLines: 1,
        minLines: 1,
        style: TextStyle(
            color: enable ? fontColor : LightColor.grey,
            fontSize: fontSize,
            fontWeight: fontWeight),
        textAlignVertical: TextAlignVertical.center,
        textAlign: textAlign,
        obscureText: obscure,
        controller: controller,
        textCapitalization: textCapitalization,
        keyboardType: textInputType,
        cursorColor: enable ? fontColor : LightColor.grey,
        decoration: new InputDecoration(
          // alignLabelWithHint: true,
          // hintText: hint,
          labelText: hint,
          filled: true,
          fillColor: bgColor,
          contentPadding: padding,
          border: InputBorder.none,
          // border: UnderlineInputBorder(
          //     borderSide: new BorderSide(color: borderColor))
          // disabledBorder: new UnderlineInputBorder(
          //   borderRadius: new BorderRadius.circular(radius),
          //   borderSide: new BorderSide(color: borderColor),
          // ),
          // enabledBorder: new UnderlineInputBorder(
          //   borderRadius: new BorderRadius.circular(radius),
          //   borderSide: new BorderSide(color: borderColor),
          // ),
          // focusedBorder: new UnderlineInputBorder(
          //     borderRadius: new BorderRadius.circular(radius),
          //     borderSide: new BorderSide(color: borderColor)),
        ),
      ),
    );
  }
}
