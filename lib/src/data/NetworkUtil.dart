import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:book_my_doctor/src/config/constants.dart';
import 'package:book_my_doctor/src/utils/preference_handler.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'ApiResponse.dart';
import 'ParsedResponse.dart';

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;

  final int NO_INTERNET = 404;

  Map<String, String> _header = Map();

  addHeader(Map<String, String> hMap) {
    _header = hMap;
  }

  Future<Map<String, String>> getDefaultHeaders() async {
//    String osVersion = await PrefManager.instance.getString(pref_os_version);
//    String deviceId = await PrefManager.instance.getString(pref_device_id);
//    String appVersion = await PrefManager.instance.getString(pref_app_version);
    String token = await PreferenceHandler.instance.getString(pref_token);

    _header = {
      "Authorization":
          (token != null && token.isNotEmpty) ? "Bearer $token" : "",
//      "platform": Platform.isIOS ? "iPhone" : "Android",
//      "osVersion": "$osVersion",
//      "time": "${ActivityUtils.get().timestamp()}",
//      "appVersion": "$appVersion",
//      "device_id": "$deviceId",
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    return _header;
  }

  // Future<ParsedResponse<dynamic>> get(String url) async {
  //   var connectivityResult = await (new Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile ||
  //       connectivityResult == ConnectivityResult.wifi) {
  //     _header = await getDefaultHeaders();
  //     return http.get(url, headers: _header).then((http.Response response) {
  //       print("Response status: ${response.statusCode}");
  //       print("Response body: ${response.body}");
  //       ApiResponse apiResponse =
  //           new ApiResponse(false, "NETWORK_NOT_AVAILABLE");
  //       if (response == null) {
  //         String jsonString = json.encode(apiResponse.toJson());
  //         return new ParsedResponse(NO_INTERNET, json.decode(jsonString));
  //       }
  //
  //       dynamic jsonResponse = json.decode(response.body);
  //       return new ParsedResponse(response.statusCode, jsonResponse);
  //     }).catchError((resp) {
  //       print("Response Error: ${resp.toString()}");
  //     });
  //   } else {
  //     ApiResponse apiResponse = new ApiResponse(false, "NETWORK_NOT_AVAILABLE");
  //     String jsonString = json.encode(apiResponse.toJson());
  //     return new ParsedResponse(NO_INTERNET, json.decode(jsonString));
  //   }
  // }
  //
  // Future<ParsedResponse<dynamic>> post(String url,
  //     {Map headers, body, encoding}) async {
  //   var connectivityResult = await (new Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile ||
  //       connectivityResult == ConnectivityResult.wifi) {
  //     print("URL : $url");
  //     print("BODY : ${body.toString()}");
  //     if (headers == null) {
  //       headers = await getDefaultHeaders();
  //     }
  //     // print("Api Headers : ${headers.toString()}");
  //     return http
  //         .post(url, body: body, headers: headers, encoding: encoding)
  //         .then((http.Response response) {
  //       print("Response status: ${response.statusCode}");
  //       print("Response body: ${response.body}");
  //
  //       ApiResponse apiResponse =
  //           new ApiResponse(false, "NETWORK_NOT_AVAILABLE");
  //       if (response == null) {
  //         String jsonString = json.encode(apiResponse.toJson());
  //         return new ParsedResponse(NO_INTERNET, json.decode(jsonString));
  //       }
  //
  //       dynamic jsonResponse = json.decode(response.body);
  //       return new ParsedResponse(response.statusCode, jsonResponse);
  //     });
  //   } else {
  //     ApiResponse apiResponse = new ApiResponse(false, "NETWORK_NOT_AVAILABLE");
  //     String jsonString = json.encode(apiResponse.toJson());
  //     return new ParsedResponse(NO_INTERNET, json.decode(jsonString));
  //   }
  // }
  //
  // Future<ParsedResponse<dynamic>> postWithOutHeader(String url, {body}) async {
  //   var connectivityResult = await (new Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile ||
  //       connectivityResult == ConnectivityResult.wifi) {
  //     return http.post(url, body: body).then((http.Response response) {
  //       print("Response status: ${response.statusCode}");
  //       print("Response body: ${response.body}");
  //
  //       ApiResponse apiResponse =
  //           new ApiResponse(false, "NETWORK_NOT_AVAILABLE");
  //       if (response == null) {
  //         String jsonString = json.encode(apiResponse.toJson());
  //         return new ParsedResponse(NO_INTERNET, json.decode(jsonString));
  //       }
  //
  //       //If there was an error return null
  //       if (response.statusCode < 200 || response.statusCode >= 300) {
  //         apiResponse.message = "ERROR_FETCH_DATA";
  //         String jsonString = json.encode(apiResponse.toJson());
  //         return new ParsedResponse(
  //             response.statusCode, json.decode(jsonString));
  //       }
  //       dynamic jsonResponse = json.decode(response.body);
  //       return new ParsedResponse(response.statusCode, jsonResponse);
  //     });
  //   } else {
  //     ApiResponse apiResponse = new ApiResponse(false, "NETWORK_NOT_AVAILABLE");
  //     String jsonString = json.encode(apiResponse.toJson());
  //     return new ParsedResponse(NO_INTERNET, json.decode(jsonString));
  //   }
  // }
  //
  // Future<ParsedResponse<dynamic>> put(
  //     String url, File image, String contentType,
  //     {Function onProgress}) async {
  //   var connectivityResult = await (new Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile ||
  //       connectivityResult == ConnectivityResult.wifi) {
  //     print("URL : $url");
  //     var response = await Dio().put(url,
  //         data: image.openRead(),
  //         options: Options(
  //           contentType: contentType,
  //           headers: {
  //             "Content-Length": image.lengthSync(),
  //           },
  //         ),
  //         onSendProgress: onProgress
  //         // onSendProgress: (int sentBytes, int totalBytes) {
  //         //   double progressPercent = sentBytes / totalBytes * 100;
  //         //   print("$progressPercent %");
  //         // },
  //         );
  //     ApiResponse apiResponse = new ApiResponse(false, "NETWORK_NOT_AVAILABLE");
  //     if (response == null) {
  //       String jsonString = json.encode(apiResponse.toJson());
  //       return new ParsedResponse(NO_INTERNET, json.decode(jsonString));
  //     }
  //
  //     //If there was an error return null
  //     if (response.statusCode < 200 || response.statusCode >= 300) {
  //       apiResponse.message = "ERROR_FETCH_DATA";
  //       String jsonString = json.encode(apiResponse.toJson());
  //       return new ParsedResponse(response.statusCode, json.decode(jsonString));
  //     }
  //     dynamic jsonResponse = json.decode(response.extra.toString());
  //     return new ParsedResponse(response.statusCode, jsonResponse);
  //   } else {
  //     ApiResponse apiResponse = new ApiResponse(false, "NETWORK_NOT_AVAILABLE");
  //     String jsonString = json.encode(apiResponse.toJson());
  //     return new ParsedResponse(NO_INTERNET, json.decode(jsonString));
  //   }
  // }
  //
  // Future<ParsedResponse<dynamic>> getDirect(String url) async {
  //   var connectivityResult = await (new Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile ||
  //       connectivityResult == ConnectivityResult.wifi) {
  //     return http.get(url, headers: _header).then((http.Response response) {
  //       print("Response status: ${response.statusCode}");
  //       print("Response body: ${response.body}");
  //
  //       ApiResponse apiResponse =
  //           new ApiResponse(false, "NETWORK NOT AVAILABLE");
  //       if (response == null) {
  //         String jsonString = json.encode(apiResponse.toJson());
  //         return new ParsedResponse(NO_INTERNET, json.decode(jsonString));
  //       }
  //
  //       //If there was an error return null
  //       if (response.statusCode < 200 || response.statusCode >= 300) {
  //         apiResponse.message = "ERROR_FETCH_DATA";
  //         String jsonString = json.encode(apiResponse.toJson());
  //         return new ParsedResponse(
  //             response.statusCode, json.decode(jsonString));
  //       }
  //       dynamic jsonResponse = json.decode(response.body);
  //       return new ParsedResponse(response.statusCode, jsonResponse);
  //     }).catchError((resp) {
  //       print("Response Error: ${resp.toString()}");
  //     });
  //   } else {
  //     ApiResponse apiResponse = new ApiResponse(false, "NETWORK NOT AVAILABLE");
  //     String jsonString = json.encode(apiResponse.toJson());
  //     return new ParsedResponse(NO_INTERNET, json.decode(jsonString));
  //   }
  // }
  //
  // Future<File> getFileFromUrl(String filePath, String url) async {
  //   File file = new File(filePath);
  //   bool isExist = await file.exists();
  //   int length = await file.length();
  //   if (isExist && length > 0) {
  //     print("Download Exist : ${file.path}");
  //     return file;
  //   } else {
  //     file.createSync(recursive: true);
  //   }
  //   var request = await http.get(
  //     url,
  //   );
  //   var bytes = request.bodyBytes; //close();
  //   await file.writeAsBytes(bytes);
  //   print("Download New : ${file.path}");
  //   return file;
  // }
  //
  // _asyncFileUpload(String text, File file) async {
  //   //create multipart request for POST or PATCH method
  //   var request = http.MultipartRequest("POST", Uri.parse("<url>"));
  //   //add text fields
  //   request.fields["text_field"] = text;
  //   //create multipart using filepath, string or bytes
  //   var pic = await http.MultipartFile.fromPath("file_field", file.path);
  //   //add multipart to request
  //   request.files.add(pic);
  //   var response = await request.send();
  //
  //   //Get the response from the server
  //   var responseData = await response.stream.toBytes();
  //   var responseString = String.fromCharCodes(responseData);
  //   print(responseString);
  // }
}
