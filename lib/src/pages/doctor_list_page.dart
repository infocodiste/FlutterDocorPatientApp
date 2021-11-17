import 'package:book_my_doctor/src/model/doctor.dart';
import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:book_my_doctor/src/services/fb_cloud_services.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/widgets/app_top_bar.dart';
import 'package:book_my_doctor/src/widgets/custom_progress_view.dart';
import 'package:book_my_doctor/src/widgets/image_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoctorListPage extends StatefulWidget {
  final bool myDoctors;

  DoctorListPage({this.myDoctors: false});

  @override
  _DoctorListPageState createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  UserDetails _user;
  List<Doctor> doctors = [];
  bool _isLoading = false;

  @override
  void initState() {
    _user = Provider.of(context, listen: false);
    if (_user != null && _user.uid != null) {
      getDoctors();
    }
    super.initState();
  }

  getDoctors() async {
    _isLoading = true;
    setState(() {});
    doctors.clear();
    QuerySnapshot snapshots = widget.myDoctors
        ? await FbCloudServices().getFavoriteDoctors(_user.uid)
        : await FbCloudServices().getDoctors();
    if (snapshots != null && snapshots.docs.isNotEmpty) {
      snapshots.docs.forEach((element) async {
        Doctor appointment = Doctor.fromJson(element.data());
        doctors.add(appointment);
      });
    }
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColor.extraLightBlue,
      appBar: AppTopBar(
        title: widget.myDoctors ? "My Doctors" : "Doctors",
      ),
      body: CustomProgressView(
        inAsyncCall: _isLoading,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return (doctors == null && doctors.isEmpty)
              ? Container()
              : ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    var doctor = doctors[index];
                    return _doctorTile(doctor);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: Colors.transparent,
                      height: 1,
                    );
                  },
                  itemCount: doctors.length,
                );
        }),
      ),
    );
  }

  Widget _doctorTile(Doctor doctor) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: ImageView(
          height: 56,
          width: 56,
          icon: doctor.photo,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: LightColor.randomColor(),
          ),
        ),
        title: Text("Dr. ${doctor?.firstName ?? ""} ${doctor?.lastName ?? ""}",
            style: TextStyles.title.bold),
        subtitle: Text(
          doctor?.specialization ?? "",
          style: TextStyles.bodySm.subTitleColor.bold,
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Theme.of(context).primaryColor,
        ),
      ).ripple(() async {
        await Navigator.pushNamed(context, "/DetailPage", arguments: doctor);
        getDoctors();
      }, borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }
}
