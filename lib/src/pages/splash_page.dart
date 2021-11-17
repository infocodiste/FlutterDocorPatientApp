import 'package:book_my_doctor/src/config/constants.dart';
import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:book_my_doctor/src/pages/login_page.dart';
import 'package:book_my_doctor/src/services/auth_service.dart';
import 'package:book_my_doctor/src/services/fb_cloud_services.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/utils/activity_utils.dart';
import 'package:book_my_doctor/src/utils/preference_handler.dart';
import 'package:book_my_doctor/src/widgets/app_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'welcome_page.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool showButton = false;

  @override
  void initState() {
    super.initState();
    _moveNextScreen();
  }

  _moveNextScreen() async {
    _userDetails = Provider.of<UserDetails>(this.context, listen: false);
    await Future.delayed(Duration(seconds: 3));
    AuthService authService = Provider.of<AuthService>(this.context, listen: false);
    User user = authService.currentUser();
    // print("User ${user.toString()}");
    if (user != null && user.emailVerified) {
      var uDetail = await FbCloudServices().getUserById(user.uid);
      if (uDetail == null) {
        await authService.signOutFromFirebase();
        bool isStarted = await PreferenceHandler.instance.getBool(PREF_STARTED);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => isStarted ? LoginPage() : WelcomePage()));
      } else {
        print("UserDetails ${uDetail.toString()}");
        _userDetails.notifyUpdateUser(uDetail);
        if (_userDetails.isComplete) {
          Navigator.pushNamedAndRemoveUntil(
              context, "/HomePage", (Route<dynamic> route) => false);
        } else if (_userDetails?.gender == null) {
          Navigator.pushNamedAndRemoveUntil(
              context, "/ProfileGenderPage", (Route<dynamic> route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, "/CompleteProfilePage", (Route<dynamic> route) => false,
              arguments: true);
        }
      }
    } else {
      bool isStarted = await PreferenceHandler.instance.getBool(PREF_STARTED);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => isStarted ? LoginPage() : WelcomePage()));
    }
  }

  UserDetails _userDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Container(
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage("assets/doctor_face.jpg"),
          //       fit: BoxFit.fill,
          //     ),
          //   ),
          // ),
          Positioned.fill(
            child: Opacity(
              opacity: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [LightColor.purpleExtraLight, LightColor.purple],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      tileMode: TileMode.mirror,
                      stops: [.5, 6]),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AppLogo(),
                // SizedBox(
                //   height: 24,
                // ),
                // (!showButton)
                //     ? Container()
                //     : Column(
                //         children: [
                //           SizedBox(
                //             height: 24,
                //           ),
                //           _loginButton(),
                //           SizedBox(
                //             height: 24,
                //           ),
                //           _signUpButton(),
                //           SizedBox(
                //             height: 24,
                //           ),
                //         ],
                //       )
              ],
            ).alignBottomCenter,
          ),
        ],
      ),
    );
  }
//
// Widget _loginButton() {
//   return InkWell(
//     onTap: () {
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => LoginPage()));
//     },
//     child: Container(
//       width: MediaQuery.of(context).size.width,
//       padding: EdgeInsets.symmetric(vertical: 13),
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(5)),
//           boxShadow: <BoxShadow>[
//             BoxShadow(
//                 color: LightColor.purple.withAlpha(100),
//                 offset: Offset(2, 4),
//                 blurRadius: 8,
//                 spreadRadius: 2)
//           ],
//           color: Colors.white),
//       child: Text(
//         'Login',
//         style: TextStyle(fontSize: 20, color: LightColor.purpleLight),
//       ),
//     ),
//   );
// }
//
// Widget _signUpButton() {
//   return InkWell(
//     onTap: () {
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => SignUpPage()));
//     },
//     child: Container(
//       width: MediaQuery.of(context).size.width,
//       padding: EdgeInsets.symmetric(vertical: 13),
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(5)),
//         border: Border.all(color: Colors.white, width: 2),
//       ),
//       child: Text(
//         'Register now',
//         style: TextStyle(fontSize: 20, color: Colors.white),
//       ),
//     ),
//   );
// }
}
