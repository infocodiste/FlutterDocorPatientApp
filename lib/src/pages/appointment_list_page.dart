import 'package:book_my_doctor/src/config/constants.dart';
import 'package:book_my_doctor/src/model/appointment.dart';
import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:book_my_doctor/src/services/fb_cloud_services.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/utils/activity_utils.dart';
import 'package:book_my_doctor/src/widgets/app_top_bar.dart';
import 'package:book_my_doctor/src/widgets/custom_progress_view.dart';
import 'package:book_my_doctor/src/widgets/image_view.dart';
import 'package:book_my_doctor/src/widgets/rating_start.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'appointment_details.dart';
import 'appointment_rating_screen.dart';
import 'choose_booking_slot.dart';

class AppointmentListPage extends StatefulWidget {
  final bool reviews;
  final String doctorId;

  AppointmentListPage({this.reviews = false, this.doctorId});

  @override
  _AppointmentListPageState createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  UserDetails _user;
  List<Appointment> appointments = [];
  List<UserDetails> patients = [];
  bool _isLoading = false;

  @override
  void initState() {
    _user = Provider.of(context, listen: false);
    // if (_user != null && _user.uid != null) {
    //   WidgetsBinding.instance.addPostFrameCallback(
    //       (_) => _refreshIndicatorStateKey.currentState.show());
    //   myAppointments();
    // }
    super.initState();
  }

  Future<void> myAppointments() async {
    // _isLoading = true;
    // setState(() {});
    appointments.clear();
    if (widget.reviews) {
      appointments =
          await FbCloudServices().getReviewedAppointment(widget.doctorId);
    } else {
      appointments = await FbCloudServices().getAppointmentByUser(_user.uid);
    }
    // _isLoading = false;
    setState(() {});
  }

  GlobalKey<RefreshIndicatorState> _refreshIndicatorStateKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColor.extraLightBlue,
      appBar: AppTopBar(
        title: widget.reviews ? "Patients Review" : "Appointments",
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return StreamBuilder<List<Appointment>>(
          stream: widget.reviews
              ? FbCloudServices().streamReviewedAppointment(widget.doctorId)
              : FbCloudServices().streamAppointmentByUser(_user.uid),
          builder: (context, snapshot) {
            print("Appointments snapshot : ${snapshot.hasData}");
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(LightColor.purple)));
            } else {
              appointments = widget.reviews
                  ? List.from(
                      snapshot.data.where((element) => element.rating != null))
                  : snapshot.data;
              print("Appointments : ${appointments.length}");
              return (appointments == null || appointments.isEmpty)
                  ? Text(
                      "No data found",
                      style: TextStyles.body.black,
                    ).alignCenter
                  : ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        var apmnts = appointments[index];
                        DateTime dateTime = apmnts.date.toDate();
                        print("Status : ${apmnts.status}");
                        return (widget.reviews)
                            ? getReviewTile(apmnts)
                            : Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(8),
                                  leading: ImageView(
                                    width: 48,
                                    height: 48,
                                    icon: apmnts.doctorPhoto,
                                    circle: true,
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Appointment with",
                                            style: TextStyles.bodySm,
                                          ),
                                          Text(" Dr. ${apmnts.doctorName}",
                                              style: TextStyles.bodySm.bold)
                                        ],
                                      ),
                                      Text(
                                        "${apmnts.hospitalAddress}",
                                        style: TextStyles.bodySm,
                                      ).vP4,
                                      Text(
                                        "${ActivityUtils().formattedDate(apmnts.date.toDate(), format: "dd-MM-yyyy, hh:mm a")}",
                                        style: TextStyles.bodySm.grey,
                                      ),
                                      SizedBox(height: 8),
                                      (dateTime.compareTo(DateTime.now()) < 0 &&
                                              apmnts.status ==
                                                  APPOINTMENT_STATUS
                                                      .PENDING.index)
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Share Your Story",
                                                  style: TextStyles.body.purple,
                                                ),
                                                Text(
                                                  "Give Review",
                                                  style: TextStyles.body.purple,
                                                ).ripple(() async {
                                                  await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              AppointmentRatingPage(
                                                                  apmnts)));
                                                  setState(() {});
                                                }),
                                              ],
                                            )
                                          : (apmnts.status ==
                                                  APPOINTMENT_STATUS
                                                      .PENDING.index)
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Reschedule",
                                                      style: TextStyles
                                                          .body.purple,
                                                    ).ripple(() {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) {
                                                            return ChooseBookingSlot(
                                                                apmnts);
                                                          },
                                                        ),
                                                      );
                                                    }),
                                                    Text(
                                                      "Cancel",
                                                      style: TextStyles
                                                          .body.purple,
                                                    ).ripple(() {
                                                      FbCloudServices()
                                                          .updateAppointmentStatus(
                                                              apmnts.id,
                                                              APPOINTMENT_STATUS
                                                                  .CANCELED
                                                                  .index);
                                                      apmnts.status =
                                                          APPOINTMENT_STATUS
                                                              .CANCELED.index;
                                                      setState(() {});
                                                    }),
                                                  ],
                                                )
                                              : (apmnts.status ==
                                                      APPOINTMENT_STATUS
                                                          .DECLINE.index)
                                                  ? Text(
                                                      "Appointment has been cancelled by Doctor.",
                                                      style:
                                                          TextStyles.bodySm.red,
                                                    )
                                                  : (apmnts.status ==
                                                          APPOINTMENT_STATUS
                                                              .CANCELED.index)
                                                      ? Text(
                                                          "Appointment has been cancelled by you.",
                                                          style: TextStyles
                                                              .bodySm.red,
                                                        )
                                                      : Container()
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return AppointmentDetailPage(apmnts);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                      },
                      itemCount: appointments.length,
                    ).hP4;
            }
          },
        );
      }),
    );
  }

  Widget getReviewTile(Appointment booking) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageView(
                  icon: booking?.patientPhoto ?? "user.jpg",
                  width: 48,
                  height: 48,
                  margin: EdgeInsets.only(right: 8),
                  circle: true,
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      color: LightColor.extraLightBlue,
                      borderRadius: BorderRadius.all(Radius.circular(48 / 2))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${booking?.patientName ?? " "}",
                      style: TextStyles.body.bold,
                    ),
                    SizedBox(height: 2),
                    Text(
                      "${timeago.format((booking.reviewedAt ?? booking.date).toDate())}",
                      style: TextStyles.bodySm,
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 2),
            RatingStar(
              rating: booking?.rating?.toDouble() ?? 0,
            ),
            Text(
              "${booking.comment}".trim(),
              style: TextStyles.body.black,
            ),
          ],
        ),
      ),
    );
  }
}
