import 'package:book_my_doctor/src/model/user_details.dart';

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor extends UserDetails {
  String specialization;
  String description;
  bool isFavorite;
  List<int> availableDays;
  List<String> availableSlots;
  String hospitalName;
  String hospitalAddress;
  GeoPoint hospitalGeoPoint;
  int consultFee;
  int experience;
  List<String> referenceImages;

  Doctor({
    this.specialization,
    this.description,
    this.isFavorite,
    this.availableDays,
    this.availableSlots,
    this.hospitalName,
    this.hospitalAddress,
    this.hospitalGeoPoint,
    this.consultFee,
    this.experience,
    this.referenceImages,
  });

  Doctor.fromJson(Map<String, dynamic> json) {
    uid = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    photo = json['photo'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    gender = json['gender'];
    height = json['height'];
    weight = json['weight'];
    areYouDoctor = json['are_you_doctor'];
    specialization = json['specialization'];
    description = json['description'];
    rating = json['rating'];
    reviews = json['reviews'];
    isFavorite = json['is_favorite'];
    availableDays = json['available_days']?.cast<int>();
    availableSlots = json['available_slots']?.cast<String>();
    hospitalName = json['hospital_name'];
    hospitalAddress = json['hospital_address'];
    hospitalGeoPoint = json['hospital_geopoint'];
    consultFee = json['consult_fee'];
    experience = json['experience'];
    referenceImages = json['reference_images']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.uid;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['photo'] = this.photo;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['gender'] = this.gender;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['are_you_doctor'] = this.areYouDoctor;
    data['specialization'] = this.specialization;
    data['description'] = this.description;
    data['rating'] = this.rating;
    data['reviews'] = this.reviews;
    data['is_favorite'] = this.isFavorite;
    data['available_days'] = this.availableDays;
    data['available_slots'] = this.availableSlots;
    data['hospital_name'] = this.hospitalName;
    data['hospital_address'] = this.hospitalAddress;
    data['hospital_geopoint'] = this.hospitalGeoPoint;
    data['consult_fee'] = this.consultFee;
    data['experience'] = this.experience;
    data['reference_images'] = this.referenceImages;
    return data;
  }

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toUserJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.uid;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['photo'] = this.photo;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['address_geopoint'] = this.addressGeoPoint;
    data['gender'] = this.gender;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['are_you_doctor'] = this.areYouDoctor;
    data['rating'] = this.rating;
    data['review'] = this.reviews;
    return data;
  }
}
