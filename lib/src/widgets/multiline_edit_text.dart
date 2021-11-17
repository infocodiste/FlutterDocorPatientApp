import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/widgets/image_view.dart';
import 'package:flutter/material.dart';

class MultilineEditText extends StatelessWidget {
  final String hint;
  final double width;
  final double height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color borderColor;
  final Color bgColor;
  final double radius;
  final Color fontColor;
  final double fontSize;
  final bool obscure;
  final Widget suffixIcon;
  final TextEditingController controller;
  final TextInputType textInputType;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final bool enable;
  final int lines;
  final Function onTextChange;

  MultilineEditText(
      {this.hint,
      this.width,
      this.height,
      this.margin,
      this.padding = const EdgeInsets.symmetric(vertical: 4),
      this.borderColor = LightColor.purple,
      this.bgColor = Colors.transparent,
      this.radius = 22,
      this.fontColor = LightColor.black,
      this.fontSize = 16,
      this.obscure = false,
      this.controller,
      this.suffixIcon,
      this.textInputType = TextInputType.multiline,
      this.textAlign = TextAlign.left,
      this.textCapitalization = TextCapitalization.sentences,
      this.lines = 3,
      this.enable = true,
      this.onTextChange});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        maxLines: 5,
        minLines: lines,
        style: TextStyle(
            color: fontColor, fontSize: fontSize, fontWeight: FontWeight.w500),
        textAlignVertical: TextAlignVertical.top,
        textAlign: textAlign,
        obscureText: obscure,
        controller: controller,
        textCapitalization: textCapitalization,
        keyboardType: textInputType,
        cursorColor: fontColor,
        onChanged: onTextChange,
        decoration: new InputDecoration(
            alignLabelWithHint: true,
            labelText: hint,
            filled: true,
            fillColor: bgColor,
            contentPadding: padding,
            border: InputBorder.none,
            // disabledBorder: new OutlineInputBorder(
            //     borderRadius: new BorderRadius.circular(radius),
            //     borderSide: new BorderSide(color: borderColor)),
            // enabledBorder: new OutlineInputBorder(
            //     borderRadius: new BorderRadius.circular(radius),
            //     borderSide: new BorderSide(color: borderColor)),
            // focusedBorder: new OutlineInputBorder(
            //     borderRadius: new BorderRadius.circular(radius),
            //     borderSide: new BorderSide(color: borderColor)),
            suffixIcon: suffixIcon),
      ),
    );
  }
}
