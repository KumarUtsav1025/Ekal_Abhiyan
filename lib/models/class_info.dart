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

class ClassInformation {
  final String unqId;
  final DateTime currDateTime;
  final int numOfStudents;
  final int durationOfClass;
  final Place imgLocStart;
  final Place imgLocEnd;
  final List<Position> userClassLocationList;

  ClassInformation({
    required this.unqId,
    required this.currDateTime,
    required this.numOfStudents,
    required this.durationOfClass,
    required this.imgLocStart,
    required this.imgLocEnd,
    required this.userClassLocationList,
  });
}
