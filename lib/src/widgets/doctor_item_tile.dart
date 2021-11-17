import 'package:book_my_doctor/src/model/doctor.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:flutter/material.dart';

import 'image_view.dart';

class DoctorItemTile extends StatelessWidget {
  final Doctor doctor;
  final Function onTap;

  DoctorItemTile(this.doctor, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: ListTile(
          leading: ImageView(
            height: 56,
            width: 56,
            icon: doctor.photo,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: LightColor.randomColor(),
            ),
          ),
          title: Text(
              "Dr. ${doctor?.firstName ?? ""} ${doctor?.lastName ?? ""}",
              style: TextStyles.title.bold),
          subtitle: Text(
            doctor?.specialization ?? "",
            style: TextStyles.bodySm.subTitleColor.bold,
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
          onTap: this.onTap,
        ));
  }
}
