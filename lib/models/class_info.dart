import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
import './http_exeception.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:json_annotation/json_annotation.dart';

import './place.dart';

// part 'class_info.g.dart';

@JsonSerializable()
class ClassInformation {
  final String unqId;
  final String currDateTime;
  final String currTime;
  final String currDate;
  final int numOfStudents;
  final double currLatitude;
  final double currLongitude;
  final String currAddress;
  String classroomUrl;
  final File imageFile;

  ClassInformation({
    required this.unqId,
    required this.currDateTime,
    required this.currTime,
    required this.currDate,
    required this.numOfStudents,
    required this.currLatitude,
    required this.currLongitude,
    required this.currAddress,
    required this.classroomUrl,
    required this.imageFile,
  });
}

// factory ClassInformation.fromJson(Map<String, dynamic> json) => _$ClassInformationFromJson(json);

// Map<String, dynamic> toJson() => _$ClassInformation(this);
