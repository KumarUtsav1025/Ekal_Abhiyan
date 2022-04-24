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

  bool checkMaxDistance(List<Position> userLatLongList) {
    int l = 0;
    double latitude1 = 0.0, longitude1 = 0.0, latitude2 = 0.0, longitude2 = 0.0;
    double dlat = 0.0, dlong = 0.0;
    double radius = 6371.0; // km

    if (userLatLongList.length <= 1) {
      return false;
    }

    double factorVal = 0.01744533;
    l = userLatLongList.length;
    latitude1 = userLatLongList[0].latitude;
    longitude1 = userLatLongList[0].longitude;
    latitude2 = userLatLongList[l - 1].latitude;
    longitude2 = userLatLongList[l - 1].longitude;
    dlat = factorVal * (latitude2 - latitude1);
    dlong = factorVal * (longitude2 - longitude1);

    double a = 0.0, c = 0.0, d = 0.0;
    a = (sin(dlat / 2) * sin(dlat / 2)) +
        cos(factorVal * latitude1) *
            cos(factorVal * latitude2) *
            sin(dlong / 2) *
            sin(dlong / 2);
    c = 2 * atan2(sqrt(a), sqrt(1 - a));

    d = radius * c;

    if (d >= 0.020) {
      return true;
    } else {
      return false;
    }
  }

  String timeFormater(int duration) {
    String timeDuration = "";
    if (duration < 60) {
      timeDuration = '${duration} min';
    } else if (duration % 60 == 0) {
      timeDuration = '${duration / 60} hrs';
    } else {
      int hr = (duration / 60) as int;
      int min = duration - (hr * 60);
      timeDuration = '${hr} hrs ${min} min';
    }

    return timeDuration;
  }

  Future<void> addNewClass(
    DateTime dtVal,
    int numStudents,
    int duration,
    Place il1,
    Place il2,
    List<Position> userLocList,
  ) async {
    // final newClass = ClassInformation(
    //   unqId:
    //       '${DateTime.now()}+${dtVal}+${numStudents}+${duration}+${DateTime.now()}',
    //   currDateTime: dtVal,
    //   numOfStudents: numStudents,
    //   durationOfClass: duration,
    //   imgLocStart: il1,
    //   imgLocEnd: il2,
    //   userClassLocationList: userLocList,
    // );
    // _items.add(newClass);

    final urlLink = Uri.https(
      'flutterdatabase-76af4-default-rtdb.firebaseio.com',
      '/userClassInformation.json',
    );

    final urlParse = Uri.parse(
      'https://flutterdatabase-76af4-default-rtdb.firebaseio.com/userClassInformation.json',
    );

    String timeDurationFormat = timeFormater(duration);

    final startingClassImage = FirebaseStorage.instance
        .ref()
        .child('starting_class_image')
        .child('${dtVal}+${numStudents}+${duration}+startImg.jpg');
    final endingClassImage = FirebaseStorage.instance
        .ref()
        .child('ending_class_image')
        .child('${dtVal}+${numStudents}+${duration}+endImg.jpg');

    bool img1Upload = false;
    bool img2Upload = false;
    await startingClassImage.putFile(il1.image).whenComplete(
      () {
        img1Upload = true;
      },
    );
    await endingClassImage.putFile(il2.image).whenComplete(
      () {
        img2Upload = true;
      },
    );

    final startClassImgUrl = await startingClassImage.getDownloadURL();
    final endClassImgUrl = await endingClassImage.getDownloadURL();

    try {
      print('inside val');
      final response = await http.post(
        urlParse,
        body: json.encode(
          {
            'dateTime': dtVal.toString(),
            'students': numStudents,
            'duration': timeDurationFormat,
            'stClassTitle': il1.title.toString(),
            'stClassImg': startClassImgUrl.toString(),
            'stClassLatitude': il1.location.latitude.toString(),
            'stClassLongitude': il1.location.longitude.toString(),
            'stClassAddress': il1.location.address.toString(),
            'edClassTitle': il2.title.toString(),
            'edClassImg': endClassImgUrl.toString(),
            'edClassLatitude': il2.location.latitude.toString(),
            'edClassLongitude': il2.location.longitude.toString(),
            'edClassAddress': il2.location.address.toString(),
            'userPositionList': jsonEncode(userLocList),
            'flag': checkMaxDistance(userLocList).toString(),
          },
        ),
      );

      final newClass = ClassInformation(
        unqId: json.decode(response.body)['name'],
        currDateTime: dtVal,
        numOfStudents: numStudents,
        durationOfClass: duration,
        imgLocStart: il1,
        imgLocEnd: il2,
        userClassLocationList: userLocList,
      );

      _items.add(newClass);
      notifyListeners();
    } catch (errorVal) {
      print(errorVal);
    }
  }

  Future<void> fetchUserPrevClasses() async {
    final urlLink = Uri.https(
      'flutterdatabase-76af4-default-rtdb.firebaseio.com',
      '/userClassInformation.json',
    );
    final urlParse = Uri.parse(
      'https://flutterdatabase-76af4-default-rtdb.firebaseio.com/userClassInformation.json',
    );

    try {
      final fetchedResponse = await http.get(urlParse);
      print(fetchedResponse);
      print(json.encode(fetchedResponse.body));
    }
    catch(errorVal) {
      print(errorVal);
      throw (errorVal);
    }
  }
}
