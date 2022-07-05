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

import '../models/http_exeception.dart';
import '../models/class_info.dart';
import '../models/place.dart';

class ClassDetails with ChangeNotifier {
  List<ClassInformation> _items = [];

  List<ClassInformation> get items {
    return [..._items];
  }

  int numberOfClassesTaken() {
    int numOfclass = _items.length / 2 as int;

    print(numOfclass);
    return numOfclass;
  }

  Future<void> clearClassDetails(BuildContext context) async {
    this._items = [];
  }

  Future<void> addNewClass(
    ClassInformation classInfo,
    File classroomImage,
    TextEditingController cntStudents,
  ) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference usersRef = db.collection("userPersonalInformation");

    var currLoggedInUser = await FirebaseAuth.instance.currentUser;
    var loggedInUserId = currLoggedInUser?.uid as String;

    final urlLink = Uri.https(
      'flutterdatabase-76af4-default-rtdb.firebaseio.com',
      '/ExistingUser/${loggedInUserId}/userClassInformation.json',
    );

    final urlLinkForCompleteClassDetails = Uri.https(
      'flutterdatabase-76af4-default-rtdb.firebaseio.com',
      '/CompleteClassDetails/${loggedInUserId}/${DateFormat.jm().format(DateTime.now()).toString()}.json',
    );

    final urlParse = Uri.parse(
      'https://flutterdatabase-76af4-default-rtdb.firebaseio.com/ExistingUser/${loggedInUserId}/userClassInformation.json',
    );

    String imageName =
        "${loggedInUserId}_${DateTime.now().toString()}_classImg.jpg";
    final imageOfTheClass = FirebaseStorage.instance
        .ref()
        .child(
            'ClassroomPictures/${loggedInUserId}/${classInfo.currDate.toString()}')
        .child('${imageName}');

    bool classImgageUploaded = false;
    await imageOfTheClass.putFile(classroomImage).whenComplete(
      () {
        classImgageUploaded = true;
      },
    );

    final classroomImageUrl = await imageOfTheClass.getDownloadURL();

    try {
      classInfo.classroomUrl = classroomImageUrl.toString();
      final responseForPartialClassDetails = await http.post(
        urlLink,
        body: json.encode(
          {
            'uniqueInfo': classInfo.unqId.toString(),
            'currDateTime': classInfo.currDateTime.toString(),
            'currTime': classInfo.currTime.toString(),
            'currDate': classInfo.currDate.toString(),
            'numberOfHeads': classInfo.numOfStudents.toString(),
            'enteredStudnets': cntStudents.text.toString(),
            'currLatitude': classInfo.currLatitude.toString(),
            'currLongitude': classInfo.currLongitude.toString(),
            'currAddress': classInfo.currAddress.toString(),
            'imageLink': classroomImageUrl.toString(),
          },
        ),
      );

      if (this._items.length % 2 != 0) {
        DateTime t1 =
            DateTime.parse(this._items[this._items.length - 1].currDateTime);
        DateTime t2 = DateTime.parse(classInfo.currDateTime.toString());
        final diff_hr = t2.difference(t1).inHours;
        final diff_mn = t2.difference(t1).inMinutes;
        final rmn_mn = diff_mn - (diff_hr*60);

        String classDuration = "";
        if (diff_hr == 0) {
          classDuration = "${diff_mn} min";
        } else if (diff_mn == 0) {
          classDuration = "${diff_hr} hr";
        } else {
          classDuration = "${diff_hr} hr ${rmn_mn} min";
        }

        final responseForCompleteClassDetails = await http.post(
          urlLinkForCompleteClassDetails,
          body: json.encode(
            {
              'currDateTime_1':
                  this._items[this._items.length - 1].currDateTime.toString(),
              'currTime_1':
                  this._items[this._items.length - 1].currTime.toString(),
              'currDate_1':
                  this._items[this._items.length - 1].currDate.toString(),
              'numberOfHeads_1':
                  this._items[this._items.length - 1].numOfStudents.toString(),
              'currLatitude_1':
                  this._items[this._items.length - 1].currLatitude.toString(),
              'currLongitude_1':
                  this._items[this._items.length - 1].currLongitude.toString(),
              'currAddress_1':
                  this._items[this._items.length - 1].currAddress.toString(),
              'imageLink_1':
                  this._items[this._items.length - 1].classroomUrl.toString(),

              'currDateTime_2': classInfo.currDateTime.toString(),
              'currTime_2': classInfo.currTime.toString(),
              'currDate_2': classInfo.currDate.toString(),
              'numberOfHeads_2': classInfo.numOfStudents.toString(),
              'currLatitude_2': classInfo.currLatitude.toString(),
              'currLongitude_2': classInfo.currLongitude.toString(),
              'currAddress_2': classInfo.currAddress.toString(),
              'imageLink_2': classroomImageUrl.toString(),

              'class_duration': classDuration,
            },
          ),
        );
      }

      // _items.add(classInfo);
      notifyListeners();
    } catch (errorVal) {
      print(errorVal);
    }
  }

  Future<void> fetchPreviousClasses() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference usersRef = db.collection("userPersonalInformation");

    var currLoggedInUser = await FirebaseAuth.instance.currentUser;
    var loggedInUserId = currLoggedInUser?.uid as String;

    final urlLink = Uri.https(
      'flutterdatabase-76af4-default-rtdb.firebaseio.com',
      '/ExistingUser/${loggedInUserId}/userClassInformation.json',
    );

    final urlParse = Uri.parse(
      'https://flutterdatabase-76af4-default-rtdb.firebaseio.com/ExistingUser/${loggedInUserId}/userClassInformation.json',
    );

    try {
      final dataBaseResponse = await http.get(urlLink);
      final extractedClass =
          json.decode(dataBaseResponse.body) as Map<String, dynamic>;

      if (extractedClass != Null) {
        final List<ClassInformation> loadedPreviousClasses = [];

        extractedClass.forEach(
          (classId, classData) {
            // print('In...');
            // print(classId);
            // print(classData);
            // print('Out...');

            ClassInformation prevClass = new ClassInformation(
              unqId: classId,
              currDateTime: classData['currDateTime'],
              currTime: classData['currTime'],
              currDate: classData['currDate'],
              numOfStudents: int.parse(classData['numberOfHeads']),
              currLatitude: double.parse(classData['currLatitude']),
              currLongitude: double.parse(classData['currLongitude']),
              currAddress: classData['currAddress'],
              classroomUrl: classData['imageLink'],
              imageFile: File(""),
            );

            loadedPreviousClasses.add(prevClass);
          },
        );

        _items = loadedPreviousClasses;
        notifyListeners();
      }
    } catch (errorVal) {
      print("Error Value");
      print(errorVal);
    }
  }
}
