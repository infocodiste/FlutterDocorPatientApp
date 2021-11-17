import 'dart:io';

import 'package:book_my_doctor/src/config/constants.dart';
import 'package:book_my_doctor/src/model/data.dart';
import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:book_my_doctor/src/widgets/image_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivityUtils {
  String validateEmail(String value) {
    if (value.isEmpty) {
      return 'This field cannot be empty';
    }
    value = value.toLowerCase().trim();
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter a valid email address';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return 'This field cannot be empty';
    }
    value = value.trim();
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (/*!regExp.hasMatch(value) || */ value.length < 8) {
      return 'Password must be a 8 character long.';
    } else {
      return null;
    }
  }

  String formattedDate(DateTime dateTime, {String format = 'EEEEE, dd MMM'}) {
    return DateFormat(format).format(dateTime);
  }

  DateTime getDateTime(String date, {String format = 'dd-MM-yyyy, hh:mm a'}) {
    return DateFormat(format).parse(date);
  }

  Future<String> getActualFilePath(String filePath) async {
    if (Platform.isIOS) {
      print("Old File Path : $filePath");
      if (filePath.contains("/$APP_NAME")) {
        String appFolderPath =
            filePath.substring(filePath.indexOf("/$APP_NAME"));
        print("appFolderPath : $appFolderPath");
        Directory directory = await getApplicationDocumentsDirectory();
        print("directory : ${directory.path}");
        String iosFilePath = "${directory.path}$appFolderPath";
        print("New File Path : $iosFilePath");
        return iosFilePath;
      } else {
        return filePath;
      }
    } else {
      return filePath;
    }
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void hideKeyboard() {
    FocusManager.instance.primaryFocus.unfocus();
  }

  showSnackBarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void showAlertDialog(BuildContext context, String message,
      {Function onOkPress}) async {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: Colors.white, width: 1)),
      textColor: Colors.white,
      color: Colors.black,
      onPressed: () {
        Navigator.of(context).pop();
        if (onOkPress != null) {
          onOkPress();
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: Colors.black, width: 1)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageView(
                icon: "heartbeat.png",
                height: 48,
                alignment: Alignment.center,
                color: LightColor.purple,
                padding: EdgeInsets.all(10),
              ),
              Text(
                "My Doctor",
                style: TextStyles.title.bold.purple,
              )
            ],
          ),
          Divider(
            height: 1,
            color: Colors.black,
            thickness: 1,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 320),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                message,
                style: TextStyles.body,
              ),
            ),
          ),
          SizedBox(height: 8),
          okButton,
          SizedBox(height: 12),
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      barrierColor: Colors.black12,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> launchUrl(String url) async {
    // String _url = "https://www.cypha.app/tos";
    return await canLaunch(url)
        ? await launch(url)
        : throw 'Could not launch $url';
  }

  Future<GeoPoint> getGeoPointFromAddress(String address) async {
    var addresses = await Geocoder.local.findAddressesFromQuery(address);
    if (addresses != null && addresses.length > 0) {
      var firstAddr = addresses.first;
      var lat = firstAddr.coordinates?.latitude ?? 0.0;
      var lng = firstAddr.coordinates?.longitude ?? 0.0;
      return GeoPoint(lat, lng);
    }
    return null;
  }
}
