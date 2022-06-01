import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../providers/user_details.dart';

class MyProfile extends StatefulWidget {
  static const routeName = '/my-profile';
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _gender = TextEditingController();
  TextEditingController _dateOfBirth = TextEditingController();
  TextEditingController _localAddress = TextEditingController();
  TextEditingController _permanentAddress = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _stateName = TextEditingController();
  TextEditingController _districtName = TextEditingController();
  TextEditingController _blockName = TextEditingController();
  TextEditingController _villageGroupName = TextEditingController();
  TextEditingController _villageName = TextEditingController();
  TextEditingController _postalCode = TextEditingController();
  TextEditingController _eduQualification = TextEditingController();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();

  // }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    var userInfoDetails = Provider.of<UserDetails>(context);
    Map<String, String> userMapping =
        userInfoDetails.getUserPersonalInformation();

    bool _isFirstNameSet = false;
    bool _isLastNameSet = false;
    bool _isAgeSet = false;
    bool _isGenderSet = false;
    bool _isDateTimeSet = false;
    bool _isLocalAddressSet = false;
    bool _isPermanentAddressSet = false;
    bool _isPhoneNumberSet = false;
    bool _isStateNameSet = false;
    bool _isDistrictNameSet = false;
    bool _isBlockNameSet = false;
    bool _isVillageGroupNameSet = false;
    bool _isVillageNameSet = false;
    bool _isPostalCodeSet = false;
    bool _isEducationQualificationSet = false;

    _firstName.text = "Getting First Name...";
    _lastName.text = "Getting Last Name...";
    _age.text = "Getting Age...";
    _gender.text = "Getting Gender...";
    _dateOfBirth.text = "Getting Date Of Birth...";
    _localAddress.text = "Getting Local Address...";
    _permanentAddress.text = "Getting Permanent Address...";
    _phoneNumber.text = "Getting Phone Number...";
    _stateName.text = "Getting State...";
    _districtName.text = "Getting District...";
    _blockName.text = "Getting Block...";
    _villageGroupName.text = "Getting Village...";
    _villageName.text = "Getting Village...";
    _postalCode.text = "Getting Postal Code...";
    _eduQualification.text = "Getting Edu Qualification...";

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('userPersonalInformation')
          .snapshots(),
      builder: (ctx, AsyncSnapshot userInfoDetail) {
        if (userInfoDetail.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        } else {
          return ListView(
            children: <Widget>[
              imageContainer(context, userMapping["profilePic_Url"] as String),
              SizedBox(
                height: useableHeight * 0.0025,
              ),
              TextFildContainer(
                context,
                "First Name",
                _firstName,
                'first_Name',
                _isFirstNameSet,
              ),
              TextFildContainer(
                context,
                "Last Name",
                _lastName,
                'last_Name',
                _isLastNameSet,
              ),
              TextFildContainer(
                context,
                "Age",
                _age,
                'age',
                _isAgeSet,
              ),
              TextFildContainer(
                context,
                "Gender",
                _gender,
                'gender',
                _isGenderSet,
              ),
              TextFildContainer(
                context,
                "Date Of Birth",
                _dateOfBirth,
                'date_Of_Birth',
                _isDateTimeSet,
              ),
              TextFildContainer(
                context,
                "Education \nQualification",
                _eduQualification,
                'education_Qualification',
                _isEducationQualificationSet,
              ),
              TextFildContainer(
                context,
                "Phone No",
                _phoneNumber,
                'phone_Number',
                _isPhoneNumberSet,
              ),
              TextFildContainer(
                context,
                "Current \nAddress",
                _localAddress,
                'current_Address',
                _isLocalAddressSet,
              ),
              TextFildContainer(
                context,
                "Permanent \nAddress",
                _permanentAddress,
                'permanent_Address',
                _isPermanentAddressSet,
              ),
              TextFildContainer(
                context,
                "SAMBHAG/\nState",
                _stateName,
                'state',
                _isStateNameSet,
              ),
              TextFildContainer(
                context,
                "BHAG/\nDistrict",
                _districtName,
                'district',
                _isDistrictNameSet,
              ),
              TextFildContainer(
                context,
                "ANCHAL/\nBlock",
                _blockName,
                'block_Level',
                _isBlockNameSet,
              ),
              TextFildContainer(
                context,
                "SANCH/\nVillage Group",
                _villageGroupName,
                'village_Group',
                _isVillageGroupNameSet,
              ),
              TextFildContainer(
                context,
                "Village",
                _villageName,
                'village',
                _isVillageNameSet,
              ),
              TextFildContainer(
                context,
                "Pin Code",
                _postalCode,
                'postal_Code',
                _isPostalCodeSet,
              ),
              SizedBox(
                height: useableHeight * 0.05,
              ),
            ],
          );
        }
      },
    );
  }

  Widget imageContainer(BuildContext context, String imgUrl) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    final defaultImg = 'assets/images/uProfile.png';
    bool isImageAvailable = false;
    if (imgUrl.length > 0) isImageAvailable = true;

    return Container(
      height: useableHeight * 0.3,
      padding: EdgeInsets.symmetric(
        vertical: useableHeight * 0.010,
        horizontal: screenWidth * 0.015,
      ),
      margin: EdgeInsets.symmetric(
        vertical: useableHeight * 0.0025,
      ),
      child: Card(
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade100,
          ),
          padding: EdgeInsets.symmetric(vertical: useableHeight * 0.01),
          alignment: Alignment.center,
          child: CircleAvatar(
            radius: screenWidth * 0.4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(screenWidth * 0.4),
              child: ClipOval(
                child: isImageAvailable
                    ? Image.network(imgUrl)
                    : Image.asset(defaultImg),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget TextFildContainer(
    BuildContext context,
    String titleText,
    TextEditingController textCtr,
    String infoType,
    bool isSet,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    // getUserInformation(context, infoType, textCtr, isSet);
    setUserInfo(context, infoType, textCtr);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.015,
      ),
      child: Card(
        elevation: 3,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.025,
            vertical: useableHeight * 0.015,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "${titleText}: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: screenWidth * 0.001,
              ),
              Flexible(
                child: new Text('${textCtr.text}'),
              ),
              SizedBox(
                width: screenWidth * 0.001,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setUserInfo(
      BuildContext context, String infoType, TextEditingController textCtr) {
    var userInfoDetails = Provider.of<UserDetails>(context);
    Map<String, String> userMapping =
        userInfoDetails.getUserPersonalInformation();

    if (userMapping[infoType] != Null) {
      textCtr.text = userMapping[infoType] as String;
    }
  }
}
