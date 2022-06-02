import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
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

import '../screens/tabs_screen.dart';

import '../models/http_exeception.dart';
import '../models/class_info.dart';
import '../models/place.dart';

class AuthDetails with ChangeNotifier {
  List<String> existingUserPhoneNumberList = [];

  List<String> get getUserPhoneNumberList {
    return [...this.existingUserPhoneNumberList];
  }

  bool get isPhoneNumberListEmpty {
    if (this.existingUserPhoneNumberList.isEmpty) {
      return true;
    }
    else {
      return false;
    }
  }

  Future<void> getExistingUserPhoneNumbers() async {
    // var currLoggedInUser = await FirebaseAuth.instance.currentUser;
    // var loggedInUserId = currLoggedInUser?.uid as String;

    final urlLink = Uri.https(
      'flutterdatabase-76af4-default-rtdb.firebaseio.com',
      '/UsersPhoneNumber.json',
    );

    final urlParse = Uri.parse(
      'https://flutterdatabase-76af4-default-rtdb.firebaseio.com/UsersPhoneNumber.json',
    );

    try {
      final dataBaseResponse = await http.get(urlLink);
      final extractedClass =
          json.decode(dataBaseResponse.body) as Map<String, dynamic>;

      if (extractedClass != Null) {
        final List<String> phoneNumberList = [];
        extractedClass.forEach(
          (phoneId, phoneData) {
            phoneNumberList.add(phoneData['phoneNumber']);
          },
        );

        existingUserPhoneNumberList = phoneNumberList;
        notifyListeners();
      }
    } catch (errorVal) {
      print("Error Value");
      print(errorVal);
    }
  }
}
