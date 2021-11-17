import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:book_my_doctor/src/pages/login_page.dart';
import 'package:book_my_doctor/src/services/auth_service.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/utils/activity_utils.dart';
import 'package:book_my_doctor/src/widgets/already_have_an_account_acheck.dart';
import 'package:book_my_doctor/src/widgets/custom_progress_view.dart';
import 'package:book_my_doctor/src/widgets/edit_text.dart';
import 'package:book_my_doctor/src/widgets/edit_text_anim_hint.dart';
import 'package:book_my_doctor/src/widgets/image_view.dart';
import 'package:book_my_doctor/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../widgets/or_divider.dart';
import '../widgets/social_icon.dart';

class SignUpPage2 extends StatefulWidget {
  final UserDetails user;

  SignUpPage2({this.user});

  @override
  _SignUpPage2State createState() => _SignUpPage2State();
}

class _SignUpPage2State extends State<SignUpPage2> {
  bool _isLoading = false;
  AuthService _authService;

  TextEditingController txtPasswordController = TextEditingController();
  TextEditingController txtConfirmPasswordController = TextEditingController();

  GlobalKey _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
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
          // Here i can use size.width but use double.infinity because both work as a same
          child: Stack(
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
                left: 0,
                child: Image.asset(
                  "assets/images/main_bottom.png",
                  width: size.width * 0.25,
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 32),
                  IconButton(
                    icon: Icon(Icons.arrow_back_outlined),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ).alignTopLeft.p16,
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Text("Secure\nYour Account",
                                  style: TextStyles.h1Style)
                              .alignTopLeft
                              .hP16,
                          SizedBox(height: 8),
                          Text("Choose your desired password",
                                  style: TextStyles.bodySm)
                              .alignTopLeft
                              .hP16,
                          SizedBox(height: 32),
                          ImageView(
                            icon: widget.user.areYouDoctor
                                ? "images/doctor.png"
                                : "images/patient.png",
                            height: size.height * 0.15,
                          ).alignTopLeft.hP16,
                          EditTextAnimHint(
                            hint: "Password",
                            obscure: true,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            controller: txtPasswordController,
                          ),
                          EditTextAnimHint(
                            hint: "Confirm Password",
                            obscure: true,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            controller: txtConfirmPasswordController,
                          ),
                          SizedBox(height: 8),
                          RoundedButton(
                            text: "SUBMIT",
                            radius: 2,
                            press: _signUp,
                          ),
                          SizedBox(height: 12),
                        ],
                      ),
                    ).p16,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isValidInput() {
    bool isValid = true;
    String message;
    String password = txtPasswordController.text;
    String confirmPassword = txtConfirmPasswordController.text;
    if (password == null || password.isEmpty) {
      isValid = false;
      message = "Enter password";
    } else if (confirmPassword == null || confirmPassword.isEmpty) {
      isValid = false;
      message = "Enter confirm password";
    } else if (password != confirmPassword) {
      isValid = false;
      message = "Password not match with confirm password";
    } else if (ActivityUtils().validatePassword(password) != null) {
      isValid = false;
      message = ActivityUtils().validatePassword(password);
    }

    if (!isValid) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('Okay'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    }
    return isValid;
  }

  _signUp() async {
    if (isValidInput()) {
      ActivityUtils().hideKeyboard();
      _isLoading = true;
      setState(() {});
      String password = txtPasswordController.text;
      var registerUser = await _authService.createUserWithEmailIDAndPassword(
          _globalKey, widget.user,
          password: password);
      _isLoading = false;
      setState(() {});
      if (registerUser != null) {
        ActivityUtils().showSnackBarMessage(context,
            "Account created successfully, Please verify email address.");
        Navigator.pushReplacementNamed(context, "/LoginPage");
      }
    }
  }
}
