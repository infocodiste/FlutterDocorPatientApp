import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:book_my_doctor/src/pages/signup_page.dart';
import 'package:book_my_doctor/src/services/auth_service.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/utils/activity_utils.dart';
import 'package:book_my_doctor/src/widgets/custom_progress_view.dart';
import 'package:book_my_doctor/src/widgets/image_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserCategoryPage extends StatefulWidget {
  @override
  _UserCategoryPageState createState() => _UserCategoryPageState();
}

class _UserCategoryPageState extends State<UserCategoryPage> {
  bool _isLoading = false;
  AuthService _authService;
  TextEditingController txtFirstNameController = TextEditingController();
  TextEditingController txtLastNameController = TextEditingController();
  TextEditingController txtEmailController = TextEditingController();
  TextEditingController txtPhoneController = TextEditingController();
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
                    "assets/images/main_top.png",
                    width: size.width * 0.25,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 64),
                  Text("Know\nYour Category", style: TextStyles.h1Style).hP16,
                  SizedBox(height: 8),
                  Text("We want to know your category",
                      style: TextStyles.bodySm).hP16,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 32),
                            ImageView(icon: "images/doctor.png")
                                .alignCenter
                                .ripple(() {
                              _onSignUp(true);
                            }),
                            Text("Doctor", style: TextStyles.title.bold)
                                .alignCenter
                                .vP8,
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(height: 32),
                            ImageView(icon: "images/patient.png")
                                .alignCenter
                                .ripple(() {
                              _onSignUp(false);
                            }),
                            Text("Patient", style: TextStyles.title.bold)
                                .alignCenter
                                .vP8,
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ).p16
            ],
          ),
        ),
      ),
    );
  }

  _onSignUp(bool areDoctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SignUpPage(areDoctor: areDoctor);
        },
      ),
    );
  }
}
