import 'dart:io';

import 'package:book_my_doctor/src/config/constants.dart';
import 'package:book_my_doctor/src/model/doctor.dart';
import 'package:book_my_doctor/src/model/user_details.dart';
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

// import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:google_maps_webservice/geolocation.dart';
import 'package:provider/provider.dart';

class DoctorProfilePage extends StatefulWidget {
  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  bool _isLoading = false;
  String profilePic;
  bool isLocalPic = false;
  bool areDoctor = false;
  UserDetails _user;
  TextEditingController txtSpecializationController = TextEditingController();
  TextEditingController txtDescriptionController = TextEditingController();
  TextEditingController txtHospitalNameController = TextEditingController();
  TextEditingController txtHospitalAddressController = TextEditingController();
  TextEditingController txtFeeController = TextEditingController();
  TextEditingController txtExperienceController = TextEditingController();

  GlobalKey _globalKey = GlobalKey<ScaffoldState>();

  var genderValue;

  Doctor _doctor;
  GeoPoint hospitalGeoPoint;

  List<String> referenceImages = [];

  @override
  void initState() {
    super.initState();
    _user = Provider.of<UserDetails>(context, listen: false);
    if (_user != null) {
      _getDoctor();
    }
  }

  _getDoctor() async {
    _doctor = await FbCloudServices().getDoctorByUserId(_user.uid);
    print("Get Doctor Profile : ${_doctor.toJson()}");
    txtSpecializationController.text = _doctor.specialization;
    txtDescriptionController.text = _doctor.description;
    txtHospitalNameController.text = _doctor.hospitalName;
    txtHospitalAddressController.text = _doctor.hospitalAddress;
    txtFeeController.text = "${_doctor.consultFee ?? ""}";
    txtExperienceController.text = "${_doctor.experience ?? ""}";
    print("Get Doctor Reference : ${_doctor.referenceImages.length}");
    referenceImages = _doctor.referenceImages;
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _globalKey,
      extendBodyBehindAppBar: true,
      backgroundColor: LightColor.extraLightBlue,
      appBar: AppTopBar(
        title: "",
        color: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 72),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("About\nYour Practice",
                                    style: TextStyles.h1Style)
                                .alignTopLeft
                                .hP16,
                            SizedBox(height: 8),
                            EditTextAnimHint(
                              hint: "Specialization",
                              margin: EdgeInsets.symmetric(vertical: 8),
                              textInputType: TextInputType.name,
                              controller: txtSpecializationController,
                            ),
                            MultilineEditText(
                              hint: "Description",
                              margin: EdgeInsets.symmetric(vertical: 8),
                              textInputType: TextInputType.multiline,
                              controller: txtDescriptionController,
                            ),
                            EditTextAnimHint(
                              hint: "Hospital Name",
                              margin: EdgeInsets.symmetric(vertical: 8),
                              textInputType: TextInputType.name,
                              controller: txtHospitalNameController,
                            ),
                            MultilineEditText(
                              hint: "Hospital Address",
                              margin: EdgeInsets.symmetric(vertical: 8),
                              textInputType: TextInputType.multiline,
                              controller: txtHospitalAddressController,
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
                                    //       // Put YOUR OWN KEY here.
                                    //       onPlacePicked: onPickedPlace,
                                    //       initialPosition:
                                    //           LatLng(2.07622, 17.60283),
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
                                      desiredAccuracy: LocationAccuracy.best,
                                      initialCenter: LatLng(2.07622, 17.60283),
                                    );
                                    onPickedPlace(result);
                                  }),
                            ),
                            EditTextAnimHint(
                              hint: "Fee",
                              margin: EdgeInsets.symmetric(vertical: 8),
                              textInputType: TextInputType.number,
                              controller: txtFeeController,
                            ),
                            EditTextAnimHint(
                              hint: "Experience (in years)",
                              margin: EdgeInsets.symmetric(vertical: 8),
                              controller: txtExperienceController,
                              textInputType: TextInputType.number,
                            ),
                            SizedBox(
                              width: size.width * 0.8,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Upload pictures of what you want the hospital to look like.",
                                      style: TextStyles.bodySm.grey,
                                    ),
                                  ),
                                  ImageView(
                                    icon: "images/ic_upload.png",
                                    color: LightColor.black,
                                    height: 36,
                                    onPress: () async {
                                      File image = await ImageHandler.get()
                                          .getImage(context);
                                      referenceImages.add(image.path);
                                      setState(() {});
                                    },
                                  )
                                ],
                              ),
                            ),
                            (referenceImages != null &&
                                    referenceImages.length > 0)
                                ? Container(
                                    margin: EdgeInsets.only(top: 12),
                                    width: size.width * 0.8,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: referenceImages
                                            .map((e) => Stack(
                                                  alignment: Alignment.topRight,
                                                  children: [
                                                    ImageView(
                                                      icon: e,
                                                      isFile:
                                                          !e.startsWith("http"),
                                                      height: size.width * 0.25,
                                                      width: size.width * 0.25,
                                                      margin: EdgeInsets.only(
                                                          left: 4,
                                                          top: 4,
                                                          right: 4),
                                                    ),
                                                    ImageView(
                                                      icon:
                                                          "images/ic_close.png",
                                                      width: 16,
                                                      height: 16,
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white),
                                                      onPress: () {
                                                        referenceImages
                                                            .remove(e);
                                                        setState(() {});
                                                      },
                                                    )
                                                  ],
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  )
                                : Container(),
                            SizedBox(height: 12),
                            RoundedButton(
                              text: "SUBMIT",
                              radius: 2,
                              width: size.width * 0.8,
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
    String specialization = txtSpecializationController.text;
    String description = txtDescriptionController.text;
    String hospitalName = txtHospitalNameController.text;
    String hospitalAddress = txtHospitalAddressController.text;
    String fee = txtFeeController.text;
    if (specialization == null || specialization.isEmpty) {
      isValid = false;
      message = "Enter your specialization";
    } else if (description == null || description.isEmpty) {
      isValid = false;
      message = "Enter about your specialization";
    } else if (hospitalName == null || hospitalName.isEmpty) {
      isValid = false;
      message = "Enter hospital name";
    } else if (hospitalAddress == null || hospitalAddress.isEmpty) {
      isValid = false;
      message = "Enter hospital address";
    } else if (fee == null || fee.isEmpty) {
      isValid = false;
      message = "Enter consultancy fees.";
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

  onPickedPlace(LocationResult result) {
    if (result != null) {
      print(result.address);
      txtHospitalAddressController.text = result.address;
      LatLng location = result.latLng;
      print(location.toString());
      if (location != null) {
        hospitalGeoPoint = GeoPoint(location.latitude, location.longitude);
      }
    }
  }

  List<String> uploadReferenceImages = [];

  int uploadIndex = 0;

  uploadReferenceMedia(String filePath) async {
    print("Gallery List Size : ${referenceImages.length}");
    String uploadedUrl;
    if (filePath.startsWith("http")) {
      uploadedUrl = filePath;
    } else {
      uploadedUrl =
          await FileHandler.get().uploadFileToFirebase(File(filePath));
    }
    uploadReferenceImages.add(uploadedUrl);
    uploadIndex++;
    if (uploadIndex < referenceImages.length) {
      await uploadReferenceMedia(referenceImages[uploadIndex]);
    }
  }

  _update() async {
    if (isValidInput()) {
      ActivityUtils().hideKeyboard();
      _isLoading = true;
      setState(() {});
      // if (_doctor == null) {
      //   _doctor = await FbCloudServices().getDoctorByUserId(_user.uid);
      // }
      String specialization = txtSpecializationController.text;
      String description = txtDescriptionController.text;
      String hospitalName = txtHospitalNameController.text;
      String hospitalAddress = txtHospitalAddressController.text;
      String fee = txtFeeController.text;
      String experience = txtExperienceController.text;
      if (hospitalGeoPoint == null &&
          (hospitalAddress != null && hospitalAddress.length > 0)) {
        hospitalGeoPoint =
            await ActivityUtils().getGeoPointFromAddress(hospitalAddress);
      }
      _doctor.specialization = specialization;
      _doctor.description = description;
      _doctor.hospitalName = hospitalName;
      _doctor.hospitalAddress = hospitalAddress;
      _doctor.hospitalGeoPoint = hospitalGeoPoint;
      _doctor.areYouDoctor = true;
      _doctor.consultFee = int.parse(fee.isNotEmpty ? fee : "0");
      _doctor.experience = int.parse(experience.isNotEmpty ? experience : "0");
      _doctor.isComplete = true;

      uploadIndex = 0;
      uploadReferenceImages.clear();
      if (referenceImages != null && referenceImages.length > 0) {
        await uploadReferenceMedia(referenceImages[uploadIndex]);
      }
      _doctor.referenceImages = uploadReferenceImages;

      await FbCloudServices().updateDoctor(_doctor);
      _isLoading = false;
      setState(() {});
      ActivityUtils().showSnackBarMessage(context, "Profile updated.");
      Navigator.pushReplacementNamed(context, "/HomePage");
    }
  }
}

// https://www.sac.gov.in/SACSITE/AMO_LIST_AS_ON_%2001-06-2017_New.pdf
