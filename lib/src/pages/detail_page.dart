import 'package:book_my_doctor/src/model/appointment.dart';
import 'package:book_my_doctor/src/model/doctor.dart';
import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:book_my_doctor/src/services/fb_cloud_services.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/theme/theme.dart';
import 'package:book_my_doctor/src/widgets/image_view.dart';
import 'package:book_my_doctor/src/widgets/rating_start.dart';
import 'package:book_my_doctor/src/widgets/rounded_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

import 'appointment_list_page.dart';
import 'choose_booking_slot.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key key, this.doctor}) : super(key: key);
  final Doctor doctor;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  UserDetails user;
  Doctor doctor;
  bool _showMoreAbout = false;
  bool _isFavorite = false;

  @override
  void initState() {
    doctor = widget.doctor;
    user = Provider.of<UserDetails>(context, listen: false);
    getDoctorProfile();
    getIsFavorite();
    getTotalAppointment();
    super.initState();
  }

  getDoctorProfile() {
    FbCloudServices().getDoctorByUserId(doctor.uid).then((dr) {
      doctor = dr;
      setState(() {});
    });
  }

  String favoriteReferenceId;

  getIsFavorite() async {
    QuerySnapshot snapshot =
        await FbCloudServices().getFavorite(user.uid, doctor.uid);
    if (snapshot != null && snapshot.docs.length > 0) {
      favoriteReferenceId = snapshot.docs.first.id;
      _isFavorite = true;
    } else {
      _isFavorite = false;
    }
    setState(() {});
  }

  int totalPatients = 0;

  getTotalAppointment() async {
    totalPatients =
        await FbCloudServices().getTotalAppointmentOfDoctor(doctor.uid);
    setState(() {});
  }

  Widget _appbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? LightColor.orange : Colors.white,
            ),
            onPressed: () async {
              _isFavorite = !_isFavorite;
              if (_isFavorite) {
                DocumentReference ref = await FbCloudServices()
                    .setDoctorFavorite(user.uid, doctor.uid);
                favoriteReferenceId = ref.id;
              } else {
                FbCloudServices().removeDoctorFavorite(favoriteReferenceId);
              }
              setState(() {});
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyles.title.copyWith(fontSize: 24).bold;
    if (AppTheme.fullWidth(context) < 393) {
      titleStyle = TextStyles.title.copyWith(fontSize: 22).bold;
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: LightColor.extraLightBlue,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            (doctor?.referenceImages != null &&
                    doctor.referenceImages.length > 0)
                ? CarouselSlider(
                    options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        height: size.height * 0.4),
                    items: doctor.referenceImages
                        .map((item) => Container(
                              child: Center(
                                  child: Image.network(item,
                                      fit: BoxFit.cover, width: 1000)),
                            ))
                        .toList(),
                  ).alignTopCenter
                : ImageView(icon: doctor?.photo ?? "").alignTopCenter,
            Container(
              color: Colors.black26,
            ),
            DraggableScrollableSheet(
              maxChildSize: .8,
              initialChildSize: .6,
              minChildSize: .6,
              builder: (context, scrollController) {
                return Container(
                  child: Stack(
                    children: [
                      Container(
                        height: AppTheme.fullHeight(context),
                        margin: EdgeInsets.only(top: 32),
                        padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                        //symmetric(horizontal: 19, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          color: Colors.white,
                        ),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(width: 108),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "${doctor.firstName} ${doctor.lastName}",
                                          style: titleStyle,
                                        ),
                                        Text(
                                          "${doctor.specialization}",
                                          style: TextStyle(color: Colors.grey),
                                        ).vP4,
                                        Row(
                                          children: <Widget>[
                                            RatingStar(
                                              rating: doctor.rating ?? 0,
                                            ),
                                            Text("(${doctor.reviews ?? 0} Reviews)",
                                                    style: TextStyles
                                                        .bodySm.purple)
                                                .ripple(() {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          AppointmentListPage(
                                                            reviews: true,
                                                            doctorId:
                                                                doctor.uid,
                                                          )));
                                            }),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.directions,
                                    color: LightColor.orange,
                                  ).ripple(() {
                                    MapsLauncher.launchQuery(
                                        doctor.hospitalAddress);
                                  }),
                                ],
                              ),
                              Divider(
                                thickness: .3,
                                color: LightColor.grey,
                              ),
                              Text(
                                "About",
                                style: TextStyles.body.bold,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Wrap(
                                children: <Widget>[
                                  Text(
                                    "${doctor.description}",
                                    style: TextStyles.bodySm,
                                    maxLines: _showMoreAbout ? null : 1,
                                  ),
                                  Text(
                                    _showMoreAbout ? "See Less" : "See More",
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        .copyWith(color: LightColor.skyBlue),
                                  ).vP4.ripple(() {
                                    setState(() {
                                      _showMoreAbout = !_showMoreAbout;
                                    });
                                  })
                                ],
                              ),
                              Text(
                                "Working Hours",
                                style: TextStyles.body.bold,
                              ),
                              Row(
                                children: <Widget>[
                                  Text("Mon-Sat 10:00 AM - 09:00 PM"),
                                  SizedBox(width: 15),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.all(9.0),
                                      child: Text(
                                        "Open",
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            .copyWith(color: LightColor.green),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        color: Color(0xffdbf3e8),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 12),
                              Text(
                                "Stats",
                                style: TextStyles.title,
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text("$totalPatients",
                                          style: TextStyles.title.bold),
                                      Text(
                                        "Patients",
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text("${doctor.experience} Year(s)",
                                          style: TextStyles.title.bold),
                                      Text(
                                        "Experience",
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text("5", style: TextStyles.title.bold),
                                      Text(
                                        "Certifications",
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 12),
                              RoundedButton(
                                text: "Book An Appointment",
                                radius: 4,
                                color: LightColor.purple,
                                width: double.infinity,
                                press: () {
                                  String uid = FirebaseFirestore.instance
                                      .collection(APPOINTMENT_TABLE)
                                      .doc()
                                      .id;
                                  Appointment appointment = Appointment();
                                  appointment.id = uid;
                                  appointment.number = randomNumeric(8);
                                  appointment.doctorId = doctor.uid;
                                  appointment.doctorName =
                                      "${doctor.firstName} ${doctor.lastName}";
                                  appointment.doctorPhoto = doctor.photo;
                                  appointment.hospitalName =
                                      doctor.hospitalName;
                                  appointment.hospitalAddress =
                                      doctor.hospitalAddress;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ChooseBookingSlot(appointment);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          color: LightColor.grey,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              offset: Offset(4, 4),
                              blurRadius: 10,
                              color: LightColor.grey.withOpacity(.4),
                            ),
                            BoxShadow(
                              offset: Offset(-3, 0),
                              blurRadius: 15,
                              color: LightColor.grey.withOpacity(.3),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          child: ImageView(
                            icon: doctor?.photo ?? "",
                            width: 96,
                            height: 96,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            _appbar(),
          ],
        ),
      ),
    );
  }
}
