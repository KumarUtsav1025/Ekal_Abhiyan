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
    Navigator.of(context)
        .pushNamedAndRemoveUntil("/login-screen", (route) => false);
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
          String designationType = "";
          String designationRoleType = "";
          String dayitvaType = "";

          String firstName = "";
          String lastName = "";
          String age = "";
          String gender = "";
          String dateOfBirth = "";
          String eduQualification = "";
          String mobile_Number = "";
          String home_Address = "";
          String school_Address = "";
          String postal_Code = "";
          String profilePic = "";

          String prabhag_LevelType = "";
          String sambhag_LevelType = "";
          String bhag_LevelType = "";
          String anchal_LevelType = "";
          String cluster_LevelType = "";
          String sanch_LevelType = "";
          String upSanch_LevelType = "";
          String village_LevelType = "";


          designationType = ds.get('designation_Type').toString();
          designationRoleType = ds.get('designation_RoleType').toString();
          dayitvaType = ds.get('dayitva_Type').toString();

          // if ((ds as Map<String,dynamic>).containsKey('designation_Type')) {
          //   designationType = ds.get('designation_Type').toString();
          // }
          // if ((ds as Map<String,dynamic>).containsKey('designation_RoleType')) {
          //   designationRoleType = ds.get('designation_RoleType').toString();
          // }
          // if ((ds as Map<String,dynamic>).containsKey('dayitva_Type')) {
          //   dayitvaType = ds.get('dayitva_Type').toString();
          // }

          firstName = ds.get('first_Name').toString().toUpperCase();
          lastName = ds.get('last_Name').toString().toUpperCase();
          age = ds.get('age').toString();
          gender = ds.get('gender').toString();
          dateOfBirth = ds.get('date_Of_Birth').toString();
          eduQualification = ds.get('education_Qualification').toString();
          mobile_Number = ds.get('mobile_Number').toString();
          home_Address = ds.get('home_Address').toString();
          school_Address = ds.get('school_Address').toString();
          postal_Code = ds.get('postal_Code').toString();
          profilePic = ds.get('profilePic_Url').toString();


          // if ((ds as Map<String,dynamic>).containsKey('first_Name')) {
          //   firstName = ds.get('first_Name').toString().toUpperCase();
          // }
          // if ((ds as Map<String,dynamic>).containsKey('last_Name')) {
          //   lastName = ds.get('last_Name').toString().toUpperCase();
          // }
          // if ((ds as Map<String,dynamic>).containsKey('age')) {
          //   age = ds.get('age').toString();
          // }
          // if ((ds as Map<String,dynamic>).containsKey('gender')) {
          //   gender = ds.get('gender').toString();
          // }
          // if ((ds as Map<String,dynamic>).containsKey('date_Of_Birth')) {
          //   dateOfBirth = ds.get('date_Of_Birth').toString();
          // }
          // if ((ds as Map<String,dynamic>).containsKey('education_Qualification')) {
          //   eduQualification = ds.get('education_Qualification').toString();
          // }
          // if ((ds as Map<String,dynamic>).containsKey('mobile_Name')) {
          //   mobile_Number = ds.get('mobile_Number').toString();
          // }
          // if ((ds as Map<String,dynamic>).containsKey('home_Address')) {
          //   home_Address = ds.get('current_Address').toString();
          // }
          // if ((ds as Map<String,dynamic>).containsKey('school_Address')) {
          //   school_Address = ds.get('school_Address').toString();
          // }
          // if ((ds as Map<String,dynamic>).containsKey('postal_Code')) {
          //   postal_Code = ds.get('postal_Code').toString();
          // }
          // if ((ds as Map<String,dynamic>).containsKey('profilePic_Url')) {
          //   profilePic = ds.get('profilePic_Url').toString();
          // }

          prabhag_LevelType = ds.get('prabhag_LevelType').toString();
          sambhag_LevelType = ds.get('sambhag_LevelType').toString();
          bhag_LevelType = ds.get('bhag_LevelType').toString();
          anchal_LevelType = ds.get('anchal_LevelType').toString();
          cluster_LevelType = ds.get('cluster_LevelType').toString();
          sanch_LevelType = ds.get('sanch_LevelType').toString();
          upSanch_LevelType = ds.get('upSanch_LevelType').toString();
          village_LevelType = ds.get('village_LevelType').toString();


          // if ((ds as Map<String,dynamic>).containsKey('prabhag_LevelType')) {
          //   prabhag_LevelType = ds.get('prabhag_LevelType').toString();
          // }
          // if ((ds as Map<String,dynamic>).containsKey('sambsambhag_LevelTypehag')) {
          //   sambsambhag_LevelTypehag = ds.get('sambsambhag_LevelTypehag').toString();
          // }
          // if ((ds as Map<String,dynamic>).containsKey('bhag_LevelType')) {
          //   bhag_LevelType = ds.get('bhag_LevelType').toString();
          // }
          // if ((ds as Map<String,dynamic>).containsKey('anchal_LevelType')) {
          //   anchal_LevelType = ds.get('anchal_LevelType').toString();
          // }
          // if ((ds as Map<String,dynamic>).containsKey('cluster_LevelType')) {
          //   cluster_LevelType = ds.get('cluster_LevelType').toString();
          // }
          // if ((ds as Map<String,dynamic>).containsKey('sanch_LevelType')) {
          //   sanch_LevelType = ds.get('sanch_LevelType').toString();
          // }
          // if ((ds as Map<String,dynamic>).containsKey('upSanch_LevelType')) {
          //   upSanch_LevelType = ds.get('upSanch_LevelType').toString();
          // }
          // if ((ds as Map<String,dynamic>).containsKey('village_LevelType')) {
          //   village_LevelType = ds.get('village_LevelType').toString();
          // }

          

          mp["designation_Type"] = designationType;
          mp["designation_RoleType"] = designationRoleType;
          mp["dayitva_Type"] = dayitvaType;

          mp["first_Name"] = firstName;
          mp["last_Name"] = lastName;
          mp["age"] = age;
          mp["gender"] = gender;
          mp["date_Of_Birth"] = dateOfBirth;
          mp["education_Qualification"] = eduQualification;
          mp["mobile_Number"] = mobile_Number;
          mp["home_Address"] = home_Address;
          mp["school_Address"] = school_Address;
          mp["postal_Code"] = postal_Code;
          mp["profilePic_Url"] = profilePic;

          mp["prabhag_LevelType"] = prabhag_LevelType;
          mp["sambhag_LevelType"] = sambhag_LevelType; 
          mp["bhag_LevelType"] = bhag_LevelType; 
          mp["anchal_LevelType"] = anchal_LevelType; 
          mp["cluster_LevelType"] = cluster_LevelType; 
          mp["sanch_LevelType"] = sanch_LevelType; 
          mp["upSanch_LevelType"] = upSanch_LevelType; 
          mp["village_LevelType"] = village_LevelType; 

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
    TextEditingController designationType,
    TextEditingController designationRoleType,
    TextEditingController dayitvaType,

    TextEditingController prabhagDayitva_Name,
    TextEditingController sambhagDayitva_Name,
    TextEditingController bhagDayitva_Name,
    TextEditingController anchalDayitva_Name,
    TextEditingController clusterDayitva_Name,
    TextEditingController sanchDayitva_Name,
    TextEditingController upSanchDayitva_Name,
    TextEditingController villageDayitva_Name,

    TextEditingController userPhoneNumber,
    TextEditingController firstName,
    TextEditingController lastName,
    TextEditingController age,
    DateTime dateOfBirth,
    TextEditingController gender,
    TextEditingController eduQualification,
    TextEditingController homeAddress,
    TextEditingController schoolAddress,
    // TextEditingController state_Name,
    // TextEditingController region_Name,
    // TextEditingController district_Name,
    // TextEditingController anchal_Name,
    // TextEditingController sankul_Name,
    // TextEditingController cluster_Name,
    // TextEditingController subCluster_Name,
    // TextEditingController village_Name,
    TextEditingController postalCode,
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

    final urlLinkForCompleteClassDetails = Uri.https(
      'flutterdatabase-76af4-default-rtdb.firebaseio.com',
      '/CompleteClassDetails/${loggedInUserId}/${DateFormat.yMMMd('en_US').toString()}.json',
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
          'designation_Type': designationType.text.toString(),
          'designation_RoleType': designationRoleType.text.toString(),
          'dayitva_Type': dayitvaType.text.toString(),

          'prabhag_LevelType': prabhagDayitva_Name.text.toString(),
          'sambhag_LevelType': sambhagDayitva_Name.text.toString(),
          'bhag_LevelType': bhagDayitva_Name.text.toString(),
          'anchal_LevelType': anchalDayitva_Name.text.toString(),
          'cluster_LevelType': clusterDayitva_Name.text.toString(),
          'sanch_LevelType': sanchDayitva_Name.text.toString(),
          'upSanch_LevelType': upSanchDayitva_Name.text.toString(),
          'village_LevelType': villageDayitva_Name.text.toString(),

          'first_Name': firstName.text.toString(),
          'last_Name': lastName.text.toString(),
          'age': age.text.toString(),
          'date_Of_Birth': DateFormat('dd/MM/yyyy').format(dateOfBirth).toString(),
          'gender': gender.text.toString(),
          'education_Qualification': eduQualification.text.toString(),
          'home_Address': homeAddress.text.toString(),
          'school_Address': schoolAddress.text.toString(),
          'postal_Code': postalCode.text.toString(),
          'mobile_Number': userPhoneNumber.text.toString(),
          'creation_Timing': DateTime.now().toString(),
          'profilePic_Url': "",
          // 'state': state_Name.text.toString(),
          // 'region': region_Name.text.toString(),
          // 'district': district_Name.text.toString(),
          // 'anchal': anchal_Name.text.toString(),
          // 'sankul': sankul_Name.text.toString(),
          // 'cluster': cluster_Name.text.toString(),
          // 'sub_Cluster': subCluster_Name.text.toString(),
          // 'village': village_Name.text.toString(),
        },
      );

      // Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/tab-screen", (route) => false);
    } else {
      String imageName =
          "${loggedInUserId}_${DateTime.now().toString()}_profilePicture.jpg";

      String dateVal =
          DateFormat.yMMMMd('en_US').format(dateOfBirth).toString();
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
          'designation_Type': designationType.text.toString(),
          'designation_RoleType': designationRoleType.text.toString(),
          'dayitva_Type': dayitvaType.text.toString(),

          'prabhag_LevelType': prabhagDayitva_Name.text.toString(),
          'sambhag_LevelType': sambhagDayitva_Name.text.toString(),
          'bhag_LevelType': bhagDayitva_Name.text.toString(),
          'anchal_LevelType': anchalDayitva_Name.text.toString(),
          'cluster_LevelType': clusterDayitva_Name.text.toString(),
          'sanch_LevelType': sanchDayitva_Name.text.toString(),
          'upSanch_LevelType': upSanchDayitva_Name.text.toString(),
          'village_LevelType': villageDayitva_Name.text.toString(),

          'first_Name': firstName.text.toString(),
          'last_Name': lastName.text.toString(),
          'age': age.text.toString(),
          'date_Of_Birth': DateFormat('dd/MM/yyyy').format(dateOfBirth).toString(),
          'gender': gender.text.toString(),
          'education_Qualification': eduQualification.text.toString(),
          'home_Address': homeAddress.text.toString(),
          'school_Address': schoolAddress.text.toString(),
          'postal_Code': postalCode.text.toString(),
          'mobile_Number': userPhoneNumber.text.toString(),
          'creation_Timing': DateTime.now().toString(),
          'profilePic_Url': classroomImageUrl.toString(),
          // 'state': state_Name.text.toString(),
          // 'region': region_Name.text.toString(),
          // 'district': district_Name.text.toString(),
          // 'anchal': anchal_Name.text.toString(),
          // 'sankul': sankul_Name.text.toString(),
          // 'cluster': cluster_Name.text.toString(),
          // 'sub_Cluster': subCluster_Name.text.toString(),
          // 'village': village_Name.text.toString(),
        },
      );

      // Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/tab-screen", (route) => false);
    }
  }
}
