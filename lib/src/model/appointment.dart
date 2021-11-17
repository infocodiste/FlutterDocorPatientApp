import 'package:book_my_doctor/src/config/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  String id;
  String number;
  String patientId;
  String patientName;
  String patientPhoto;
  String doctorId;
  String doctorName;
  String doctorPhoto;
  String hospitalName;
  String hospitalAddress;
  int status;
  double rating;
  String comment;
  Timestamp date;
  String timeSlot;
  String prescription;
  Timestamp createdAt;
  Timestamp reviewedAt;

  String rzPaymentID;
  String rzOrderID;
  String rzSignature;

  Appointment(
      {this.id,
      this.number,
      this.patientId,
      this.patientName,
      this.patientPhoto,
      this.doctorId,
      this.doctorName,
      this.doctorPhoto,
      this.hospitalName,
      this.hospitalAddress,
      this.date,
      this.timeSlot,
      this.status,
      this.rating,
      this.comment,
      this.prescription,
      this.createdAt,
      this.reviewedAt,
      this.rzPaymentID,
      this.rzOrderID,
      this.rzSignature});

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    patientId = json['patient_id'];
    patientName = json['patient_name'];
    patientPhoto = json['patient_photo'];
    doctorId = json['doctor_id'];
    doctorName = json['doctor_name'];
    doctorPhoto = json['doctor_photo'];
    hospitalName = json['hospital_name'];
    hospitalAddress = json['hospital_address'];
    date = json['date'];
    timeSlot = json['time_slot'];
    status = json['status'] ?? APPOINTMENT_STATUS.PENDING.index;
    rating = json['rating'];
    comment = json['comment'];
    prescription = json['prescription'];
    createdAt = json['created_at'];
    reviewedAt = json['reviewed_at'];
    rzPaymentID = json['rz_payment_id'];
    rzOrderID = json['rz_order_id'];
    rzSignature = json['rz_signature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['patient_id'] = this.patientId;
    data['patient_name'] = this.patientName;
    data['patient_photo'] = this.patientPhoto;
    data['doctor_id'] = this.doctorId;
    data['doctor_name'] = this.doctorName;
    data['doctor_photo'] = this.doctorPhoto;
    data['hospital_name'] = this.hospitalName;
    data['hospital_address'] = this.hospitalAddress;
    data['date'] = date;
    data['time_slot'] = timeSlot;
    data['status'] = this.status ?? APPOINTMENT_STATUS.PENDING.index;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['prescription'] = this.prescription;
    data['created_at'] = this.createdAt;
    data['reviewed_at'] = this.reviewedAt;
    data['rz_payment_id'] = this.rzPaymentID;
    data['rz_order_id'] = this.rzOrderID;
    data['rz_signature'] = this.rzSignature;
    return data;
  }
}
