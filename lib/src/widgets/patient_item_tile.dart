import 'package:book_my_doctor/src/model/doctor.dart';
import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:flutter/material.dart';

import 'image_view.dart';

class PatientItemTile extends StatelessWidget {
  final UserDetails patient;
  final Function onTap;

  PatientItemTile(this.patient, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          leading: ImageView(
            height: 56,
            width: 56,
            icon: patient.photo,
            circle: true,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: LightColor.randomColor(),
                borderRadius: BorderRadius.all(Radius.circular(28))),
          ),
          title: Text("${patient?.firstName ?? ""} ${patient?.lastName ?? ""}",
              style: TextStyles.title.bold),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
          onTap: this.onTap,
        ));
  }
}
