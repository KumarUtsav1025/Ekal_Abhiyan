import 'dart:async';
// import 'dart:ffi';
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
import 'package:charts_flutter/flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/pathConst.dart';
import '../constants/stringConst.dart';
import '../providers/class_details.dart';
import '../providers/user_details.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _isInit = false;
  String userName = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!_isInit) {
      Provider.of<ClassDetails>(context, listen: false).fetchPreviousClasses();
    }
    _isInit = true;

    Provider.of<UserDetails>(context, listen: false).setUserInfo();
  }

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
    // userInfoDetails.setUserInformation();

    int cntClasses = classInfoData.items.length;

    if (cntClasses % 2 == 0) {
      cntClasses = (cntClasses / 2).floor();
    } else {
      cntClasses = (cntClasses / 2).floor();
      cntClasses += 1;
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        margin: EdgeInsets.only(
          left: screenWidth * 0.0125,
          right: screenWidth * 0.0125,
          top: screenHeight * 0.00625,
          bottom: screenHeight * 0.025,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 10,
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  left: screenWidth * 0.01,
                  right: screenWidth * 0.01,
                  top: useableHeight * 0.0075,
                  bottom: useableHeight * 0.0025,
                ),
                child: Card(
                  elevation: 15,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.025,
                      vertical: useableHeight * 0.01,
                    ),
                    child: Text(S.introHead,
                        textAlign: TextAlign.center),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Card(
                  elevation: 20,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.025,
                      vertical: useableHeight * 0.01,
                    ),
                    child: Image.asset(P.ekalVidyalayaImage),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight*0.01,
              ),
              Container(
                child: Card(
                  elevation: 15,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.025,
                      vertical: useableHeight * 0.01,
                    ),
                    child: Text(S.introSubHead,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.00125),
              Container(
                child: Card(
                  elevation: 15,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.025,
                      vertical: useableHeight * 0.005,
                    ),
                    child: Text(
                      "${S.countHead} ${cntClasses}",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
