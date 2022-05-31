import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/class_info.dart';
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

import '../providers/class_details.dart';
import '../providers/user_details.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    var useableHeight = screenHeight - topInsets - bottomInsets;

    var classInfoData = Provider.of<ClassDetails>(context);
    // classInfoData.fetchPreviousClasses();
    // var userInfoDetails = Provider.of<UserDetails>(context);

    int cntClasses = classInfoData.items.length;

    if (cntClasses%2 == 0) {
      cntClasses = (cntClasses/2).floor(); 
    }
    else {
      cntClasses = (cntClasses/2).floor();
      cntClasses += 1;
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              left: screenWidth * 0.01,
              right: screenWidth * 0.01,
              top: useableHeight * 0.0075,
              bottom: useableHeight * 0.0025,
            ),
            child: Card(
              elevation: 1,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.025,
                  vertical: useableHeight * 0.01,
                ),
                child: Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: useableHeight * 0.03,
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Card(
              elevation: 1,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.025,
                  vertical: useableHeight * 0.01,
                ),
                child: Text(
                  "No of Classes Taken = ${cntClasses}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: useableHeight * 0.02,
                  ),
                ),
              ),
            ),
          ),
          // Text(unqId)
        ],
      ),
    );
  }
}
