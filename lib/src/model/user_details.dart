import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserDetails with ChangeNotifier {
  String uid;
  String firstName;
  String lastName;
  String photo;
  String email;
  String phone;
  String address;
  GeoPoint addressGeoPoint;
  String gender;
  double height;
  double weight;
  String bloodGroup;
  bool areYouDoctor;
  double rating;
  int reviews;
  bool isComplete;

  UserDetails(
      {this.uid,
      this.firstName,
      this.lastName,
      this.photo,
      this.email,
      this.phone,
      this.address,
      this.addressGeoPoint,
      this.gender,
      this.height,
      this.weight,
      this.bloodGroup,
      this.areYouDoctor = false,
      this.rating,
      this.reviews,
      this.isComplete = false});

  UserDetails.fromJson(Map<String, dynamic> json) {
    this.uid = json['id'];
    this.firstName = json['first_name'];
    this.lastName = json['last_name'];
    this.photo = json['photo'];
    this.email = json['email'];
    this.phone = json['phone'];
    this.address = json['address'];
    this.addressGeoPoint = json['address_geopoint'];
    this.gender = json['gender'];
    this.height = json['height'];
    this.weight = json['weight'];
    this.bloodGroup = json['blood_group'];
    this.areYouDoctor = json['are_you_doctor'] ?? false;
    this.rating = json['rating'];
    this.reviews = json['reviews'] ?? 0;
    this.isComplete = json['is_complete'] ?? false;
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
    data['address_geopoint'] = this.addressGeoPoint;
    data['gender'] = this.gender;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['blood_group'] = this.bloodGroup;
    data['are_you_doctor'] = this.areYouDoctor ?? false;
    data['rating'] = this.rating;
    data['reviews'] = this.reviews ?? 0;
    data['is_complete'] = this.isComplete ?? false;
    return data;
  }

  String toRawJson() => json.encode(toJson());

  void notifyUpdateUser(UserDetails user) {
    this.uid = user.uid;
    this.firstName = user.firstName;
    this.lastName = user.lastName;
    this.photo = user.photo;
    this.email = user.email;
    this.phone = user.phone;
    this.address = user.address;
    this.addressGeoPoint = user.addressGeoPoint;
    this.gender = user.gender;
    this.height = user.height;
    this.weight = user.weight;
    this.bloodGroup = user.bloodGroup;
    this.areYouDoctor = user.areYouDoctor;
    this.rating = user.rating;
    this.reviews = user.reviews ?? 0;
    this.isComplete = user.isComplete;
    notifyListeners();
  }
}
