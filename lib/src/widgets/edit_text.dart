import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:flutter/material.dart';

class EditText extends StatelessWidget {
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

  EditText(
      {this.text,
      this.hint,
      this.width,
      this.height = 36,
      this.margin,
      this.padding = const EdgeInsets.symmetric(horizontal: 16),
      this.borderColor = LightColor.purple,
      this.bgColor = Colors.white,
      this.radius = 18,
      this.fontColor = LightColor.black,
      this.fontSize = 14,
      this.fontWeight = FontWeight.normal,
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
      height: height,
      margin: margin,
      alignment: Alignment.center,
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
            alignLabelWithHint: true,
            hintText: hint,
            hintStyle: TextStyle(
                color: LightColor.grey,
                fontSize: fontSize,
                fontWeight: FontWeight.normal),
            filled: true,
            fillColor: Colors.white,
            contentPadding: padding,
            disabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(radius),
              borderSide: new BorderSide(color: borderColor),
            ),
            enabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(radius),
              borderSide: new BorderSide(color: borderColor),
            ),
            focusedBorder: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(radius),
                borderSide: new BorderSide(color: borderColor))),
      ),
    );
  }
}
