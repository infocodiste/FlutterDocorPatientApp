import 'dart:io';

import 'package:book_my_doctor/src/config/constants.dart';
import 'package:book_my_doctor/src/model/appointment.dart';
import 'package:book_my_doctor/src/model/doctor.dart';
import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:book_my_doctor/src/pages/appointment_successful_page.dart';
import 'package:book_my_doctor/src/services/fb_cloud_services.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/utils/activity_utils.dart';
import 'package:book_my_doctor/src/widgets/app_top_bar.dart';
import 'package:book_my_doctor/src/widgets/custom_progress_view.dart';
import 'package:book_my_doctor/src/widgets/edit_text.dart';
import 'package:book_my_doctor/src/widgets/edit_text_anim_hint.dart';
import 'package:book_my_doctor/src/widgets/image_view.dart';
import 'package:book_my_doctor/src/widgets/rounded_button.dart';
import 'package:book_my_doctor/src/widgets/time_slot_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AppointmentConfirmationPage extends StatefulWidget {
  final Appointment appointment;

  AppointmentConfirmationPage(this.appointment);

  @override
  _AppointmentConfirmationPageState createState() =>
      _AppointmentConfirmationPageState();
}

class _AppointmentConfirmationPageState
    extends State<AppointmentConfirmationPage> {
  bool _isLoading = false;

  GlobalKey _globalKey = GlobalKey<ScaffoldState>();

  Doctor doctor;

  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    FbCloudServices().getDoctorByUserId(widget.appointment.doctorId).then((dr) {
      this.doctor = dr;
      setState(() {});
    });
  }

  String selectedDay;
  String selectedTime;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _globalKey,
      extendBodyBehindAppBar: true,
      backgroundColor: LightColor.extraLightBlue,
      body: CustomProgressView(
        inAsyncCall: _isLoading,
        child: SafeArea(
          bottom: Platform.isIOS,
          child: Container(
            height: size.height,
            width: double.infinity,
            // Here i can use size.width but use double.infinity because both work as a same
            child: Column(
              children: [
                AppTopBar(
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
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      children: <Widget>[
                        Text("Verify\nAppointment Details",
                                style: TextStyles.h1Style)
                            .alignTopLeft
                            .hP8,
                        SizedBox(height: 8),
                        Text("Find the details of your appointment",
                                style: TextStyles.bodySm)
                            .alignTopLeft
                            .hP8,
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                  color: LightColor.grey, width: 0.3)),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                                leading: ImageView(
                                  height: 56,
                                  width: 56,
                                  icon: doctor?.photo ?? "",
                                  circle: true,
                                ),
                                title: Text(
                                    "Dr. ${doctor?.firstName ?? ""} ${doctor?.lastName ?? ""}",
                                    style: TextStyles.title.bold),
                                subtitle: Text(
                                  doctor?.specialization ?? "",
                                  style: TextStyles.bodySm.subTitleColor.bold,
                                ),
                              ),
                              Divider(
                                thickness: .3,
                                color: LightColor.grey,
                                height: 1,
                              ),
                              IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text("Procedure",
                                              style: TextStyles
                                                  .bodySm.subTitleColor.bold),
                                          Text("Consultation",
                                              style: TextStyles.body.bold)
                                        ],
                                      ).p8,
                                    ),
                                    VerticalDivider(
                                      thickness: .3,
                                      color: LightColor.grey,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text("Fees",
                                              style: TextStyles
                                                  .bodySm.subTitleColor.bold),
                                          Text(
                                              "$RS ${doctor?.consultFee ?? ""}",
                                              style: TextStyles.body.bold)
                                        ],
                                      ).p8,
                                    ),
                                  ],
                                ).hP16,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                  color: LightColor.grey, width: 0.3)),
                          width: double.infinity,
                          child: Column(children: [
                            Text("Date & Time",
                                style: TextStyles.bodySm.subTitleColor.bold),
                            SizedBox(height: 4),
                            Text(
                                "${ActivityUtils().formattedDate(widget.appointment.date.toDate(), format: 'EEEEE dd-MM-yyyy, hh:mm a')}",
                                style: TextStyles.body.bold)
                          ]).p8,
                        ),
                        SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                  color: LightColor.grey, width: 0.3)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Practice Details",
                                      style:
                                          TextStyles.bodySm.subTitleColor.bold),
                                  SizedBox(height: 4),
                                  Text(
                                      "${doctor?.hospitalName ?? ""},\n${doctor?.hospitalAddress ?? ""}",
                                      style: TextStyles.body.bold)
                                ],
                              ).p8,
                              Divider(
                                thickness: .3,
                                color: LightColor.grey,
                                height: 1,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  RotatedBox(
                                      quarterTurns: 2,
                                      child: Icon(
                                          Icons.subdirectory_arrow_left_rounded,
                                          color: LightColor.purple)),
                                  Text("Get Directions",
                                          style: TextStyles
                                              .bodySm.subTitleColor.bold.purple)
                                      .hP8
                                ],
                              ).p8.ripple(() {
                                MapsLauncher.launchQuery(
                                    "${doctor.hospitalAddress}");
                              })
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: .3,
                  color: LightColor.grey,
                ),
                Column(
                  children: [
                    Text("By Booking this appointment you agree to the",
                        style: TextStyles.bodySm.subTitleColor.bold),
                    Text("Terms & Conditions",
                            style: TextStyles.body.bold.purple)
                        .ripple(() async {
                      ActivityUtils().launchUrl("https://www.cypha.app/tos");
                    }),
                    RoundedButton(
                      text: "Confirm",
                      radius: 4,
                      color: LightColor.purpleLight,
                      width: double.infinity,
                      press: () async {
                        _isLoading = true;
                        setState(() {});

                        await FbCloudServices()
                            .addAppointment(widget.appointment);
                        _isLoading = false;
                        setState(() {});
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AppointmentSuccessfulPage();
                            },
                          ),
                        );
                        // // var response = AllInOneSdk.startTransaction(
                        // //     PAYTM_MERCHANT_ID,
                        // //     "1001",
                        // //     "295",
                        // //     "fUzkseGCT1/ZO0RiTyfppHcAEVZbTUcM+uRYASFvqSxqTAHVI5rG6L/LPvYNkTR6Aeb5LCrUjt2rXyETHYmj7haqnS6Iz3/RKOdvLnP3dFc=",
                        // //     null,
                        // //     true,
                        // //     true);
                        // // response.then((value) {
                        // //   print(value);
                        // // }).catchError((onError) {
                        // //   if (onError is PlatformException) {
                        // //     print(onError.message +
                        // //         " \n  " +
                        // //         onError.details.toString());
                        // //   } else {
                        // //     setState(() {});
                        // //     print(onError.toString());
                        // //   }
                        // // });
                        // openCheckout(doctor);
                      },
                    ),
                  ],
                ).hP16.vP4,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(Doctor doctor) async {
    UserDetails patient = Provider.of<UserDetails>(this.context, listen: false);
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': (doctor.consultFee * 100),
      'name': '${doctor.hospitalName}',
      'description': '${doctor.specialization}',
      'image': '${doctor.photo}',
      'prefill': {'contact': '${patient.phone}', 'email': '${patient.email}'},
      // 'external': {
      //   'wallets': ['paytm']
      // },
      'theme': {'color': '#8873f4'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    _isLoading = true;
    setState(() {});

    widget.appointment.rzPaymentID = response.paymentId;
    widget.appointment.rzOrderID = response.orderId;
    widget.appointment.rzSignature = response.signature;

    await FbCloudServices().addAppointment(widget.appointment);

    _isLoading = false;
    setState(() {});
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return AppointmentSuccessfulPage();
      },
    ));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ActivityUtils().showSnackBarMessage(this.context,
        "ERROR: " + response.code.toString() + " - " + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ActivityUtils().showSnackBarMessage(
        this.context, "EXTERNAL_WALLET: " + response.walletName);
  }
}
