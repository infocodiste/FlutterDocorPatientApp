import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color color;
  final Widget leading;
  final Widget trailing;

  AppTopBar({this.leading, this.title, this.color, this.trailing});

  @override
  Size get preferredSize => Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      brightness: Brightness.light,
      centerTitle: true,
      elevation: 0,
      backgroundColor: color,
      leading: leading ??
          IconButton(
            icon: Icon(Icons.arrow_back_outlined),
            color: color == null ? Colors.white : Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
      title: Text(
        title,
        style: TextStyles.title.white.bold,
      ),
      actions: trailing != null ? [trailing] : [],
    );
  }
}
