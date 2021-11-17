import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:book_my_doctor/src/pages/appointment_list_page.dart';
import 'package:book_my_doctor/src/pages/appointment_user_list_page.dart';
import 'package:book_my_doctor/src/pages/complete_profile_page.dart';
import 'package:book_my_doctor/src/pages/consultations_list_page.dart';
import 'package:book_my_doctor/src/pages/doctor_list_page.dart';
import 'package:book_my_doctor/src/pages/doctor_near_me.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'image_view.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserDetails _user = Provider.of<UserDetails>(context);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              child: Container(
            child: Row(
              children: [
                ImageView(
                  height: 56,
                  width: 56,
                  icon: _user.photo,
                  circle: true,
                  margin: EdgeInsets.only(right: 12),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${_user?.firstName ?? ""} ${_user?.lastName ?? ""}",
                        style: TextStyles.title.bold),
                    Text(
                      "View and edit profile",
                      style: TextStyles.bodySm.purple.bold,
                    )
                  ],
                )),
                Icon(
                  Icons.keyboard_arrow_right,
                  size: 30,
                  color: LightColor.grey,
                ),
              ],
            ),
          ).ripple(() {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => CompleteProfilePage()));
          })),
          ListTile(
            leading: Icon(Icons.calendar_today_outlined,
                size: 28, color: LightColor.skyBlue),
            title: Text(
              'Appointments',
              style: TextStyles.body.bold,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              size: 24,
              color: LightColor.grey,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => _user.areYouDoctor ?? false
                          ? AppointmentUserListPage()
                          : AppointmentListPage()));
            },
          ),
          _user.areYouDoctor ?? false
              ? Container()
              : ListTile(
                  leading: Icon(Icons.person_sharp,
                      size: 28, color: LightColor.skyBlue),
                  title: Text(
                    'My Doctors',
                    style: TextStyles.body.bold,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    size: 24,
                    color: LightColor.grey,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DoctorListPage(myDoctors: true)));
                  },
                ),
          _user.areYouDoctor ?? false
              ? Container()
              : ListTile(
                  leading: Icon(Icons.person_sharp,
                      size: 28, color: LightColor.skyBlue),
                  title: Text(
                    'Doctor Near Me',
                    style: TextStyles.body.bold,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    size: 24,
                    color: LightColor.grey,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DoctorNearMePage(myDoctors: true)));
                  },
                ),
          ListTile(
            leading: Icon(Icons.message_rounded,
                size: 28, color: LightColor.skyBlue),
            title: Text(
              'Consultations',
              style: TextStyles.body.bold,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              size: 24,
              color: LightColor.grey,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ConsultationsListPage()));
            },
          ),
        ],
      ),
    );
  }
}
