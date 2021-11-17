import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/widgets/text_field_container.dart';
import 'package:flutter/material.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const RoundedPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: LightColor.purple,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: LightColor.purple,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: LightColor.purple,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
