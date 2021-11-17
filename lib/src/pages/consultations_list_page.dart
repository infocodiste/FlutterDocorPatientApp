import 'package:book_my_doctor/src/model/doctor.dart';
import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:book_my_doctor/src/services/fb_chat_services.dart';
import 'package:book_my_doctor/src/services/fb_cloud_services.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/widgets/app_top_bar.dart';
import 'package:book_my_doctor/src/widgets/custom_progress_view.dart';
import 'package:book_my_doctor/src/widgets/doctor_item_tile.dart';
import 'package:book_my_doctor/src/widgets/patient_item_tile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'appointment_details.dart';
import 'consultations_chat_page.dart';

class ConsultationsListPage extends StatefulWidget {
  ConsultationsListPage({
    Key key,
  }) : super(key: key);

  @override
  State createState() => ConsultationsListPageState();
}

class ConsultationsListPageState extends State<ConsultationsListPage> {
  ConsultationsListPageState({Key key});

  String currentUserId;

  bool isLoading = false;

  UserDetails _user;

  List<String> consultPeerId;

  @override
  void initState() {
    _user = Provider.of<UserDetails>(context, listen: false);
    currentUserId = _user.uid;
    getConsultDoctors();
    super.initState();
  }

  getConsultDoctors() async {
    isLoading = true;
    setState(() {});
    consultPeerId = _user.areYouDoctor
        ? await FbCloudServices().getConsultUser(_user.uid)
        : await FbCloudServices().getConsultDoctor(_user.uid);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColor.extraLightBlue,
      appBar: AppTopBar(
        title: "Consult a doctor",
      ),
      body: CustomProgressView(
        inAsyncCall: isLoading,
        child: consultPeerId != null && consultPeerId.length > 0
            ? Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FBChatServices().getPeerChat(consultPeerId,
                      areYouDoctor: _user?.areYouDoctor ?? false),
                  builder: (context, stream) {
                    if (stream.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(LightColor.purple),
                        ),
                      );
                    }
                    if (stream.hasError) {
                      return Center(child: Text(stream.error.toString()));
                    }
                    QuerySnapshot querySnapshot = stream.data;

                    return ListView.builder(
                      itemCount: querySnapshot.size,
                      itemBuilder: (context, index) =>
                          buildItem(context, querySnapshot.docs[index]),
                    );
                  },
                ),
              )
            : Container(),
      ),
    );
  }

  Widget buildItem(BuildContext context, QueryDocumentSnapshot document) {
    print("Build Item : ${document.data().toString()}");
    if (_user?.areYouDoctor ?? false) {
      UserDetails patient = UserDetails.fromJson(document.data());
      return PatientItemTile(patient, () {
        openPeerChat(patient.uid);
      });
    } else {
      Doctor doctor = Doctor.fromJson(document.data());
      return DoctorItemTile(doctor, () {
        openPeerChat(doctor.uid);
      });
    }
  }

  openPeerChat(String peerId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConsultationChatPage(
                  peerId: peerId,
                )));
  }
}
