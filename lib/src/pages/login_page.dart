import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:book_my_doctor/src/pages/signup_page.dart';
import 'package:book_my_doctor/src/services/auth_service.dart';
import 'package:book_my_doctor/src/services/fb_cloud_services.dart';
import 'package:book_my_doctor/src/utils/activity_utils.dart';
import 'package:book_my_doctor/src/widgets/already_have_an_account_acheck.dart';
import 'package:book_my_doctor/src/widgets/custom_progress_view.dart';
import 'package:book_my_doctor/src/widgets/edit_text.dart';
import 'package:book_my_doctor/src/widgets/edit_text_anim_hint.dart';
import 'package:book_my_doctor/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'complete_profile_page.dart';
import 'home_page.dart';
import 'user_category_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _isLoading = false;

  TextEditingController txtEmailController = TextEditingController();
  TextEditingController txtPasswordController = TextEditingController();

  AuthService _authService;
  UserDetails _userDetails;

  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  void didChangeDependencies() {
    _authService = Provider.of<AuthService>(context);
    _userDetails = Provider.of<UserDetails>(context);
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
            width: double.infinity,
            height: size.height,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image.asset(
                    "assets/images/main_top.png",
                    width: size.width * 0.35,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Image.asset(
                    "assets/images/login_bottom.png",
                    width: size.width * 0.4,
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: size.height * 0.03),
                      SvgPicture.asset(
                        "assets/icons/login.svg",
                        height: size.height * 0.35,
                      ),
                      SizedBox(height: size.height * 0.03),
                      EditTextAnimHint(
                        hint: "Email",
                        margin: EdgeInsets.symmetric(vertical: 8),
                        textInputType: TextInputType.emailAddress,
                        controller: txtEmailController,
                      ),
                      EditTextAnimHint(
                        hint: "Password",
                        obscure: true,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        controller: txtPasswordController,
                      ),
                      RoundedButton(
                        text: "LOGIN",
                        radius: 2,
                        press: _login,
                      ),
                      SizedBox(height: size.height * 0.03),
                      AlreadyHaveAnAccountCheck(
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return UserCategoryPage();
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  bool isValidInput() {
    bool isValid = true;
    String message;
    String email = txtEmailController.text;
    String password = txtPasswordController.text;

    String validEmailMsg = ActivityUtils().validateEmail(email);
    print("validEmailMsg $validEmailMsg");
    if (email == null || email.isEmpty) {
      isValid = false;
      message = "Enter email address";
    } else if (validEmailMsg != null) {
      isValid = false;
      message = validEmailMsg;
    } else if (password == null || password.isEmpty) {
      isValid = false;
      message = "Enter password";
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
            FlatButton(
              child: Text('Okay'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    }
    return isValid;
  }

  _login() async {
    ActivityUtils().hideKeyboard();
    if (isValidInput()) {
      _isLoading = true;
      setState(() {});
      String email = txtEmailController.text;
      String password = txtPasswordController.text;
      var userMap = await _authService.signInWithEmailIDAndPassword(_globalKey,
          email: email, password: password);
      _isLoading = false;
      setState(() {});
      if (userMap != null) {
        UserDetails user = UserDetails.fromJson(userMap);
        print("User Details, Complete : ${user.isComplete}");
        _userDetails.notifyUpdateUser(user);
        if (user.isComplete) {
          Navigator.pushNamedAndRemoveUntil(
              context, "/HomePage", (Route<dynamic> route) => false);
        } else if (user?.gender == null) {
          Navigator.pushNamedAndRemoveUntil(
              context, "/ProfileGenderPage", (Route<dynamic> route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, "/CompleteProfilePage", (Route<dynamic> route) => false,
              arguments: true);
        }
      }
    }
  }
}
