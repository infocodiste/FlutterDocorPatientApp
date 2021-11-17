import 'package:book_my_doctor/src/config/constants.dart';
import 'package:book_my_doctor/src/model/appointment.dart';
import 'package:book_my_doctor/src/pages/appointment_details.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/utils/activity_utils.dart';
import 'package:book_my_doctor/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

import 'image_view.dart';

class AppointmentUserTile extends StatelessWidget {
  final Appointment appointment;
  final Function onTap;

  AppointmentUserTile(this.appointment, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 12,
      leading: ImageView(
        height: 56,
        width: 56,
        icon: appointment.patientPhoto,
        circle: true,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: LightColor.skyBlue,
        ),
      ),
      title: Text("${appointment?.patientName}", style: TextStyles.title.bold),
      subtitle: Text(
        ActivityUtils().formattedDate(appointment.date.toDate()) +
            ', ' +
            ActivityUtils()
                .formattedDate(appointment.date.toDate(), format: "hh:mm a"),
        style: TextStyles.bodySm.subTitleColor,
      ),
      trailing: Icon(
        Icons.keyboard_arrow_right,
        size: 30,
        color: Theme.of(context).primaryColor,
      ),
      onTap: this.onTap,
    );
  }
}
