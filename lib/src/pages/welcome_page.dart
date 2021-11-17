import 'package:book_my_doctor/src/config/constants.dart';
import 'package:book_my_doctor/src/pages/login_page.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/utils/preference_handler.dart';
import 'package:book_my_doctor/src/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final List<Slide> slides = [];

  @override
  void initState() {
    super.initState();
    slides.add(
      new Slide(
        marginTitle: EdgeInsets.zero,
        centerWidget: SvgPicture.asset(
          "assets/icons/login.svg",
          height: 150,
        ),
        description:
            "Instantly book an appointment, reschedule it and visit your past and upcoming appointment without any hassle, direct from home.",
        styleDescription: TextStyles.bodySm.white,
        backgroundColor: Colors.transparent,
      ),
    );
    slides.add(
      new Slide(
        marginTitle: EdgeInsets.zero,
        centerWidget: SvgPicture.asset(
          "assets/icons/signup.svg",
          height: 150,
        ),
        description:
            "Get consistent reminders & notifications to schedule checkups, diet, timely medication, health check.",
        styleDescription: TextStyles.bodySm.white,
        backgroundColor: Colors.transparent,
      ),
    );
    slides.add(
      new Slide(
        marginTitle: EdgeInsets.zero,
        centerWidget: SvgPicture.asset(
          "assets/icons/login.svg",
          height: 150,
        ),
        description:
            "Let's move ahead from the manual method to the digitization.",
        styleDescription: TextStyles.bodySm.white,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  void onDonePress() {
    PreferenceHandler.instance.setBool(PREF_STARTED, true);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      height: size.height,
      width: double.infinity,
      color: LightColor.purple,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_top.png",
              width: size.width * 0.3,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_bottom.png",
              width: size.width * 0.2,
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                SizedBox(height: size.height * 0.05),
                AppLogo(),
                SizedBox(height: size.height * 0.05),
                Expanded(
                  child: Stack(
                    children: [
                      IntroSlider(
                        slides: this.slides,
                        onDonePress: this.onDonePress,
                        nameDoneBtn: "START",
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
