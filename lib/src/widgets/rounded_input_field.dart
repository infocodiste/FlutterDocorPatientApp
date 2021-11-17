import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:flutter/material.dart';

import 'text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: LightColor.purple,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: LightColor.purple,
          ),
          hintText: hintText,
          labelText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
