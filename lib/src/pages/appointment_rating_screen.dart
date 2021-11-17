import 'package:book_my_doctor/src/config/constants.dart';
import 'package:book_my_doctor/src/model/appointment.dart';
import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:book_my_doctor/src/services/fb_cloud_services.dart';
import 'package:book_my_doctor/src/services/fb_cloud_services.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/utils/activity_utils.dart';
import 'package:book_my_doctor/src/widgets/app_top_bar.dart';
import 'package:book_my_doctor/src/widgets/custom_progress_view.dart';
import 'package:book_my_doctor/src/widgets/image_view.dart';
import 'package:book_my_doctor/src/widgets/multiline_edit_text.dart';
import 'package:book_my_doctor/src/widgets/rating_start.dart';
import 'package:book_my_doctor/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';

class AppointmentRatingPage extends StatefulWidget {
  final Appointment appointment;

  AppointmentRatingPage(this.appointment);

  @override
  _AppointmentRatingPageState createState() => _AppointmentRatingPageState();
}

class _AppointmentRatingPageState extends State<AppointmentRatingPage> {
  bool _isLoading = false;

  GlobalKey _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  String selectedDay;
  String selectedTime;
  double rating;
  TextEditingController commentEditor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _globalKey,
      appBar: AppTopBar(
        title: "Appointment Details",
      ),
      body: CustomProgressView(
        inAsyncCall: _isLoading,
        child: Container(
          height: size.height,
          width: double.infinity,
          // Here i can use size.width but use double.infinity because both work as a same
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: ImageView(
                    height: 56,
                    width: 56,
                    icon: widget.appointment.doctorPhoto,
                    circle: true,
                  ),
                  title: Text("Dr. ${widget.appointment?.doctorName ?? ""}",
                      style: TextStyles.title.bold),
                ),
                Container(
                  color: LightColor.extraLightBlue,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        "How was your appointment experience?",
                        style: TextStyles.bodySm.titleColor.bold,
                      ).vP16,
                      RatingBar.builder(
                        initialRating: 0,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return Icon(
                                Icons.sentiment_very_dissatisfied,
                                color: Colors.red,
                              );
                            case 1:
                              return Icon(
                                Icons.sentiment_dissatisfied,
                                color: Colors.redAccent,
                              );
                            case 2:
                              return Icon(
                                Icons.sentiment_neutral,
                                color: Colors.amber,
                              );
                            case 3:
                              return Icon(
                                Icons.sentiment_satisfied,
                                color: Colors.lightGreen,
                              );
                            case 4:
                              return Icon(
                                Icons.sentiment_very_satisfied,
                                color: Colors.green,
                              );
                          }
                        },
                        onRatingUpdate: (rate) {
                          rating = rate;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Unpleasant",
                            style: TextStyles.body.purple,
                          ),
                          Text(
                            "Awesome",
                            style: TextStyles.body.purple,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Date & Time", style: TextStyles.bodySm.grey),
                  SizedBox(height: 8),
                  Text(
                      "${ActivityUtils().formattedDate(widget.appointment.date.toDate(), format: "dd-MM-yyyy, hh:mm a")}",
                      style: TextStyles.body.bold)
                ]).p16,
                Divider(thickness: 0.3, color: LightColor.grey, height: 1),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Practice Details", style: TextStyles.bodySm.grey),
                    SizedBox(height: 4),
                    Text("${widget.appointment.hospitalName}",
                        style: TextStyles.body.bold),
                    Text("${widget.appointment.hospitalAddress}",
                        style: TextStyles.body),
                    SizedBox(height: 8),
                    Text("Get Directions", style: TextStyles.body.bold.purple)
                        .ripple(() {
                      MapsLauncher.launchQuery(
                          "${widget.appointment.hospitalAddress}");
                    })
                  ],
                ).p16,
                Divider(thickness: 0.3, color: LightColor.grey),
                MultilineEditText(
                  hint: "Comments",
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  textInputType: TextInputType.multiline,
                  lines: 2,
                  controller: commentEditor,
                  // controller: txtHospitalAddressController,
                ).hP16,
                RoundedButton(
                  text: "SUBMIT",
                  radius: 4,
                  color: LightColor.purpleLight,
                  width: double.infinity,
                  press: () async {
                    _isLoading = true;
                    setState(() {});
                    widget.appointment.rating = rating;
                    widget.appointment.comment = commentEditor.text;
                    widget.appointment.status =
                        APPOINTMENT_STATUS.COMPLETED.index;
                    await FbCloudServices().submitReview(widget.appointment);
                    _isLoading = false;
                    setState(() {});
                    Navigator.pop(context);
                  },
                ).hP16,
                SizedBox(height: 12)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
