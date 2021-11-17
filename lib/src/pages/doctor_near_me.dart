import 'dart:async';
import 'dart:io';

import 'package:book_my_doctor/src/config/constants.dart';
import 'package:book_my_doctor/src/model/doctor.dart';
import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:book_my_doctor/src/services/fb_cloud_services.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/utils/permission_manager.dart';
import 'package:book_my_doctor/src/widgets/app_top_bar.dart';
import 'package:book_my_doctor/src/widgets/custom_progress_view.dart';
import 'package:book_my_doctor/src/widgets/image_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class DoctorNearMePage extends StatefulWidget {
  final bool myDoctors;

  DoctorNearMePage({this.myDoctors: false});

  @override
  _DoctorNearMePageState createState() => _DoctorNearMePageState();
}

class _DoctorNearMePageState extends State<DoctorNearMePage> {
  UserDetails _user;
  List<Doctor> doctors = [];
  bool _isLoading = false;

  Completer<GoogleMapController> _completer = Completer();
  GoogleMapController _controller;
  List<Marker> hospitalMarkers = [];
  List<LatLng> hospitalLatLng = [];

  LatLng targetLatLng = LatLng(23.297850, 72.331001);
  CameraPosition _kGooglePlex;
  LatLngBounds latLngBounds;

  @override
  void initState() {
    super.initState();
    _user = Provider.of(context, listen: false);
    _kGooglePlex = CameraPosition(
      target: targetLatLng,
      zoom: 5,
    );
    getCurrentLocation().then((value) {
      setState(() {
        targetLatLng = value;
      });
    });
  }

  Future<LatLng> getCurrentLocation() async {
    bool isGrant = await PermissionManager.get().requestLocationPermission();
    if (isGrant) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best ?? LocationAccuracy.high);
      if (position != null) {
        return LatLng(position.latitude, position.longitude);
      } else {
        return LatLng(
            _user.addressGeoPoint.latitude, _user.addressGeoPoint.longitude);
      }
    } else {
      return LatLng(
          _user.addressGeoPoint.latitude, _user.addressGeoPoint.longitude);
    }
  }

  getDoctors() async {
    _isLoading = true;
    setState(() {});
    doctors = await FbCloudServices().getNearMeDoctors1(targetLatLng, _value);
    if (doctors != null && doctors.length > 0) {
      hospitalMarkers = doctors.map((doctor) {
        print(
            "Doctor - Lat : ${doctor.hospitalGeoPoint.latitude}, Lng : ${doctor.hospitalGeoPoint.longitude}");
        LatLng latLng = LatLng(
          doctor.hospitalGeoPoint.latitude,
          doctor.hospitalGeoPoint.longitude,
        );
        hospitalLatLng.add(latLng);
        return Marker(
            markerId: MarkerId(doctor.uid),
            position: latLng,
            infoWindow: InfoWindow(
                title: doctor.hospitalName,
                onTap: () {
                  // Navigator.pushNamed(context, "/DetailPage",
                  //     arguments: doctor);
                  MapsLauncher.launchQuery(doctor.hospitalAddress);
                }));
      }).toList();

      LatLngBounds bounds = boundsFromLatLngList(hospitalLatLng);
      CameraUpdate update = CameraUpdate.newLatLngBounds(bounds, 32);
      _controller.moveCamera(update);
    }
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("Doctor hospitalMarkers : ${hospitalMarkers.length}");
    return Scaffold(
      backgroundColor: LightColor.extraLightBlue,
      appBar: AppTopBar(
        title: "Doctor Near Me",
      ),
      body: CustomProgressView(
        inAsyncCall: _isLoading,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return (doctors == null && doctors.isEmpty)
              ? Container()
              : Stack(
                  children: [
                    GoogleMap(
                      myLocationButtonEnabled: true,
                      compassEnabled: false,
                      mapToolbarEnabled: false,
                      initialCameraPosition: _kGooglePlex,
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      tiltGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      zoomControlsEnabled: false,
                      onMapCreated: (GoogleMapController controller) async {
                        _completer.complete(controller);
                        _controller = await _completer.future;
                        getDoctors();
                      },
                      markers: Set.from(hospitalMarkers),
                      // onCameraMove: (cameraPosition) {
                      //   print("Move camera Called");
                      //   targetLatLng = cameraPosition.target;
                      //   _kGooglePlex = cameraPosition;
                      //   // getDoctors();
                      // },
                    ),
                    Align(
                      alignment: Platform.isAndroid
                          ? Alignment.bottomCenter
                          : Alignment.topCenter,
                      child: Container(
                        padding: const EdgeInsets.only(top: 8.0),
                        height: 50,
                        child: Slider(
                          min: 1,
                          max: 100,
                          divisions: 10,
                          value: _value,
                          label: _label,
                          activeColor: LightColor.purple,
                          inactiveColor: LightColor.purpleExtraLight,
                          onChanged: onChangedRadius,
                        ),
                      ),
                    )
                  ],
                );
        }),
      ),
    );
  }

  double _value = NEAR_BY_DISTANCE;
  String _label = '';

  onChangedRadius(value) {
    _value = value;
    _label = '${_value.toInt().toString()} kms';
    getDoctors();
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0, x1, y0, y1;
    List<LatLng> list1 = List.from(list);
    list1.add(targetLatLng);
    for (LatLng latLng in list1) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  getNearByDoctor(CameraPosition position) async {
    double distance = 5;
    double lat = position.target.latitude;
    double lon = position.target.longitude;
    double lowerLat = lat - (lat * distance);
    double lowerLon = lon - (lon * distance);

    double greaterLat = lat + (lat * distance);
    double greaterLon = lon + (lon * distance);

    GeoPoint lesserGeoPoint = GeoPoint(lowerLat, lowerLon);
    GeoPoint greaterGeoPoint = GeoPoint(greaterLat, greaterLon);
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(USER_TABLE)
        .where('are_you_doctor', isEqualTo: true)
        .where('is_complete', isEqualTo: true)
        .where('hospital_geopoint', isNotEqualTo: null)
        .where("hospital_geopoint", isGreaterThan: lesserGeoPoint)
        .where("hospital_geopoint", isLessThan: greaterGeoPoint)
        .get();
  }
}
// https://stackoverflow.com/questions/56674470/flutter-firestore-geo-query
// https://pub.dev/packages/geoflutterfire
