import 'dart:io';

import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final double height;
  final double width;
  final String icon;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Function onPress;
  final BoxFit boxFit;
  final Decoration decoration;
  final AlignmentGeometry alignment;
  final bool isFile;
  final IconData iconData;
  final bool circle;
  final Color color;

  ImageView(
      {this.icon,
      this.iconData,
      this.isFile = false,
      this.circle = false,
      this.height,
      this.width,
      this.margin,
      this.padding,
      this.onPress,
      this.boxFit = BoxFit.cover,
      this.color,
      this.decoration,
      this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
            margin: margin,
            padding: padding,
            width: width,
            height: height,
            alignment: alignment,
            child: circle
                ? ClipOval(
                    child: getImage(),
                  )
                : getImage(),
            decoration: decoration)
        .ripple(onPress);
  }

  Widget getImage() {
    if (iconData != null) {
      return Icon(
        iconData,
        color: color ?? LightColor.grey,
        size: width ?? height,
      );
    } else if (icon != null && icon.isNotEmpty) {
      if (icon.contains("www.") || icon.contains("http")) {
        return CachedNetworkImage(
          imageUrl: icon,
        );
      } else if (icon != null && isFile) {
        return Image.file(File(icon));
      } else {
        return Image.asset(
          "assets/" + icon,
          fit: boxFit,
          color: color,
        );
      }
    } else {
      return Image.asset(
        "assets/user.jpg",
        fit: boxFit,
        color: color,
      );
    }
  }
}
