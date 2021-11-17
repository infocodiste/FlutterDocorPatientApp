import 'dart:math';

import 'package:book_my_doctor/src/config/constants.dart';
import 'package:book_my_doctor/src/model/appointment.dart';
import 'package:book_my_doctor/src/model/data.dart';
import 'package:book_my_doctor/src/model/doctor.dart';
import 'package:book_my_doctor/src/model/doctor_model.dart';
import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:book_my_doctor/src/services/auth_service.dart';
import 'package:book_my_doctor/src/services/fb_cloud_services.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/theme/theme.dart';
import 'package:book_my_doctor/src/utils/activity_utils.dart';
import 'package:book_my_doctor/src/widgets/app_drawer.dart';
import 'package:book_my_doctor/src/widgets/custom_progress_view.dart';
import 'package:book_my_doctor/src/widgets/image_view.dart';
import 'package:book_my_doctor/src/widgets/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'appointment_details.dart';
import 'appointment_user_list_page.dart';
import 'complete_profile_page.dart';
import 'doctor_list_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Doctor> doctorDataList = [];
  List<Appointment> appointmentList = [];

  bool isLoading = false;

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: LightColor.extraLightBlue,
      toolbarHeight: 36,
      leading: InkWell(
        child: Icon(
          Icons.short_text,
          size: 30,
          color: Colors.black,
        ),
        onTap: () {
          _globalKey.currentState.openDrawer();
        },
      ),
      actions: <Widget>[
        Icon(
          Icons.notifications_none,
          size: 30,
          color: LightColor.grey,
        ),
        ImageView(
          icon: _user?.photo,
          height: 36,
          width: 36,
          circle: true,
          margin: EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(18))),
          onPress: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => CompleteProfilePage()));
          },
        ),
      ],
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Hello,", style: TextStyles.title.subTitleColor),
        Text(
            "${_user.areYouDoctor ? "Dr. " : ""}${_user.firstName} ${_user.lastName}",
            style: TextStyles.h1Style),
      ],
    ).p16;
  }

  Widget _searchField() {
    return Container(
      height: 55,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(13)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: LightColor.grey.withOpacity(.3),
            blurRadius: 15,
            offset: Offset(5, 5),
          )
        ],
      ),
      child: TextField(
        onChanged: searchDoctorQuery,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          hintText: "Search",
          hintStyle: TextStyles.body.subTitleColor,
          suffixIcon: SizedBox(
              width: 50,
              child: Icon(Icons.search, color: LightColor.purple)
                  .alignCenter
                  .ripple(() {}, borderRadius: BorderRadius.circular(13))),
        ),
      ),
    );
  }

  searchDoctorQuery(String query) {
    print("Search Doctor $query");
    if (!_user.areYouDoctor) {
      if (query == null || query.isEmpty) {
        getDoctorList();
      } else {
        searchDoctor(query);
      }
    }
  }

  searchDoctor(String query) {
    FbCloudServices().searchDoctor(query).then((snapshots) {
      if (snapshots != null) {
        doctorDataList.clear();
        snapshots.docs.forEach((element) {
          Doctor doctor = Doctor.fromJson(element.data());
          doctorDataList.add(doctor);
          setState(() {});
        });
      }
    });
  }

  Widget _category() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Category", style: TextStyles.title.bold),
              Text(
                "See All",
                style: TextStyles.titleNormal
                    .copyWith(color: Theme.of(context).primaryColor),
              ).p(8).ripple(() {})
            ],
          ),
        ),
        SizedBox(
          height: AppTheme.fullHeight(context) * .28,
          width: AppTheme.fullWidth(context),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              _categoryCard("Chemist & Drugist", "350 + Stores",
                  color: LightColor.green, lightColor: LightColor.lightGreen),
              _categoryCard("Covid - 19 Specilist", "899 Doctors",
                  color: LightColor.skyBlue, lightColor: LightColor.lightBlue),
              _categoryCard("Cardiologists Specilist", "500 + Doctors",
                  color: LightColor.orange, lightColor: LightColor.lightOrange)
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryCard(String title, String subtitle,
      {Color color, Color lightColor}) {
    TextStyle titleStyle = TextStyles.title.bold.white;
    TextStyle subtitleStyle = TextStyles.body.bold.white;
    if (AppTheme.fullWidth(context) < 392) {
      titleStyle = TextStyles.body.bold.white;
      subtitleStyle = TextStyles.bodySm.bold.white;
    }
    return AspectRatio(
      aspectRatio: 6 / 8,
      child: Container(
        width: AppTheme.fullWidth(context) * .24,
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(4, 4),
              blurRadius: 10,
              color: lightColor.withOpacity(.8),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          child: Container(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -20,
                  left: -20,
                  child: CircleAvatar(
                    backgroundColor: lightColor,
                    radius: 60,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      child: Text(title, style: titleStyle).hP4,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Flexible(
                      child: Text(
                        subtitle,
                        style: subtitleStyle,
                      ).hP4,
                    ),
                  ],
                ).p16
              ],
            ),
          ),
        ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  Widget _ListView() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                  _user?.areYouDoctor ?? false ? "Appointments" : "Top Doctors",
                  style: TextStyles.title.bold),
              IconButton(
                  icon: Icon(
                    Icons.sort,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => _user?.areYouDoctor ?? false
                                ? AppointmentUserListPage()
                                : DoctorListPage()));
                  })
              // .p(12).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(20))),
            ],
          ).hP16,
          _user?.areYouDoctor ?? false
              ? StreamBuilder<List<Appointment>>(
                  stream:
                      FbCloudServices().streamAppointmentByDoctor(_user.uid),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  LightColor.purple)));
                    } else {
                      appointmentList = List.from(snapshot.data.where(
                          (element) =>
                              element.status !=
                              APPOINTMENT_STATUS.DECLINE.index));
                      return getAppointmentWidgetList();
                    }
                  },
                )
              : getDoctorWidgetList()
        ],
      ),
    );
  }

  Widget getDoctorWidgetList() {
    return Column(
        children: doctorDataList.map((x) {
      return _doctorTile(x);
    }).toList());
  }

  Widget _doctorTile(Doctor doctor) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: LightColor.grey.withOpacity(.3),
            blurRadius: 16,
            offset: Offset(5, 5),
          )
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        leading: ImageView(
          height: 56,
          width: 56,
          icon: doctor.photo,
          circle: true,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: LightColor.skyBlue,
              borderRadius: BorderRadius.all(Radius.circular(56 / 2))),
        ),
        title: Text("Dr. ${doctor?.firstName ?? ""} ${doctor?.lastName ?? ""}",
            style: TextStyles.title.bold),
        horizontalTitleGap: 12,
        subtitle: Text(
          doctor?.specialization ?? "",
          style: TextStyles.bodySm.subTitleColor.bold,
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Theme.of(context).primaryColor,
        ),
      ).ripple(() {
        Navigator.pushNamed(context, "/DetailPage", arguments: doctor);
      }, borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }

  Widget getAppointmentWidgetList() {
    return Column(
        children: appointmentList.map((appointment) {
      print('adding big card');
      return _appointmentTile(appointment);
    }).toList());
  }

  Widget _appointmentTile(Appointment appointment) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(4, 4),
            blurRadius: 10,
            color: LightColor.grey.withOpacity(.2),
          ),
          BoxShadow(
            offset: Offset(-3, 0),
            blurRadius: 15,
            color: LightColor.grey.withOpacity(.1),
          )
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: ImageView(
              height: 56,
              width: 56,
              icon: appointment.patientPhoto,
              circle: true,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: LightColor.skyBlue,
              ),
            ),
            title: Text("${appointment?.patientName}",
                style: TextStyles.title.bold),
            subtitle: Text(
                ActivityUtils().formattedDate(appointment.date.toDate()) +
                    ', ' +
                    ActivityUtils().formattedDate(appointment.date.toDate(),
                        format: "hh:mm a"),
                style: TextStyles.bodySm.grey),
            horizontalTitleGap: 12,
            trailing: Icon(
              Icons.keyboard_arrow_right,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AppointmentDetailPage(appointment, forDoctor: true);
                  },
                ),
              );
            },
          ),
          (appointment.date.toDate().isAfter(DateTime.now()) &&
                  appointment.status == APPOINTMENT_STATUS.PENDING.index)
              ? Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RoundedButton(
                        width: size.width * 0.45,
                        text: "Accept",
                        textColor: Colors.white,
                        color: LightColor.purple,
                        press: () {
                          FbCloudServices().updateAppointmentStatus(
                              appointment.id, APPOINTMENT_STATUS.ACCEPT.index);
                          appointment.status = APPOINTMENT_STATUS.ACCEPT.index;
                          setState(() {});
                        },
                      ),
                      RoundedButton(
                        width: size.width * 0.35,
                        text: "Decline",
                        textColor: Colors.white,
                        color: LightColor.grey,
                        press: () {
                          FbCloudServices().updateAppointmentStatus(
                              appointment.id, APPOINTMENT_STATUS.DECLINE.index);
                          appointment.status = APPOINTMENT_STATUS.DECLINE.index;
                          appointmentList.remove(appointment);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  UserDetails _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  getDoctorList() {
    isLoading = true;
    setState(() {});
    FbCloudServices().getTopDoctors().then((snapshots) {
      if (snapshots != null) {
        doctorDataList.clear();
        snapshots.docChanges.forEach((element) {
          Doctor doctor = Doctor.fromJson(element.doc.data());
          doctorDataList.add(doctor);
        });
      }
      isLoading = false;
      setState(() {});
    });
  }

  // geAppointmentList() {
  //   isLoading = true;
  //   setState(() {});
  //   FbCloudServices().getAppointmentByDoctor(_user.uid).then((appointments) {
  //     print("appointments : ${appointments.length}");
  //     if (appointments != null) {
  //       appointmentList.clear();
  //       appointmentList = List.from(appointments.where(
  //           (element) => element.status != APPOINTMENT_STATUS.DECLINE.index));
  //     }
  //     isLoading = false;
  //     setState(() {});
  //   });
  // }

  @override
  void initState() {
    // doctorDataList = doctorMapList.map((x) => DoctorModel.fromJson(x)).toList();
    // final authService = Provider.of<AuthService>(context, listen: false);
    // print("Home Page : Auth User : ${authService.currentUser().toString()}");
    // FbCloudServices().getUserById(authService.currentUser().uid).then((value) {
    //   UserDetails().notifyUserDetails(value);
    // });
    _user = Provider.of<UserDetails>(context, listen: false);
    if (_user?.areYouDoctor ?? false) {
      print("Are you doctor : ${_user?.areYouDoctor}");
      // geAppointmentList();
    } else {
      getDoctorList();
    }
    super.initState();
  }

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: _appBar(),
      drawer: AppDrawer(),
      backgroundColor: LightColor.extraLightBlue,
      body: CustomProgressView(
        inAsyncCall: isLoading,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  _header(),
                  _user.areYouDoctor ?? false ? Container() : _searchField(),
                  // _category(),
                ],
              ),
            ),
            _ListView()
          ],
        ),
      ),
    );
  }
}
