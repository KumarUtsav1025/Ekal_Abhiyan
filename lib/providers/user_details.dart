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
import '../screens/login_screen.dart';

import '../models/http_exeception.dart';
import '../models/class_info.dart';
import '../models/place.dart';

class UserDetails with ChangeNotifier {
  late UserCredential userCred;
  late UserCredential nullUserCred;
  List<String> existingUserNumbers = [];
  Map<String, String> mp = {};
  String loggedInUserUniqueCred = "";

  // UserCredential get getUserAuthCredentials {
  //   return userCred;
  // }

  Map<String, String> getUserPersonalInformation() {
    return mp;
  }

  String getLoggedInUserUniqueId() {
    return this.loggedInUserUniqueCred;
  }

  Future<void> clearStateOfLoggedInUser(BuildContext context) async {
    this.mp = {};
    FirebaseAuth.instance.signOut();
    // Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    Navigator.of(context).pushNamedAndRemoveUntil("/login-screen", (route) => false);
  }

  Future<void> setUserInfo() async {
    // FirebaseFirestore db = FirebaseFirestore.instance;
    // CollectionReference usersRef = db.collection("userPersonalInformation");

    // var currLoggedInUser = await FirebaseAuth.instance.currentUser;
    // var loggedInUserId = currLoggedInUser?.uid as String;

    if (mp.length == 0) {
      var currLoggedInUser = await FirebaseAuth.instance.currentUser;
      var loggedInUserId = currLoggedInUser?.uid as String;

      this.loggedInUserUniqueCred = loggedInUserId;

      var response = await FirebaseFirestore.instance
          .collection('userPersonalInformation')
          .doc(loggedInUserId)
          .get()
          .then(
        (DocumentSnapshot ds) {
          String firstName = ds.get('first_Name').toString().toUpperCase();
          String lastName = ds.get('last_Name').toString().toUpperCase();
          String age = ds.get('age').toString();
          String gender = ds.get('gender').toString();
          String dateOfBirth = ds.get('date_Of_Birth').toString();
          String eduQualification =
              ds.get('education_Qualification').toString();
          String phone_Number = ds.get('phone_Number').toString();
          String current_Address = ds.get('current_Address').toString();
          String permanent_Address = ds.get('permanent_Address').toString();
          String state = ds.get('state').toString();
          String district = ds.get('district').toString();
          String block = ds.get('block_Level').toString();
          String villageGroup = ds.get('village_Group').toString();
          String village = ds.get('village').toString();
          String postal_Code = ds.get('postal_Code').toString();
          String profilePic = ds.get('profilePic_Url').toString();

          mp["first_Name"] = firstName;
          mp["last_Name"] = lastName;
          mp["age"] = age;
          mp["gender"] = gender;
          mp["date_Of_Birth"] = dateOfBirth;
          mp["education_Qualification"] = eduQualification;
          mp["phone_Number"] = phone_Number;
          mp["current_Address"] = current_Address;
          mp["permanent_Address"] = permanent_Address;
          mp["state"] = state;
          mp["district"] = district;
          mp["block_Level"] = block;
          mp["village_Group"] = villageGroup;
          mp["village"] = village;
          mp["postal_Code"] = postal_Code;
          mp["profilePic_Url"] = profilePic;
        },
      );
    }
  }

  Future<void> updateUserPersonalInformation() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference usersRef = db.collection("userPersonalInformation");

    var currLoggedInUser = await FirebaseAuth.instance.currentUser;
    var loggedInUserId = currLoggedInUser?.uid as String;
  }

  Future<void> upLoadNewUserPersonalInformation(
    BuildContext context,
    UserCredential authCredential,
    TextEditingController firstName,
    TextEditingController lastName,
    TextEditingController age,
    DateTime dateOfBirth,
    TextEditingController gender,
    TextEditingController eduQualification,
    TextEditingController localAddress,
    TextEditingController permanentAddress,
    TextEditingController state_SAMBHAG_Name,
    TextEditingController district_BHAG_Name,
    TextEditingController block_ANCHAL_Name,
    TextEditingController groupVillage_SANCH_Name,
    TextEditingController village_Village_Name,
    TextEditingController postalCode,
    TextEditingController userPhoneNumber,
    bool profilePicAvailable,
    File profilePicFile,
  ) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference usersRef = db.collection("userPersonalInformation");

    var currLoggedInUser = await FirebaseAuth.instance.currentUser;
    var loggedInUserId = currLoggedInUser?.uid as String;

    final urlLinkForPhoneNumbers = Uri.https(
      'flutterdatabase-76af4-default-rtdb.firebaseio.com',
      '/UsersPhoneNumber.json',
    );

    final response1 = await http.post(
      urlLinkForPhoneNumbers,
      body: json.encode(
        {
          'phoneNumber': userPhoneNumber.text.toString(),
        },
      ),
    );

    if (profilePicAvailable == false) {
      final submissionResponse = await FirebaseFirestore.instance
          .collection('userPersonalInformation')
          .doc(authCredential.user?.uid)
          .set(
        {
          'first_Name': firstName.text.toString(),
          'last_Name': lastName.text.toString(),
          'age': age.text.toString(),
          'date_Of_Birth':
              DateFormat('dd/MM/yyyy').format(dateOfBirth).toString(),
          'gender': gender.text.toString(),
          'education_Qualification': eduQualification.text.toString(),
          'current_Address': localAddress.text.toString(),
          'permanent_Address': permanentAddress.text.toString(),
          'state': state_SAMBHAG_Name.text.toString(),
          'district': district_BHAG_Name.text.toString(),
          'block_Level': block_ANCHAL_Name.text.toString(),
          'village_Group': groupVillage_SANCH_Name.text.toString(),
          'village': village_Village_Name.text.toString(),
          'postal_Code': postalCode.text.toString(),
          'phone_Number': userPhoneNumber.text.toString(),
          'creation_Timing': DateTime.now().toString(),
          'profilePic_Url': "",
        },
      );

      // Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
      Navigator.of(context).pushNamedAndRemoveUntil("/tab-screen", (route) => false);
    } else {
      String imageName =
          "${loggedInUserId}_${DateTime.now().toString()}_profilePicture.jpg";

      String dateVal = DateFormat('dd/MM/yyyy').format(dateOfBirth).toString();
      final profilePicture = FirebaseStorage.instance
          .ref()
          .child(
            'UserProfilePictures/${loggedInUserId}',
          )
          .child('${imageName}');

      bool classImgageUploaded = false;
      await profilePicture.putFile(profilePicFile).whenComplete(
        () {
          classImgageUploaded = true;
        },
      );

      final classroomImageUrl = await profilePicture.getDownloadURL();

      final submissionResponse = await FirebaseFirestore.instance
          .collection('userPersonalInformation')
          .doc(authCredential.user?.uid)
          .set(
        {
          'first_Name': firstName.text.toString(),
          'last_Name': lastName.text.toString(),
          'age': age.text.toString(),
          'date_Of_Birth':
              DateFormat('dd/MM/yyyy').format(dateOfBirth).toString(),
          'gender': gender.text.toString(),
          'education_Qualification': eduQualification.text.toString(),
          'current_Address': localAddress.text.toString(),
          'permanent_Address': permanentAddress.text.toString(),
          'state': state_SAMBHAG_Name.text.toString(),
          'district': district_BHAG_Name.text.toString(),
          'block_Level': block_ANCHAL_Name.text.toString(),
          'village_Group': groupVillage_SANCH_Name.text.toString(),
          'village': village_Village_Name.text.toString(),
          'postal_Code': postalCode.text.toString(),
          'phone_Number': userPhoneNumber.text.toString(),
          'creation_Timing': DateTime.now().toString(),
          'profilePic_Url': classroomImageUrl.toString(),
        },
      );

      // Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
      Navigator.of(context).pushNamedAndRemoveUntil("/tab-screen", (route) => false);
    }
  }
}
