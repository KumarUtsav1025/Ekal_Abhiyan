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
import 'package:sqflite/sqflite.dart' as sql;

import '../models/http_exeception.dart';
import '../models/class_info.dart';
import '../models/place.dart';

class ClassDetails with ChangeNotifier {
  List<ClassInformation> _items = [];

  List<ClassInformation> get items {
    return [..._items];
  }

  Future<void> addNewClass (
    DateTime dtVal,
    int numStudents,
    int duration,
    Place il1,
    Place il2,
    List<Position> userLocList,
  ) async {
    final newClass = ClassInformation(
      unqId: '${DateTime.now()}+${dtVal}+${numStudents}+${duration}+${DateTime.now()}',
      currDateTime: dtVal,
      numOfStudents: numStudents,
      durationOfClass: duration,
      imgLocStart: il1,
      imgLocEnd: il2,
      userClassLocationList: userLocList,
    );

    _items.add(newClass);
    notifyListeners();
  }
}
