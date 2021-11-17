import 'dart:io';

import 'package:book_my_doctor/src/config/constants.dart';
import 'package:book_my_doctor/src/model/appointment.dart';
import 'package:book_my_doctor/src/model/doctor.dart';
import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:book_my_doctor/src/pages/appointment_successful_page.dart';
import 'package:book_my_doctor/src/services/fb_cloud_services.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/utils/activity_utils.dart';
import 'package:book_my_doctor/src/utils/file_handler.dart';
import 'package:book_my_doctor/src/widgets/app_top_bar.dart';
import 'package:book_my_doctor/src/widgets/custom_progress_view.dart';
import 'package:book_my_doctor/src/widgets/edit_text.dart';
import 'package:book_my_doctor/src/widgets/edit_text_anim_hint.dart';
import 'package:book_my_doctor/src/widgets/image_view.dart';
import 'package:book_my_doctor/src/widgets/rounded_button.dart';
import 'package:book_my_doctor/src/widgets/time_slot_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'consultations_chat_page.dart';

class AppointmentDetailPage extends StatefulWidget {
  final Appointment appointment;
  final bool forDoctor;

  AppointmentDetailPage(this.appointment, {this.forDoctor = false});

  @override
  _AppointmentDetailPageState createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  bool _isLoading = false;

  GlobalKey _globalKey = GlobalKey<ScaffoldState>();

  Doctor doctor;
  UserDetails patient;

  String photoUrl, name, specialization;

  @override
  void initState() {
    super.initState();
    print("Appointment : ${widget.appointment.toJson()}");
    getInitialDetails();
  }

  String selectedDay;
  String selectedTime;

  getInitialDetails() async {
    patient = await FbCloudServices().getUserById(widget.appointment.patientId);
    doctor =
        await FbCloudServices().getDoctorByUserId(widget.appointment.doctorId);

    if (widget.forDoctor) {
      photoUrl = this.patient.photo;
      name = "${patient?.firstName ?? ""} ${patient?.lastName ?? ""}";
      specialization = null;
    } else {
      photoUrl = this.doctor.photo;
      name = "Dr. ${doctor?.firstName ?? ""} ${doctor?.lastName ?? ""}";
      specialization = "${doctor?.specialization ?? ""}";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _globalKey,
      backgroundColor: LightColor.extraLightBlue,
      appBar: AppTopBar(
        title: "Appointment Details",
      ),
      body: CustomProgressView(
        inAsyncCall: _isLoading,
        child: Container(
          height: size.height,
          width: double.infinity,
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: LightColor.grey, width: 0.3)),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        leading: ImageView(
                          height: 56,
                          width: 56,
                          icon: photoUrl ?? "",
                          circle: true,
                        ),
                        title: Text(name ?? "", style: TextStyles.body.bold),
                        subtitle: Text(
                          specialization ?? "",
                          style: TextStyles.bodySm.grey,
                        ),
                        trailing: Container(
                          width: 64,
                          child: Row(
                            children: [
                              ImageView(
                                iconData: Icons.call,
                                height: 24,
                                width: 24,
                                color: LightColor.orange,
                              ).p(4).ripple(() {
                                ActivityUtils().launchUrl(
                                    'tel:${widget.forDoctor ? patient.phone : doctor.phone}');
                              }),
                              ImageView(
                                iconData: Icons.chat_outlined,
                                height: 24,
                                width: 24,
                                color: LightColor.grey,
                              ).p(4).ripple(() {
                                FbCloudServices()
                                    .startConsultDoctor(widget.appointment.id);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ConsultationChatPage(
                                              peerId: widget.forDoctor
                                                  ? patient.uid
                                                  : doctor.uid,
                                            )));
                              }),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        thickness: .3,
                        color: LightColor.grey,
                        height: 1,
                      ),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text("Procedure",
                                      style: TextStyles.bodySm.grey),
                                  Text("Consultation",
                                      style: TextStyles.body.bold)
                                ],
                              ).p8,
                            ),
                            VerticalDivider(
                              thickness: .3,
                              color: LightColor.grey,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text("Fees", style: TextStyles.bodySm.grey),
                                  Text("$RS ${doctor?.consultFee ?? ""}",
                                      style: TextStyles.body.bold)
                                ],
                              ).p8,
                            ),
                          ],
                        ).hP16,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: LightColor.grey, width: 0.3)),
                  width: double.infinity,
                  child: Column(children: [
                    Text("Date & Time", style: TextStyles.bodySm.grey),
                    SizedBox(height: 4),
                    Text(
                        "${ActivityUtils().formattedDate(widget.appointment.date.toDate(), format: 'EEEEE dd-MM-yyyy, hh:mm a')}",
                        style: TextStyles.body.bold)
                  ]).p8,
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: LightColor.grey, width: 0.3)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              widget.forDoctor ? "Address" : "Practice Details",
                              style: TextStyles.bodySm.grey),
                          SizedBox(height: 4),
                          widget.forDoctor
                              ? Container()
                              : Text("${doctor?.hospitalName ?? ""}",
                                  style: TextStyles.body.bold),
                          Text(
                              widget.forDoctor
                                  ? "${patient?.address ?? ""}"
                                  : "${doctor?.hospitalAddress ?? ""}",
                              style: TextStyles.body)
                        ],
                      ).p16,
                      Divider(
                        thickness: .3,
                        color: LightColor.grey,
                        height: 1,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          RotatedBox(
                              quarterTurns: 2,
                              child: Icon(Icons.subdirectory_arrow_left_rounded,
                                  color: LightColor.purple)),
                          Text("Get Directions",
                                  style: TextStyles.bodySm.bold.purple)
                              .hP8
                        ],
                      ).p8.ripple(() {
                        String address = widget.forDoctor
                            ? "${patient.address}"
                            : "${doctor.hospitalAddress}";
                        if (address != null && address.length > 0) {
                          MapsLauncher.launchQuery(address);
                        }
                      })
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: LightColor.grey, width: 0.3)),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text("Booked for", style: TextStyles.bodySm.grey),
                              Text(
                                  "${patient?.firstName ?? ""} ${patient?.lastName ?? ""}",
                                  style: TextStyles.body.bold)
                            ],
                          ).hP4,
                        ),
                        VerticalDivider(
                          thickness: .3,
                          color: LightColor.grey,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text("Appointment ID",
                                  style: TextStyles.bodySm.grey),
                              Text("${widget.appointment?.number ?? ""}",
                                  style: TextStyles.body.bold)
                            ],
                          ).p8,
                        ),
                      ],
                    ).hP16,
                  ).p8,
                ),
                SizedBox(height: 16),
                (widget.forDoctor)
                    ? (widget.appointment.date
                                .toDate()
                                .isAfter(DateTime.now()) &&
                            widget.appointment.status ==
                                APPOINTMENT_STATUS.PENDING.index)
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
                                      widget.appointment.id,
                                      APPOINTMENT_STATUS.ACCEPT.index);
                                  widget.appointment.status =
                                      APPOINTMENT_STATUS.ACCEPT.index;
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
                                      widget.appointment.id,
                                      APPOINTMENT_STATUS.DECLINE.index);
                                  widget.appointment.status =
                                      APPOINTMENT_STATUS.DECLINE.index;
                                  setState(() {});
                                },
                              ),
                            ],
                          )
                        : ((widget.appointment.status ==
                                        APPOINTMENT_STATUS.ACCEPT.index ||
                                    widget.appointment.status ==
                                        APPOINTMENT_STATUS.COMPLETED.index) &&
                                widget.appointment.prescription == null)
                            ? RoundedButton(
                                width: double.infinity,
                                text: "Upload Prescriptions",
                                textColor: Colors.white,
                                color: LightColor.purple,
                                press: () async {
                                  File file =
                                      await FileHandler.get().filePicker();
                                  print("Prescription File : ${file.path}");
                                  _isLoading = true;
                                  setState(() {});
                                  String pUrl = await FileHandler.get()
                                      .uploadFileToFirebase(file,
                                          onData: (value) {
                                    print("Uploading Progress $value");
                                  });
                                  await FbCloudServices()
                                      .updateAppointmentPrescriptions(
                                          widget.appointment.id, pUrl);
                                  _isLoading = false;
                                  setState(() {});
                                },
                              )
                            : Container()
                    : Container(),
                (widget.appointment.prescription == null)
                    ? Container()
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border:
                                Border.all(color: LightColor.grey, width: 0.3)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Prescriptions", style: TextStyles.bodySm.grey)
                                .p8,
                            Divider(
                              thickness: .3,
                              color: LightColor.grey,
                              height: 1,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                RotatedBox(
                                    quarterTurns: 2,
                                    child: Icon(Icons.file_present,
                                        color: LightColor.purple)),
                                Text("Click to know",
                                        style: TextStyles.bodySm.bold.purple)
                                    .hP8
                              ],
                            ).p8.ripple(() {
                              ActivityUtils()
                                  .launchUrl(widget.appointment.prescription);
                            })
                          ],
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
