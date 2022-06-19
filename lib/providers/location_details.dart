import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/tabs_screen.dart';
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

import '../screens/tabs_screen.dart';
import '../models/visitor_info.dart';
import '../providers/user_details.dart';

class LocationDetails with ChangeNotifier {
  List<VisitorInformation> _items = [];

  List<VisitorInformation> get items {
    return [..._items];
  }

  Future<void> addLocationDetails(
    BuildContext context,
    String visitorName,
    String visitorMobileNumber,
    String visitorDayitva,
    String visitorAddressType,
    String visitorState,
    String visitorRegion,
    String visitorDistrict,
    String visitorAnchal,
    String visitorSankul,
    String visitorCluster,
    String visitorSubCluster,
    String visitorVillage,
    String detailsProviderUniqueId,
    File fetchedImg,
    String fetchedDateTime,
    String fetchedLatitude,
    String fetchedLongitude,
    String fetchedAddress,
  ) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference usersRef = db.collection("userPersonalInformation");

    var currLoggedInUser = await FirebaseAuth.instance.currentUser;
    var loggedInUserId = currLoggedInUser?.uid as String;

    final urlLink = Uri.https(
      'flutterdatabase-76af4-default-rtdb.firebaseio.com',
      '/FetchedLocationDetails.json',
    );

    String imageName =
        "${loggedInUserId}_${DateTime.now().toString()}_LocationImg.jpg";
    final imageOfTheLocation = FirebaseStorage.instance
        .ref()
        .child('FetchedLocationPictures')
        .child('${imageName}');

    bool locationImgageUploaded = false;
    await imageOfTheLocation.putFile(fetchedImg).whenComplete(
      () {
        locationImgageUploaded = true;
      },
    );

    final locationImageUrl = await imageOfTheLocation.getDownloadURL();

    try {
      final responseForPartialLocationDetails = await http.post(
        urlLink,
        body: json.encode(
          {
            'name': visitorName.toString(),
            'mobileNumber': visitorMobileNumber.toString(),
            'dayitva': visitorDayitva.toString(),
            'addressType': visitorAddressType.toString(),
            'state': visitorState.toString(),
            'region': visitorRegion.toString(),
            'district': visitorDistrict.toString(),
            'anchal': visitorAnchal.toString(),
            'sankul': visitorSankul.toString(),
            'cluster': visitorCluster.toString(),
            'subCluster': visitorSubCluster.toString(),
            'village': visitorVillage.toString(),
            'detailsProviderUniqueId': detailsProviderUniqueId.toString(),
            'currDateTime': fetchedDateTime.toString(),
            'currLatitude': fetchedLatitude.toString(),
            'currLongitude': fetchedLongitude.toString(),
            'currAddress': fetchedAddress.toString(),
            'imageLink': locationImageUrl.toString(),
          },
        ),
      );

      // Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
      notifyListeners();
    } catch (errorVal) {
      print(errorVal);
    }
  }

  Future<void> fetchregisteredLocations() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference usersRef = db.collection("userPersonalInformation");

    var currLoggedInUser = await FirebaseAuth.instance.currentUser;
    var loggedInUserId = currLoggedInUser?.uid as String;

    final urlLink = Uri.https(
      'flutterdatabase-76af4-default-rtdb.firebaseio.com',
      '/FetchedLocationDetails.json',
    );

    final urlParse = Uri.parse(
      'https://flutterdatabase-76af4-default-rtdb.firebaseio.com/FetchedLocationDetails.json',
    );

    try {
      final dataBaseResponse = await http.get(urlLink);
      final extractedLocation =
          json.decode(dataBaseResponse.body) as Map<String, dynamic>;

      if (extractedLocation != Null) {
        final List<VisitorInformation> loadedPreviousLocations = [];

        extractedLocation.forEach(
          (locationId, locationData) {
            // print('In...');
            // print(classId);
            // print(classData);
            // print('Out...');

            VisitorInformation fetchedLocation = new VisitorInformation(
              visitorUniqueId: locationId,
              visitorName: locationData['name'],
              visitorMobileNumber: locationData['mobileNumber'],
              visitorDayitva: locationData['dayitva'],
              visitorAddressType: locationData['addressType'],
              visitorState: locationData['state'],
              visitorRegion: locationData['region'],
              visitorDistrict: locationData['district'],
              visitorAnchal: locationData['anchal'],
              visitorSankul: locationData['sankul'],
              visitorCluster: locationData['cluster'],
              visitorSubCluster: locationData['subCluster'],
              visitorVillage: locationData['village'],
              visitorImgFileLink: locationData['imageLink'],
              detailsProviderUniqueId: locationData['detailsProviderUniqueId'],
              fetchingDateTime: locationData['currDateTime'],
              fetchedLatitude: locationData['currLatitude'],
              fetchedLongitude: locationData['currLongitude'],
              fetchedAddress: locationData['currAddress'],
            );

            loadedPreviousLocations.add(fetchedLocation);
          },
        );

        _items = loadedPreviousLocations;
        notifyListeners();
      }
    } catch (errorVal) {
      print("Error Value");
      print(errorVal);
    }
  }
}
