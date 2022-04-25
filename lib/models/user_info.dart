import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPath;
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart' as sql;

class userInformation {
  final String firstName;
  final String lastName;
  final int age;
  final DateTime dateOfBirth;
  final String eduQualification;
  final String gender;
  final String currAddress;
  final String permanentAddress;
  final String districtName;
  final String stateName;
  final int postalCode;
  final int phoneNumber;

  userInformation({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.dateOfBirth,
    required this.eduQualification,
    required this.gender,
    required this.currAddress,
    required this.permanentAddress,
    required this.districtName,
    required this.stateName,
    required this.postalCode,
    required this.phoneNumber,
  });
}
