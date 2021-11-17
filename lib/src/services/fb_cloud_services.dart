import 'package:book_my_doctor/src/config/constants.dart';
import 'package:book_my_doctor/src/model/appointment.dart';
import 'package:book_my_doctor/src/model/doctor.dart';
import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const String USER_TABLE = "users";
const String APPOINTMENT_TABLE = "appointments";
const String FAVORITE_TABLE = "favorite";

class FbCloudServices {
  Future<void> addUser(UserDetails user) async {
    return await FirebaseFirestore.instance
        .collection(USER_TABLE)
        .doc(user.uid)
        .set(user.toJson());
  }

  Future<UserDetails> getUserById(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection(USER_TABLE).doc(id).get();
    if (snapshot.exists) {
      UserDetails user = UserDetails.fromJson(snapshot.data());
      return user;
    } else {
      return null;
    }
  }

  Future<void> updateUserById(UserDetails user) async {
    return await FirebaseFirestore.instance
        .collection(USER_TABLE)
        .doc(user.uid)
        .update(user.toJson());
  }

  Future<void> updateUserProfile(String uid, String dpUrl) async {
    return await FirebaseFirestore.instance
        .collection(USER_TABLE)
        .doc(uid)
        .update({"photo": dpUrl});
  }

  Future<Doctor> getDoctorByUserId(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection(USER_TABLE).doc(id).get();
    if (snapshot.exists) {
      Doctor doctor = Doctor.fromJson(snapshot.data());
      return doctor;
    } else {
      return null;
    }
  }

  Future<void> updateDoctor(Doctor doctor) async {
    // print("Doctor Profile : ${doctor.toJson()}");
    return await FirebaseFirestore.instance
        .collection(USER_TABLE)
        .doc(doctor.uid)
        .update(doctor.toJson());
  }

  Future<QuerySnapshot> getDoctors() {
    return FirebaseFirestore.instance
        .collection(USER_TABLE)
        .where('are_you_doctor', isEqualTo: true)
        .where('is_complete', isEqualTo: true)
        .get();
  }

  Future<QuerySnapshot> getTopDoctors() {
    return FirebaseFirestore.instance
        .collection(USER_TABLE)
        .where('are_you_doctor', isEqualTo: true)
        .where('is_complete', isEqualTo: true)
        .orderBy('rating', descending: true)
        .limit(5)
        .get();
  }

  Future<List<Doctor>> getNearMeDoctors() async {
    QuerySnapshot snapshots = await FirebaseFirestore.instance
        .collection(USER_TABLE)
        .where('are_you_doctor', isEqualTo: true)
        .where('is_complete', isEqualTo: true)
        .where('hospital_geopoint', isNotEqualTo: null)
        .get();
    List<Doctor> doctors = [];
    if (snapshots != null && snapshots.docs != null) {
      // print("snapshots : $snapshots");
      doctors = snapshots.docs.map((e) => Doctor.fromJson(e.data())).toList();
    }
    return doctors;
  }

  Future<List<Doctor>> getNearMeDoctors1(
      LatLng position, double radiusDistance) async {
    // ~1 mile of lat and lon in degrees
    double lat = 0.0144927536231884;
    double lon = 0.0181818181818182;

    double distance = radiusDistance * ONE_KM_EQUAL_MILE; // in mile
    double lowerLat = position.latitude - (lat * distance);
    double lowerLon = position.longitude - (lon * distance);

    double greaterLat = position.latitude + (lat * distance);
    double greaterLon = position.longitude + (lon * distance);

    GeoPoint lesserGeoPoint = GeoPoint(lowerLat, lowerLon);
    GeoPoint greaterGeoPoint = GeoPoint(greaterLat, greaterLon);
    QuerySnapshot snapshots = await FirebaseFirestore.instance
        .collection(USER_TABLE)
        .where('are_you_doctor', isEqualTo: true)
        .where('is_complete', isEqualTo: true)
        .where('hospital_geopoint', isNotEqualTo: null)
        .where("hospital_geopoint", isGreaterThan: lesserGeoPoint)
        .where("hospital_geopoint", isLessThan: greaterGeoPoint)
        .get();
    List<Doctor> doctors = [];
    if (snapshots != null && snapshots.docs != null) {
      // print("snapshots : $snapshots");
      doctors = snapshots.docs.map((e) => Doctor.fromJson(e.data())).toList();
    }
    return doctors;
  }

  Future<QuerySnapshot> searchDoctor(String name) {
    return FirebaseFirestore.instance
        .collection(USER_TABLE)
        .where('are_you_doctor', isEqualTo: true)
        .where('first_name', isEqualTo: name)
        .get();
  }

  Future<void> addAppointment(Appointment appointment) async {
    return await FirebaseFirestore.instance
        .collection(APPOINTMENT_TABLE)
        .doc(appointment.id)
        .set(appointment.toJson());
  }

  Future<List<Appointment>> getAppointmentByUser(String userId) async {
    QuerySnapshot snapshots = await FirebaseFirestore.instance
        .collection(APPOINTMENT_TABLE)
        .where("patient_id", isEqualTo: userId)
        .orderBy('date', descending: true)
        .get();

    if (snapshots != null) {
      // print("snapshots : $snapshots");
      appointmentList.clear();
      index = 0;
      if (snapshots.docs != null && snapshots.docs.length > 0) {
        await getAppointmentsFromSnapshot(snapshots);
      }
    }
    return appointmentList;
  }

  Stream<List<Appointment>> streamAppointmentByUser(String userId) async* {
    yield* FirebaseFirestore.instance
        .collection(APPOINTMENT_TABLE)
        .where("patient_id", isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      // print("Snapshot : ${snapshot.docs.toString()}");
      final list = snapshot.docs.map((doc) async {
        final doctor = await getUserById(doc['doctor_id']);
        // print("Doctor : ${doctor.toJson().toString()}");
        Appointment appointment = Appointment.fromJson(doc.data());
        appointment.doctorName =
            "${doctor?.firstName ?? ""} ${doctor?.lastName ?? ""}";
        appointment.doctorPhoto = doctor.photo;
        // print("Appointment : ${appointment.toJson().toString()}");
        return appointment;
      }).toList();
      // print("Snapshot List length : ${list.length}"); // e>>
      return await Future.wait(list);
      //Converts List<Future<Favorite>>// to Future<List<Favorite>>
    });

    // List<Appointment> appointments = [];
    // var appointmentStream = FirebaseFirestore.instance
    //     .collection(APPOINTMENT_TABLE)
    //     .where("patient_id", isEqualTo: userId)
    //     .orderBy('date', descending: true)
    //     .snapshots();
    // await for (var appointmentSnapshot in appointmentStream) {
    //   for (var appointmentDoc in appointmentSnapshot.docs) {
    //     final doctor = await getUserById(appointmentDoc['doctor_id']);
    //     print("Doctor : ${doctor.toJson().toString()}");
    //     Appointment appointment = Appointment.fromJson(appointmentDoc.data());
    //     appointment.doctorName =
    //         "${doctor?.firstName ?? ""} ${doctor?.lastName ?? ""}";
    //     appointment.doctorPhoto = doctor.photo;
    //     print("Appointment : ${appointment.toJson().toString()}");
    //     appointments.add(appointment);
    //   }
    //   yield appointments;
    // }
  }

  List<Appointment> appointmentList = [];

  Future<int> getTotalAppointmentOfDoctor(String doctorId) async {
    QuerySnapshot snapshots = await FirebaseFirestore.instance
        .collection(APPOINTMENT_TABLE)
        .where("doctor_id", isEqualTo: doctorId)
        .get();

    if (snapshots != null &&
        snapshots.docs != null &&
        snapshots.docs.length > 0) {
      return snapshots.docs.length;
    }
    return 0;
  }

  Stream<List<Appointment>> streamAppointmentByDoctor(String doctorId) async* {
    // print("Get Appointment Called");
    yield* FirebaseFirestore.instance
        .collection(APPOINTMENT_TABLE)
        .where("doctor_id", isEqualTo: doctorId)
        .orderBy('date', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      // print("Get Appointment snapshot");
      final list = snapshot.docs.map((doc) async {
        // print("Get Appointment doc ${doc.toString()}");
        final user = await getUserById(doc['patient_id']);
        // print("Get Appointment user ${user.toJson().toString()}");
        Appointment appointment = Appointment.fromJson(doc.data());
        appointment.patientName =
            "${user?.firstName ?? ""} ${user?.lastName ?? ""}";
        appointment.patientPhoto = user.photo;
        return appointment; //Favorite.from(DocumentSnapshot doc, Story story) returns an instance of Favorite
      }).toList(); //List<Future<Favorite>>
      return await Future.wait(list);
      //Converts List<Future<Favorite>>// to Future<List<Favorite>>
    });
  }

  int index = 0;

  getAppointmentsFromSnapshot(QuerySnapshot snapshots) async {
    // print("snapshots : $index");
    QueryDocumentSnapshot data = snapshots.docs[index];
    Appointment appointment = await getAppointmentFromData(data);
    appointmentList.add(appointment);
    snapshots.docs.remove(data);
    index++;
    if (index < snapshots.docs.length) {
      await getAppointmentsFromSnapshot(snapshots);
    }
  }

  Future<Appointment> getAppointmentFromData(
      QueryDocumentSnapshot snapshot) async {
    Appointment appointment = Appointment.fromJson(snapshot.data());
    UserDetails doctor = await getUserById(appointment.doctorId);
    appointment.doctorName =
        "${doctor?.firstName ?? ""} ${doctor?.lastName ?? ""}";
    appointment.doctorPhoto = doctor.photo;

    UserDetails patient = await getUserById(appointment.patientId);
    appointment.patientName =
        "${patient?.firstName ?? ""} ${patient?.lastName ?? ""}";
    appointment.patientPhoto = patient.photo;
    return appointment;
  }

  Future<void> updateAppointmentStatus(String id, int status) async {
    return await FirebaseFirestore.instance
        .collection(APPOINTMENT_TABLE)
        .doc(id)
        .update({"status": status});
  }

  Future<void> submitReview(Appointment appointment) async {
    await FirebaseFirestore.instance
        .collection(APPOINTMENT_TABLE)
        .doc(appointment.id)
        .update(appointment.toJson());

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(APPOINTMENT_TABLE)
        .where('doctor_id', isEqualTo: appointment.doctorId)
        .where('rating', isNotEqualTo: null)
        .get();

    if (snapshot.docs != null && snapshot.docs.length > 0) {
      int count = snapshot.docs.length;
      double totalRating = 0;
      snapshot.docs.forEach((value) {
        // print("Rating : ${value.data()["rating"]}");
        Appointment appointment = Appointment.fromJson(value.data());
        // print("Rating : ${appointment.rating}");
        if (appointment.rating != null) {
          totalRating += appointment.rating;
        }
      });

      double average = totalRating / count;
      // print(" average $average");
      // print(" count $count");

      await FirebaseFirestore.instance
          .collection(USER_TABLE)
          .doc(appointment.doctorId)
          .update({"rating": average, "reviews": count});
    }
  }

  Future<List<Appointment>> getReviewedAppointment(String doctorId) async {
    QuerySnapshot snapshots = await FirebaseFirestore.instance
        .collection(APPOINTMENT_TABLE)
        .where("doctor_id", isEqualTo: doctorId)
        .orderBy('date', descending: true)
        .get();

    if (snapshots != null) {
      // print("snapshots : $snapshots");
      appointmentList.clear();
      index = 0;
      if (snapshots.docs != null && snapshots.docs.length > 0) {
        await getAppointmentsFromSnapshot(snapshots);
      }
    }
    return appointmentList;
  }

  Stream<List<Appointment>> streamReviewedAppointment(String doctorId) async* {
    yield* FirebaseFirestore.instance
        .collection(APPOINTMENT_TABLE)
        .where("doctor_id", isEqualTo: doctorId)
        .where('rating', isNotEqualTo: null)
        .where("reviewed_at", isNotEqualTo: null)
        .orderBy("reviewed_at", descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final list = snapshot.docs.map((doc) async {
        final patient = await getUserById(doc['patient_id']);
        Appointment appointment = Appointment.fromJson(doc.data());
        appointment.patientName =
            "${patient?.firstName ?? ""} ${patient?.lastName ?? ""}";
        appointment.patientPhoto = patient.photo;
        return appointment; //Favorite.from(DocumentSnapshot doc, Story story) returns an instance of Favorite
      }).toList(); //List<Future<Favorite>>
      return await Future.wait(list);
      //Converts List<Future<Favorite>>// to Future<List<Favorite>>
    });
  }

  Future<DocumentReference> setDoctorFavorite(
      String userId, String doctorId) async {
    return await FirebaseFirestore.instance
        .collection(FAVORITE_TABLE)
        .add({"user_id": userId, "doctor_id": doctorId});
  }

  Future<void> removeDoctorFavorite(String referenceId) async {
    await FirebaseFirestore.instance
        .collection(FAVORITE_TABLE)
        .doc(referenceId)
        .delete();
  }

  Future<QuerySnapshot> getFavorite(String userId, String doctorId) async {
    return await FirebaseFirestore.instance
        .collection(FAVORITE_TABLE)
        .where("user_id", isEqualTo: userId)
        .where("doctor_id", isEqualTo: doctorId)
        .get();
  }

  Future<QuerySnapshot> getFavoriteDoctors(String userId) async {
    var snapshot = await FirebaseFirestore.instance
        .collection(FAVORITE_TABLE)
        .where("user_id", isEqualTo: userId)
        .get();

    List<String> favoriteDrIds = [];
    if (snapshot != null && snapshot.docs.length > 0) {
      snapshot.docs.forEach((element) {
        favoriteDrIds.add(element["doctor_id"]);
      });
    }

    if (favoriteDrIds != null && favoriteDrIds.isNotEmpty) {
      return FirebaseFirestore.instance
          .collection(USER_TABLE)
          .where('are_you_doctor', isEqualTo: true)
          .where('is_complete', isEqualTo: true)
          .where("id", whereIn: favoriteDrIds)
          .get();
    } else {
      return null;
    }
  }

  Future startConsultDoctor(String appointmentId) async {
    return await FirebaseFirestore.instance
        .collection(APPOINTMENT_TABLE)
        .doc(appointmentId)
        .update({"chat": true});
  }

  Future<List<String>> getConsultDoctor(String userId) async {
    var snapshot = await FirebaseFirestore.instance
        .collection(APPOINTMENT_TABLE)
        .where("patient_id", isEqualTo: userId)
        .where("chat", isEqualTo: true)
        .get();
    List<String> consultDoctors = [];
    if (snapshot != null && snapshot.docs.length > 0) {
      snapshot.docs.forEach((element) {
        consultDoctors.add(element["doctor_id"]);
      });
    }
    return consultDoctors;
  }

  Future<List<String>> getConsultUser(String doctorId) async {
    var snapshot = await FirebaseFirestore.instance
        .collection(APPOINTMENT_TABLE)
        .where("doctor_id", isEqualTo: doctorId)
        .where("chat", isEqualTo: true)
        .get();
    List<String> consultDoctors = [];
    if (snapshot != null && snapshot.docs.length > 0) {
      snapshot.docs.forEach((element) {
        consultDoctors.add(element["patient_id"]);
      });
    }
    return consultDoctors;
  }

  Stream<List<Appointment>> getReviewedAppointment1(String doctorId) {
    //   let users = {} ;
    //   let loadedPosts = {};
    //   db.collection('users').get().then((results) => {
    //   results.forEach((doc) => {
    //   users[doc.id] = doc.data();
    //   });
    //       posts = db.collection('posts').orderBy('timestamp', 'desc').limit(3);
    //   posts.get().then((docSnaps) => {
    //   docSnaps.forEach((doc) => {
    //   loadedPosts[doc.id] = doc.data();
    //   loadedPosts[doc.id].userName = users[doc.data().uid].name;
    //   });
    // });

    appointmentList.clear();
    FirebaseFirestore.instance
        .collection(APPOINTMENT_TABLE)
        .where("doctor_id", isEqualTo: doctorId)
        .orderBy('date', descending: true)
        .get()
        .then((result) {
      // print("Result : $result");
      result.docs.forEach((element) {
        // print("element : $element");
        Appointment appointment = Appointment.fromJson(element.data());
        getUserById(appointment.patientId).then((patient) {
          appointment.patientName =
              "${patient?.firstName ?? ""} ${patient?.lastName ?? ""}";
          appointment.patientPhoto = patient.photo;
        });
        getUserById(appointment.patientId).then((doctor) {
          appointment.doctorName =
              "${doctor?.firstName ?? ""} ${doctor?.lastName ?? ""}";
          appointment.doctorPhoto = doctor.photo;
        });
        appointmentList.add(appointment);
      });
    });
    return Stream.value(appointmentList);
  }

  Future<bool> hasAppointmentAtTimestamp(
      String patientId, Timestamp date) async {
    QuerySnapshot snapshots = await FirebaseFirestore.instance
        .collection(APPOINTMENT_TABLE)
        .where("patient_id", isEqualTo: patientId)
        .where("date", isEqualTo: date)
        .limit(1)
        .get();

    if (snapshots != null &&
        snapshots.docs != null &&
        snapshots.docs.length > 0) {
      return true;
    }
    return false;
  }

  Future<void> updateAppointmentPrescriptions(
      String id, String prescription) async {
    return await FirebaseFirestore.instance
        .collection(APPOINTMENT_TABLE)
        .doc(id)
        .update({"prescription": prescription});
  }
}
