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

import '../widgets/old_class_view.dart';

class PreviousClass extends StatefulWidget {
  static const routeName = '/previous-class-screen';
  @override
  State<PreviousClass> createState() => _PreviousClassState();
}

class _PreviousClassState extends State<PreviousClass> {
  ClassInformation nullClassInfo = new ClassInformation(
    unqId: "",
    currDateTime: "",
    currTime: "",
    currDate: "",
    numOfStudents: 0,
    currLatitude: 0.0,
    currLongitude: 0.0,
    currAddress: "",
    classroomUrl: "",
    imageFile: File(""),
  );

  var _isInit = true;

  // @override
  //   void initState() {
  //     super.initState();

  //     // Future.delayed(Duration.zero).then((_) {
  //     //   Provider.of<ClassDetails>(context).fetchUserPrevClasses();
  //     // });
  //   }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<ClassDetails>(context).fetchPreviousClasses();
    }
    _isInit = true;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    var classInfoData = Provider.of<ClassDetails>(context);

    return Container(
      child: classInfoData.items.length == 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.25,
                  ),
                  child: Text(
                    'No Classes Taken Yet!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: screenWidth * 0.1,
                    ),
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemCount: classInfoData.items.length,
              itemBuilder: (ctx, index) {
                if (classInfoData.items.length % 2 == 0) {
                  if (index % 2 == 0) {
                    if (index == classInfoData.items.length - 1) {
                      return OldClassView(
                        indexClass1: classInfoData.items.length - 1 - index,
                        indexClass2: -1,
                        infoClass1: classInfoData
                            .items[classInfoData.items.length - 1 - index],
                        infoClass2: nullClassInfo,
                      );
                    } else {
                      return OldClassView(
                        indexClass1: classInfoData.items.length - 2 - index,
                        indexClass2: classInfoData.items.length - 1 - index,
                        infoClass1: classInfoData
                            .items[classInfoData.items.length - 2 - index],
                        infoClass2: classInfoData
                            .items[classInfoData.items.length - 1 - index],
                      );
                    }
                  } else {
                    return SizedBox(
                      height: 0,
                    );
                  }
                } else {
                  if (index == 0) {
                    return OldClassView(
                      indexClass1: classInfoData.items.length - 1 - index,
                      indexClass2: -1,
                      infoClass1: classInfoData
                          .items[classInfoData.items.length - 1 - index],
                      infoClass2: nullClassInfo,
                    );
                  } else if (index % 2 != 0) {
                    if (index == classInfoData.items.length - 1) {
                      return OldClassView(
                        indexClass1: classInfoData.items.length - 1 - index,
                        indexClass2: -1,
                        infoClass1: classInfoData
                            .items[classInfoData.items.length - 1 - index],
                        infoClass2: nullClassInfo,
                      );
                    } else {
                      return OldClassView(
                        indexClass1: classInfoData.items.length - 2 - index,
                        indexClass2: classInfoData.items.length - 1 - index,
                        infoClass1: classInfoData
                            .items[classInfoData.items.length - 2 - index],
                        infoClass2: classInfoData
                            .items[classInfoData.items.length - 1 - index],
                      );
                    }
                  } else {
                    return SizedBox(
                      height: 0,
                    );
                  }
                }
              },
            ),
    );
  }
}
