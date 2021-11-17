import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:flutter/material.dart';

class AppointmentSuccessfulPage extends StatefulWidget {
  AppointmentSuccessfulPage();

  @override
  _AppointmentSuccessfulPageState createState() =>
      _AppointmentSuccessfulPageState();
}

class _AppointmentSuccessfulPageState extends State<AppointmentSuccessfulPage> {
  GlobalKey _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(
          context, "/HomePage", (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.thumb_up, size: 100, color: LightColor.purpleLight)
                .alignCenter,
            Text("Appointment booked\nsuccessfully!",
                    textAlign: TextAlign.center,
                    style: TextStyles.title.bold.purple)
                .vP4
                .alignCenter,
          ],
        ),
      ),
    );
  }
}
