import 'package:book_my_doctor/src/config/constants.dart';
import 'package:book_my_doctor/src/model/appointment.dart';
import 'package:book_my_doctor/src/model/doctor.dart';
import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:book_my_doctor/src/services/fb_cloud_services.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/utils/activity_utils.dart';
import 'package:book_my_doctor/src/widgets/app_top_bar.dart';
import 'package:book_my_doctor/src/widgets/appointment_user_tile.dart';
import 'package:book_my_doctor/src/widgets/custom_progress_view.dart';
import 'package:book_my_doctor/src/widgets/image_view.dart';
import 'package:book_my_doctor/src/widgets/rating_start.dart';
import 'package:book_my_doctor/src/widgets/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import 'appointment_details.dart';
import 'appointment_rating_screen.dart';
import 'choose_booking_slot.dart';

class AppointmentUserListPage extends StatefulWidget {
  AppointmentUserListPage();

  @override
  _AppointmentUserListPageState createState() =>
      _AppointmentUserListPageState();
}

class _AppointmentUserListPageState extends State<AppointmentUserListPage> {
  UserDetails _user;
  List<Appointment> appointmentList = [];
  bool _isLoading = false;

  @override
  void initState() {
    _user = Provider.of(context, listen: false);
    // geAppointmentList();
    super.initState();
  }

  // geAppointmentList() {
  //   _isLoading = true;
  //   setState(() {});
  //   FbCloudServices().getAppointmentByDoctor(_user.uid).then((appointments) {
  //     print("appointments : ${appointments.length}");
  //     if (appointments != null) {
  //       appointmentList.clear();
  //       appointmentList = List.from(appointments);
  //     }
  //     _isLoading = false;
  //     setState(() {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColor.extraLightBlue,
      appBar: AppTopBar(
        title: "All Appointment",
      ),
      body: CustomProgressView(
        inAsyncCall: _isLoading,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return StreamBuilder<List<Appointment>>(
            stream: FbCloudServices().streamAppointmentByDoctor(_user.uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(LightColor.purple)));
              } else {
                appointmentList = List.from(snapshot.data);
                return (appointmentList == null && appointmentList.isEmpty)
                    ? Text(
                        "No data found",
                        style: TextStyles.body.black,
                      ).alignCenter
                    : ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          var appointment = appointmentList[index];
                          return _appointmentTile(appointment);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            color: Colors.transparent,
                            height: 1,
                          );
                        },
                        itemCount: appointmentList.length,
                      );
              }
            },
          );
        }),
      ),
    );
  }

  Widget _appointmentTile(Appointment appointment) {
    Size size = MediaQuery.of(context).size;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        children: [
          AppointmentUserTile(appointment, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AppointmentDetailPage(appointment, forDoctor: true);
                },
              ),
            );
          }),
          (appointment.date.toDate().isAfter(DateTime.now()) &&
                  appointment.status == APPOINTMENT_STATUS.PENDING.index)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RoundedButton(
                      width: size.width * 0.45,
                      text: "Accept",
                      textColor: Colors.white,
                      color: LightColor.purple,
                      press: () {
                        FbCloudServices().updateAppointmentStatus(
                            appointment.id, APPOINTMENT_STATUS.ACCEPT.index);
                        appointment.status = APPOINTMENT_STATUS.ACCEPT.index;
                        setState(() {});
                      },
                    ),
                    RoundedButton(
                      width: size.width * 0.35,
                      text: "Decline",
                      textColor: Colors.white,
                      color: LightColor.grey,
                      press: () {
                        FbCloudServices().updateAppointmentStatus(
                            appointment.id, APPOINTMENT_STATUS.DECLINE.index);
                        appointment.status = APPOINTMENT_STATUS.DECLINE.index;
                        appointmentList.remove(appointment);
                        setState(() {});
                      },
                    ),
                  ],
                )
              : Container()
        ],
      ).p8,
    );
  }
}
