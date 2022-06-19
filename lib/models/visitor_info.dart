import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:sqflite/sqflite.dart' as sql;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:localstorage/localstorage.dart';

class VisitorInformation {
  final String visitorUniqueId;
  final String visitorName;
  final String visitorMobileNumber;
  final String visitorDayitva;
  final String visitorAddressType;
  final String visitorState;
  final String visitorRegion;
  final String visitorDistrict;
  final String visitorAnchal;
  final String visitorSankul;
  final String visitorCluster;
  final String visitorSubCluster;
  final String visitorVillage;
  final String visitorImgFileLink;
  final String detailsProviderUniqueId;
  final String fetchingDateTime;
  final String fetchedLatitude;
  final String fetchedLongitude;
  final String fetchedAddress;

  VisitorInformation({
    required this.visitorUniqueId,
    required this.visitorName,
    required this.visitorMobileNumber,
    required this.visitorDayitva,
    required this.visitorAddressType,
    required this.visitorState,
    required this.visitorRegion,
    required this.visitorDistrict,
    required this.visitorAnchal,
    required this.visitorSankul,
    required this.visitorCluster,
    required this.visitorSubCluster,
    required this.visitorVillage,
    required this.visitorImgFileLink,
    required this.detailsProviderUniqueId,
    required this.fetchingDateTime,
    required this.fetchedLatitude,
    required this.fetchedLongitude,
    required this.fetchedAddress,
  });
}
