import 'package:book_my_doctor/src/model/appointment.dart';
import 'package:book_my_doctor/src/model/doctor.dart';
import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:book_my_doctor/src/services/fb_cloud_services.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/utils/activity_utils.dart';
import 'package:book_my_doctor/src/widgets/app_top_bar.dart';
import 'package:book_my_doctor/src/widgets/custom_progress_view.dart';
import 'package:book_my_doctor/src/widgets/image_view.dart';
import 'package:book_my_doctor/src/widgets/time_slot_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'appointment_confirmation.dart';

class ChooseBookingSlot extends StatefulWidget {
  final Appointment appointment;

  ChooseBookingSlot(this.appointment);

  @override
  _ChooseBookingSlotState createState() => _ChooseBookingSlotState();
}

class _ChooseBookingSlotState extends State<ChooseBookingSlot> {
  bool _isLoading = false;

  GlobalKey _globalKey = GlobalKey<ScaffoldState>();
  UserDetails _user;
  Doctor _doctor;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<UserDetails>(context, listen: false);
    FbCloudServices().getDoctorByUserId(widget.appointment.doctorId).then((dr) {
      _doctor = dr;
      setState(() {});
    });
    getNextSevenDays();
  }

  List<String> days = [];
  List<DateTime> dates = [];
  String selectedDay;
  DateTime selectedDate;
  List<String> morningSlot;
  List<String> noonSlot;
  List<String> eveningSlot;
  String selectedTime;

  getNextSevenDays() {
    var today = DateTime.now();
    var todayEnd = DateTime(today.year, today.month, today.day, 20, 30);
    bool isBefore = today.isBefore(todayEnd);
    List.generate(30, (index) => index).forEach((e) {
      DateTime dateTime = today.add(Duration(days: (e + (isBefore ? 0 : 1))));
      String day = ActivityUtils().formattedDate(dateTime);
      if (!day.contains("Sun")) {
        days.add(ActivityUtils().formattedDate(dateTime));
        dates.add(dateTime);
      }
    });
    selectedDay = days[0];
    selectedDate = dates[0];
    getSlots();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _globalKey,
      backgroundColor: LightColor.extraLightBlue,
      body: CustomProgressView(
        inAsyncCall: _isLoading,
        child: Container(
          height: size.height,
          width: double.infinity,
          // Here i can use size.width but use double.infinity because both work as a same
          child: Column(
            children: [
              AppTopBar(
                title: "",
                color: Colors.transparent,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_outlined),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    children: <Widget>[
                      Text("Choose\nBooking Slot", style: TextStyles.h1Style)
                          .alignTopLeft,
                      SizedBox(height: 8),
                      Text("Choose your booking slot", style: TextStyles.bodySm)
                          .alignTopLeft,
                      SizedBox(height: 8),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ImageView(
                          height: 56,
                          width: 56,
                          icon: _doctor?.photo ?? "",
                          circle: true,
                        ),
                        title: Text(
                            "Dr. ${_doctor?.firstName ?? ""} ${_doctor?.lastName ?? ""}",
                            style: TextStyles.title.bold),
                        subtitle: Text(
                          _doctor?.specialization ?? "",
                          style: TextStyles.bodySm.subTitleColor.bold,
                        ),
                      ),
                      Divider(
                        thickness: .3,
                        color: LightColor.grey,
                      ),
                      Text("Choose a date", style: TextStyles.title.bold)
                          .alignCenterLeft
                          .p8,
                      SlotView(days, selectedDay, onChange: (value) {
                        print("Time slot Value : $value");
                        selectedDay = value;
                        int dayIndex = days.indexOf(selectedDay);
                        selectedDate = dates[dayIndex];
                        getSlots();
                      }),
                      // CalendarTimeline(
                      //   showYears: false,
                      //   initialDate: selectedDate,
                      //   firstDate: DateTime.now(),
                      //   lastDate: DateTime.now().add(Duration(days: 30)),
                      //   onDateSelected: (date) {
                      //     selectedDate = date;
                      //     getSlots();
                      //   },
                      //   monthColor: LightColor.black,
                      //   dayColor: Colors.teal[200],
                      //   dayNameColor: Color(0xFF333A47),
                      //   activeDayColor: LightColor.black,
                      //   activeBackgroundDayColor: Colors.redAccent[100],
                      //   dotsColor: Color(0xFF333A47),
                      //   selectableDayPredicate: (date) => date.day != 23,
                      //   locale: 'en',
                      // ),
                      // Divider(
                      //   thickness: .3,
                      //   color: LightColor.grey,
                      // ),
                      // Text(selectedDay, style: TextStyles.title.bold).vP8,
                      Divider(
                        thickness: .3,
                        color: LightColor.grey,
                      ),
                      Text("Choose suitable time", style: TextStyles.title.bold)
                          .alignCenterLeft
                          .vP8,
                      morningSlot != null && morningSlot.length > 0
                          ? Column(
                              children: [
                                Text("Morning Slots",
                                        style: TextStyles.body.bold)
                                    .alignCenterLeft
                                    .vP8,
                                SlotView(morningSlot, selectedTime,
                                    hasWrap: true, onChange: (value) {
                                  print("Time slot Value : $value");
                                  selectedTime = value;
                                  setState(() {});
                                  openConfirmation();
                                }),
                                SizedBox(height: 4),
                              ],
                            )
                          : Container(),
                      noonSlot != null && noonSlot.length > 0
                          ? Column(
                              children: [
                                Text("Afternoon Slots",
                                        style: TextStyles.body.bold)
                                    .alignCenterLeft
                                    .vP4,
                                SlotView(noonSlot, selectedTime, hasWrap: true,
                                    onChange: (value) {
                                  print("Time slot Value : $value");
                                  selectedTime = value;
                                  setState(() {});
                                  openConfirmation();
                                }),
                                SizedBox(height: 4),
                              ],
                            )
                          : Container(),
                      eveningSlot != null && eveningSlot.length > 0
                          ? Column(
                              children: [
                                Text("Evening Slots",
                                        style: TextStyles.body.bold)
                                    .alignCenterLeft
                                    .vP4,
                                SlotView(eveningSlot, selectedTime,
                                    hasWrap: true, onChange: (value) {
                                  print("Time slot Value : $value");
                                  selectedTime = value;
                                  setState(() {});
                                  openConfirmation();
                                }),
                              ],
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getSlots() {
    DateTime dateTimeNow = DateTime.now();
    DateTime todayDateOnly =
        DateTime(dateTimeNow.year, dateTimeNow.month, dateTimeNow.day);
    DateTime selectedDateOnly =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    DateTime todayNow;
    if (todayDateOnly.compareTo(selectedDateOnly) < 0) {
      todayNow = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, 10, 0);
    } else {
      int hrs = selectedDate.hour;
      // print("Date Time Hrs: ${hrs.toString()}");
      int mns = selectedDate.minute;
      // print("Date Time mns: ${mns.toString()}");
      if (mns > 30) {
        hrs = hrs + 1;
        mns = 0;
      } else {
        mns = 30;
      }
      todayNow = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, hrs, mns);
    }
    DateTime morning = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 10, 00);
    DateTime noonStart = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 12, 00);
    DateTime noonEnd = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 14, 00);
    DateTime eveningStart = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 17, 00);
    DateTime eveningEnd = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 21, 00);

    // print("todayNow: ${todayNow.toString()}");
    // print("morning: ${morning.toString()}");
    // print("noonStart: ${noonStart.toString()}");
    // print("noonEnd: ${noonEnd.toString()}");
    // print("eveningStart: ${eveningStart.toString()}");
    // print("eveningEnd: ${eveningEnd.toString()}");

    morningSlot = [];
    noonSlot = [];
    eveningSlot = [];

    while (todayNow.isBefore(eveningEnd)) {
      if (todayNow.compareTo(morning) >= 0 && todayNow.isBefore(noonStart)) {
        String slot =
            ActivityUtils().formattedDate(todayNow, format: "hh:mm a");
        morningSlot.add(slot);
      } else if (todayNow.compareTo(noonStart) >= 0 &&
          todayNow.isBefore(noonEnd)) {
        String slot =
            ActivityUtils().formattedDate(todayNow, format: "hh:mm a");
        noonSlot.add(slot);
      } else if (todayNow.compareTo(eveningStart) >= 0 &&
          todayNow.isBefore(eveningEnd)) {
        String slot =
            ActivityUtils().formattedDate(todayNow, format: "hh:mm a");
        eveningSlot.add(slot);
      }
      todayNow = todayNow.add(Duration(minutes: 30));
      // print("todayNow add: ${todayNow.toString()}");
    }
    setState(() {});
  }

  openConfirmation() async {
    String time = selectedTime.split(" ").first;
    List<String> hrMn = time.split(":");
    int hrs = int.parse(hrMn.first);
    // print("Date Time Hrs: ${hrs.toString()}");
    int mns = int.parse(hrMn.last);
    // print("Date Time Mns: ${mns.toString()}");
    DateTime dt = ActivityUtils().getDateTime("$selectedDay $selectedTime",
        format: "EEEEE, dd MMM hh:mm a");
    DateTime dateTime = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, dt.hour, dt.minute);
    // print("Date Time : ${dateTime.toString()}");

    bool hasAppointment = await FbCloudServices()
        .hasAppointmentAtTimestamp(_user.uid, Timestamp.fromDate(dateTime));

    if (!hasAppointment) {
      widget.appointment.patientId = _user.uid;
      widget.appointment.patientName =
          "${_user?.firstName ?? ""} ${_user?.lastName ?? ""}";
      widget.appointment.patientPhoto = _user.photo;
      widget.appointment.date = Timestamp.fromDate(dateTime);
      widget.appointment.timeSlot = selectedTime;
      widget.appointment.createdAt = Timestamp.now();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return AppointmentConfirmationPage(widget.appointment);
          },
        ),
      );
    } else {
      ActivityUtils().showAlertDialog(context,
          "You can not book multiple appointment on same date & time.");
    }
  }
}
