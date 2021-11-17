import 'dart:io';

import 'package:book_my_doctor/src/config/constants.dart';
import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:book_my_doctor/src/pages/login_page.dart';
import 'package:book_my_doctor/src/services/auth_service.dart';
import 'package:book_my_doctor/src/services/fb_cloud_services.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/utils/activity_utils.dart';
import 'package:book_my_doctor/src/utils/file_handler.dart';
import 'package:book_my_doctor/src/utils/image_handler.dart';
import 'package:book_my_doctor/src/widgets/app_top_bar.dart';
import 'package:book_my_doctor/src/widgets/custom_progress_view.dart';
import 'package:book_my_doctor/src/widgets/edit_text_anim_hint.dart';
import 'package:book_my_doctor/src/widgets/gender_field.dart';
import 'package:book_my_doctor/src/widgets/image_view.dart';
import 'package:book_my_doctor/src/widgets/multiline_edit_text.dart';
import 'package:book_my_doctor/src/widgets/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CompleteProfilePage extends StatefulWidget {
  final bool isStart;

  CompleteProfilePage({this.isStart = false});

  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  bool _isLoading = false;
  String profilePic;
  File dp;
  bool isLocalPic = false;
  AuthService _authService;
  UserDetails _user;
  TextEditingController txtFirstNameController = TextEditingController();
  TextEditingController txtLastNameController = TextEditingController();
  TextEditingController txtEmailController = TextEditingController();
  TextEditingController txtPhoneController = TextEditingController();
  TextEditingController txtHeightController = TextEditingController();
  TextEditingController txtWeightController = TextEditingController();
  TextEditingController txtAddressController = TextEditingController();

  GlobalKey _globalKey = GlobalKey<ScaffoldState>();

  var genderValue;

  static final kInitialPosition = LatLng(2.07622, 17.60283);
  GeoPoint geoPoint;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<UserDetails>(context, listen: false);
    txtFirstNameController.text = _user.firstName;
    txtLastNameController.text = _user.lastName;
    txtEmailController.text = _user.email;
    txtPhoneController.text = _user.phone;
    txtHeightController.text = "${_user.height ?? ""}";
    txtWeightController.text = "${_user.weight ?? ""}";
    txtAddressController.text = "${_user.address ?? ""}";
    genderValue = _user.gender;
    profilePic = _user.photo;
    setState(() {});
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
      extendBodyBehindAppBar: true,
      backgroundColor: LightColor.extraLightBlue,
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
                left: 0,
                child: Image.asset(
                  "assets/images/signup_top.png",
                  width: size.width * 0.35,
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
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppTopBar(
                      title: "",
                      color: Colors.transparent,
                      leading: widget.isStart
                          ? Container()
                          : IconButton(
                              icon: Icon(Icons.arrow_back_outlined),
                              color: Colors.black,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                      trailing: IconButton(
                        icon: Icon(Icons.logout),
                        color: Colors.black,
                        onPressed: () {
                          _authService.signOutFromFirebase();
                          Navigator.pushNamedAndRemoveUntil(context,
                              "/LoginPage", (Route<dynamic> route) => false);
                        },
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("Complete\nYour Profile",
                                    style: TextStyles.h1Style)
                                .alignTopLeft
                                .hP16,
                            SizedBox(height: 8),
                            profilePic != null
                                ? ImageView(
                                    icon: profilePic,
                                    boxFit: BoxFit.contain,
                                    isFile: isLocalPic,
                                    circle: true,
                                    onPress: _pickImage,
                                    height: 92,
                                    width: 92,
                                    decoration: BoxDecoration(
                                        color: LightColor.extraLightBlue),
                                  ).alignCenterLeft.hP16
                                : ImageView(
                                    icon: _user.areYouDoctor
                                        ? "images/doctor.png"
                                        : "images/patient.png",
                                    height: 92,
                                    width: 92,
                                    boxFit: BoxFit.contain,
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        color: LightColor.purpleExtraLight,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(46))),
                                    onPress: _pickImage,
                                  ).alignCenterLeft.hP16,
                            EditTextAnimHint(
                              hint: "Name",
                              margin: EdgeInsets.symmetric(vertical: 8),
                              textInputType: TextInputType.name,
                              controller: txtFirstNameController,
                            ),
                            EditTextAnimHint(
                              hint: "Surname",
                              margin: EdgeInsets.symmetric(vertical: 8),
                              textInputType: TextInputType.name,
                              controller: txtLastNameController,
                            ),
                            EditTextAnimHint(
                              hint: "Email",
                              margin: EdgeInsets.symmetric(vertical: 8),
                              textInputType: TextInputType.emailAddress,
                              controller: txtEmailController,
                              enable: false,
                            ),
                            EditTextAnimHint(
                              hint: "Phone Number",
                              margin: EdgeInsets.symmetric(vertical: 8),
                              textInputType: TextInputType.phone,
                              controller: txtPhoneController,
                            ),
                            Container(
                                width: size.width * 0.85,
                                child: Column(
                                  children: [
                                    Text("Gender",
                                            style: TextStyles.bodySm.bold.grey)
                                        .alignCenterLeft
                                        .hP8
                                        .vP8,
                                    GenderField(['Male', 'Female', 'Other'],
                                        genderValue, (value) {
                                      genderValue = value;
                                      setState(() {});
                                    }),
                                  ],
                                )),
                            _user.areYouDoctor
                                ? Container()
                                : MultilineEditText(
                                    hint: "Address",
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    textInputType: TextInputType.multiline,
                                    controller: txtAddressController,
                                    suffixIcon: ImageView(
                                        width: 24,
                                        height: 24,
                                        iconData: Icons.location_pin,
                                        color: LightColor.purple,
                                        onPress: () async {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => PlacePicker(
                                          //       apiKey: GOOGLE_MAP_API_KEY,
                                          //       onPlacePicked: onPickedPlace,
                                          //       enableMyLocationButton: true,
                                          //       enableMapTypeButton: true,
                                          //       initialPosition:
                                          //           kInitialPosition,
                                          //       useCurrentLocation: true,
                                          //     ),
                                          //   ),
                                          // );
                                          LocationResult result =
                                              await showLocationPicker(
                                            context,
                                            GOOGLE_MAP_API_KEY,
                                            myLocationButtonEnabled: true,
                                            layersButtonEnabled: true,
                                            desiredAccuracy:
                                                LocationAccuracy.best,
                                            initialCenter:
                                                LatLng(2.07622, 17.60283),
                                          );
                                          onPickedPlace(result);
                                        }),
                                  ),
                            _user.areYouDoctor
                                ? Container()
                                : EditTextAnimHint(
                                    hint: "Height",
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    textInputType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    controller: txtHeightController,
                                  ),
                            _user.areYouDoctor
                                ? Container()
                                : EditTextAnimHint(
                                    hint: "Weight",
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    textInputType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    controller: txtWeightController,
                                  ),
                            SizedBox(height: 12),
                            RoundedButton(
                              text: _user.areYouDoctor ? "NEXT" : "COMPLETE",
                              radius: 2,
                              width: size.width * 0.82,
                              press: _update,
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ).hP16,
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

  bool isValidInput() {
    bool isValid = true;
    String message;
    String firstName = txtFirstNameController.text;
    String lastName = txtLastNameController.text;
    String email = txtEmailController.text;
    String phone = txtPhoneController.text;
    if (firstName == null || firstName.isEmpty) {
      isValid = false;
      message = "Enter first name";
    } else if (lastName == null || lastName.isEmpty) {
      isValid = false;
      message = "Enter last name";
    } else if (email == null || email.isEmpty) {
      isValid = false;
      message = "Enter email address";
    } else if (ActivityUtils().validateEmail(email) != null) {
      isValid = false;
      message = ActivityUtils().validateEmail(email);
    } else if (phone == null || phone.isEmpty) {
      isValid = false;
      message = "Enter phone number";
    } else if (genderValue == null || genderValue.isEmpty) {
      isValid = false;
      message = "Select gender";
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

  _pickImage() async {
    File image = await ImageHandler.get().getImage(context);
    if (image != null) {
      dp = image;
      profilePic = dp.path;
      isLocalPic = true;
      setState(() {});
    }
  }

  _update() async {
    if (isValidInput()) {
      ActivityUtils().hideKeyboard();
      _isLoading = true;
      setState(() {});
      String firstName = txtFirstNameController.text;
      String lastName = txtLastNameController.text;
      String email = txtEmailController.text;
      String phone = txtPhoneController.text;
      String heightValue = txtHeightController.text;
      String weightValue = txtWeightController.text;
      String address = txtAddressController.text;
      _user.firstName = firstName;
      _user.lastName = lastName;
      _user.email = email;
      _user.phone = phone;
      _user.gender = genderValue;
      _user.height = double.parse(heightValue.isNotEmpty ? heightValue : "0.0");
      _user.weight = double.parse(weightValue.isNotEmpty ? weightValue : "0.0");
      _user.address = address;
      if (geoPoint == null && (address != null && address.length > 0)) {
        geoPoint = await ActivityUtils().getGeoPointFromAddress(address);
      }
      _user.addressGeoPoint = geoPoint;
      _user.isComplete = true;
      if (dp != null) {
        String dpUrl =
            await FileHandler.get().uploadFileToFirebase(dp, onData: (value) {
          print("Uploading Progress $value");
        });
        _user.photo = dpUrl;
        await FbCloudServices().updateUserProfile(_user.uid, dpUrl);
      }
      await FbCloudServices().updateUserById(_user);
      _isLoading = false;
      setState(() {});
      if (_user.areYouDoctor) {
        Navigator.pushNamed(context, "/DoctorProfilePage");
      } else {
        ActivityUtils().showSnackBarMessage(context, "Profile updated.");
        Navigator.pushReplacementNamed(context, "/HomePage");
      }
    }
  }

  onPickedPlace(LocationResult result) {
    if (result != null) {
      print(result.address);
      txtAddressController.text = result.address;
      LatLng location = result.latLng;
      print(location.toString());
      if (location != null) {
        geoPoint = GeoPoint(location.latitude, location.longitude);
      }
      // Navigator.of(context).pop();
    }
  }
}
