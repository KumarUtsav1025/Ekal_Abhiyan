import 'dart:async';
import 'dart:convert';
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
import 'package:firebase_storage/firebase_storage.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models/http_exeception.dart';
import '../models/class_info.dart';
import '../models/place.dart';

class ClassDetails with ChangeNotifier {
  List<ClassInformation> _items = [];

  List<ClassInformation> get items {
    return [..._items];
  }

  Future<void> addNewClass(
      ClassInformation classInfo, File classroomImage) async {
    print('inside the function.');
    final urlLink = Uri.https(
      'flutterdatabase-76af4-default-rtdb.firebaseio.com',
      '/userClassInformation.json',
    );

    final urlParse = Uri.parse(
      'https://flutterdatabase-76af4-default-rtdb.firebaseio.com/userClassInformation.json',
    );

    final imageOfTheClass = FirebaseStorage.instance
        .ref()
        .child('pic_of_classroom')
        .child('${classInfo.unqId}+${classInfo.numOfStudents}+classImg.jpg');

    bool classImgageUploaded = false;
    await imageOfTheClass.putFile(classroomImage).whenComplete(
      () {
        classImgageUploaded = true;
      },
    );

    final classroomImageUrl = await imageOfTheClass.getDownloadURL();

    try {
      classInfo.classroomUrl = classroomImageUrl.toString();
      final response = await http.post(
        urlLink,
        body: json.encode(
          {
            'uniqueInfo': classInfo.unqId.toString(),
            'currDateTime': classInfo.currDateTime.toString(),
            'currTime': classInfo.currTime.toString(),
            'currDate': classInfo.currDate.toString(),
            'numberOfHeads': classInfo.numOfStudents.toString(),
            'currLatitude': classInfo.currLatitude.toString(),
            'currLongitude': classInfo.currLongitude.toString(),
            'currAddress': classInfo.currAddress.toString(),
            'imageLink': classroomImageUrl.toString(),
          },
        ),
      );

      _items.add(classInfo);
      notifyListeners();
    } catch (errorVal) {
      print(errorVal);
    }
  }
}
