import 'dart:math';

import 'package:flutter/material.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';

extension TextStyleHelpers on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  TextStyle get white => copyWith(color: Colors.white);

  TextStyle get titleColor => copyWith(color: LightColor.titleTextColor);

  TextStyle get subTitleColor => copyWith(color: LightColor.subTitleTextColor);

  TextStyle get purple => copyWith(color: LightColor.purple);

  TextStyle get grey => copyWith(color: Colors.black54);

  TextStyle get black => copyWith(color: Colors.black);

  TextStyle get red => copyWith(color: Colors.redAccent);
}

extension PaddingHelper on Widget {
  Padding get p8 => Padding(padding: EdgeInsets.all(8), child: this);

  Padding get p16 => Padding(padding: EdgeInsets.all(16), child: this);

  /// Set padding according to `value`
  Padding p(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  /// Horizontal Padding 16
  Padding get hP4 =>
      Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: this);

  Padding get hP8 =>
      Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: this);

  Padding get hP16 =>
      Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: this);

  /// Vertical Padding 16
  Padding get vP16 =>
      Padding(padding: EdgeInsets.symmetric(vertical: 16), child: this);

  Padding get vP8 =>
      Padding(padding: EdgeInsets.symmetric(vertical: 8), child: this);

  Padding get vP4 =>
      Padding(padding: EdgeInsets.symmetric(vertical: 8), child: this);
}

extension Extented on Widget {
  Expanded get extended => Expanded(
        child: this,
      );
}

extension CornerRadius on Widget {
  ClipRRect get circular => ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        child: this,
      );
}

extension OnPressed on Widget {
  Widget ripple(Function onPressed,
          {BorderRadiusGeometry borderRadius =
              const BorderRadius.all(Radius.circular(5))}) =>
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          this,
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: FlatButton(
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
                onPressed: () {
                  if (onPressed != null) {
                    onPressed();
                  }
                },
                child: Container()),
          )
        ],
      );
}

extension ExAlignment on Widget {
  Widget get alignTopCenter => Align(
        child: this,
        alignment: Alignment.topCenter,
      );

  Widget get alignCenter => Align(
        child: this,
        alignment: Alignment.center,
      );

  Widget get alignBottomCenter => Align(
        child: this,
        alignment: Alignment.bottomCenter,
      );

  Widget get alignBottomLeft => Align(
        child: this,
        alignment: Alignment.bottomLeft,
      );

  Widget get alignTopLeft => Align(
        child: this,
        alignment: Alignment.topLeft,
      );

  Widget get alignCenterLeft => Align(
        child: this,
        alignment: Alignment.centerLeft,
      );
}
