import 'dart:io';

import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:book_my_doctor/src/pages/doctor_profile_page.dart';
import 'package:book_my_doctor/src/pages/login_page.dart';
import 'package:book_my_doctor/src/services/auth_service.dart';
import 'package:book_my_doctor/src/services/fb_cloud_services.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/utils/activity_utils.dart';
import 'package:book_my_doctor/src/utils/file_handler.dart';
import 'package:book_my_doctor/src/utils/image_handler.dart';
import 'package:book_my_doctor/src/widgets/custom_progress_view.dart';
import 'package:book_my_doctor/src/widgets/edit_text_anim_hint.dart';
import 'package:book_my_doctor/src/widgets/gender_field.dart';
import 'package:book_my_doctor/src/widgets/image_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileGenderPage extends StatefulWidget {
  ProfileGenderPage();

  @override
  _ProfileGenderPageState createState() => _ProfileGenderPageState();
}

class _ProfileGenderPageState extends State<ProfileGenderPage> {
  bool _isLoading = false;
  AuthService _authService;
  UserDetails _user;

  GlobalKey _globalKey = GlobalKey<ScaffoldState>();

  var genderValue;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<UserDetails>(context, listen: false);
    genderValue = _user.gender;
  }

  @override
  void didChangeDependencies() {
    _authService = Provider.of<AuthService>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _globalKey,
      body: CustomProgressView(
        inAsyncCall: _isLoading,
        child: Container(
          height: size.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Positioned(
                top: 0,
                right: 0,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: Image.asset(
                    "assets/images/signup_top.png",
                    width: size.width * 0.35,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Image.asset(
                    "assets/images/main_bottom.png",
                    width: size.width * 0.25,
                  ),
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_outlined),
                          color: Colors.transparent,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ).alignTopLeft.p16,
                        Text(
                          "Skip",
                          style: TextStyles.title
                              .copyWith(fontSize: 20)
                              .purple
                              .bold,
                        ).p16.ripple(_updateGender)
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("Identify\nYour Gender",
                                    style: TextStyles.h1Style)
                                .alignTopLeft
                                .hP16,
                            SizedBox(height: 12),
                            Text("Which gender do you identify with?",
                                    style: TextStyles.bodySm)
                                .alignTopLeft
                                .hP16,
                            SizedBox(height: 64),
                            Container(
                                width: size.width * 0.85,
                                child: GenderField(
                                    ['Male', 'Female', 'Other'], genderValue,
                                    (value) {
                                  genderValue = value;
                                  setState(() {});
                                  _updateGender();
                                })).p8,
                          ],
                        ),
                      ).p16,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _updateGender() async {
    _user.gender = genderValue;
    FbCloudServices().updateUserById(_user);
    if (_user.areYouDoctor) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return DoctorProfilePage();
          },
        ),
      );
    } else {
      ActivityUtils().showSnackBarMessage(context, "Profile updated.");
      Navigator.pushReplacementNamed(context, "/HomePage");
    }
  }
}
