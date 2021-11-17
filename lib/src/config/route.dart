import 'package:book_my_doctor/src/pages/appointment_successful_page.dart';
import 'package:book_my_doctor/src/pages/complete_profile_page.dart';
import 'package:book_my_doctor/src/pages/doctor_profile_page.dart';
import 'package:book_my_doctor/src/pages/login_page.dart';
import 'package:book_my_doctor/src/pages/profile_gender_page.dart';
import 'package:book_my_doctor/src/pages/signup_page.dart';
import 'package:book_my_doctor/src/pages/signup_page2.dart';
import 'package:book_my_doctor/src/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:book_my_doctor/src/pages/detail_page.dart';
import 'package:book_my_doctor/src/pages/home_page.dart';
import 'package:book_my_doctor/src/pages/splash_page.dart';
import 'package:book_my_doctor/src/widgets/coustom_route.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      '/': (_) => SplashPage(),
      '/WelcomePage': (_) => WelcomePage(),
      // '/SignUpPage': (_) => SignUpPage(),
      '/LoginPage': (_) => LoginPage(),
      '/ProfilePage': (_) => CompleteProfilePage(),
      '/DoctorProfilePage': (_) => DoctorProfilePage(),
      '/ProfileGenderPage': (_) => ProfileGenderPage(),
      // '/CompleteProfilePage': (_) => CompleteProfilePage(),
      '/HomePage': (_) => HomePage(),
      '/AppointmentSuccessful': (_) => AppointmentSuccessfulPage(),
    };
  }

  static Route onGenerateRoute(RouteSettings settings) {
    final List<String> pathElements = settings.name.split('/');
    if (pathElements[0] != '' || pathElements.length == 1) {
      return null;
    }
    switch (pathElements[1]) {
      case "DetailPage":
        return CustomRoute<bool>(
            builder: (BuildContext context) =>
                DetailPage(doctor: settings.arguments));
      case "SignUpPage":
        return CustomRoute<bool>(
            builder: (BuildContext context) =>
                SignUpPage(areDoctor: settings.arguments));
      case "SignUpPage2":
        return CustomRoute<bool>(
            builder: (BuildContext context) =>
                SignUpPage2(user: settings.arguments));
      case "CompleteProfilePage":
        return CustomRoute<bool>(
            builder: (BuildContext context) =>
                CompleteProfilePage(isStart: settings.arguments));
    }
  }
}
