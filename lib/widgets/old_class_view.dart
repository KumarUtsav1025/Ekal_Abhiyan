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

import '../models/class_info.dart';
import '../models/http_exeception.dart';
import '../models/place.dart';

import '../providers/class_details.dart';

class OldClassView extends StatefulWidget {
  final ClassInformation classData;

  OldClassView(this.classData);
  
  @override
  State<OldClassView> createState() => _OldClassViewState();
}

class _OldClassViewState extends State<OldClassView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}