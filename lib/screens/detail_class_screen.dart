import 'dart:async';
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

import '../models/class_info.dart';
import '../models/http_exeception.dart';
import '../models/place.dart';

import '../providers/class_details.dart';

class ClassDetailScreen extends StatelessWidget {
  static const routeName = '/class-detail-screen';

  final ClassInformation detailInfoClass1;
  final ClassInformation detailInfoClass2;
  ClassDetailScreen({
    required this.detailInfoClass1,
    required this.detailInfoClass2,
  });

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var avlScreenHeight = screenHeight - topInsets - bottomInsets;

    bool _isCompleteInfo = false;
    if (detailInfoClass2.unqId.length != 0) {
      _isCompleteInfo = true;
    }

    String classDuration = "";
    int minVal = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Class Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.005,
            horizontal: screenWidth * 0.01,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              !_isCompleteInfo
                  ? partialInfoWidget(
                      context,
                      detailInfoClass1,
                    )
                  : completeInfoWidget(
                      context,
                      detailInfoClass1,
                      detailInfoClass2,
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget partialInfoWidget(BuildContext ctx, ClassInformation classInfo1) {
    var screenHeight = MediaQuery.of(ctx).size.height;
    var screenWidth = MediaQuery.of(ctx).size.width;
    var topInsets = MediaQuery.of(ctx).viewInsets.top;
    var bottomInsets = MediaQuery.of(ctx).viewInsets.bottom;
    var usableHeight = screenHeight - topInsets - bottomInsets;

    return Card(
      elevation: 2,
      child: Container(
        height: usableHeight * 0.9,
        width: screenWidth * 0.95,
        child: Column(
          children: <Widget>[
            Text(
              "Starting of the Class",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: usableHeight * 0.0025,
            ),
            Container(
              alignment: Alignment.center,
              width: screenWidth * 0.9,
              height: usableHeight * 0.45,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              child: Image.network(
                classInfo1.classroomUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              // Image.file(
              //   classInfo1.imageFile,
              //   fit: BoxFit.cover,
              //   width: double.infinity,
              // ),
            ),
            SizedBox(
              height: usableHeight * 0.01,
            ),
            Text(
              "Date: ${classInfo1.currDate}",
            ),
            SizedBox(
              height: usableHeight * 0.002,
            ),
            Text(
              "Time: ${classInfo1.currTime}",
            ),
            SizedBox(
              height: usableHeight * 0.002,
            ),
            Text(
              "Number Of Students: ${classInfo1.numOfStudents}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: usableHeight * 0.002,
            ),
            Text(
              "Address: \n${classInfo1.currAddress}",
            ),
          ],
        ),
      ),
    );
  }

  Widget completeInfoWidget(
    BuildContext ctx,
    ClassInformation classInfo1,
    ClassInformation classInfo2,
  ) {
    var screenHeight = MediaQuery.of(ctx).size.height;
    var screenWidth = MediaQuery.of(ctx).size.width;
    var topInsets = MediaQuery.of(ctx).viewInsets.top;
    var bottomInsets = MediaQuery.of(ctx).viewInsets.bottom;
    var usableHeight = screenHeight - topInsets - bottomInsets;

    DateTime t1 = DateTime.parse(classInfo1.currDateTime);
    DateTime t2 = DateTime.parse(classInfo2.currDateTime);

    final diff_dy = t2.difference(t1).inDays;
    final diff_hr = t2.difference(t1).inHours;
    final diff_mn = t2.difference(t1).inMinutes;

    String classDuration = "";
    if (diff_hr == 0) {
      classDuration = "${diff_mn} min";
    } else if (diff_mn == 0) {
      classDuration = "${diff_hr} hr";
    } else {
      classDuration = "${diff_hr} hr ${diff_mn} min";
    }

    return Card(
      elevation: 2,
      child: Container(
        height: usableHeight * 1.7,
        width: screenWidth * 0.95,
        child: Column(
          children: <Widget>[
            Text(
              "Starting of the Class",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: usableHeight * 0.0025,
            ),
            Container(
              alignment: Alignment.center,
              width: screenWidth * 0.9,
              height: usableHeight * 0.45,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              child: Image.network(
                classInfo1.classroomUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              // Image.file(
              //   classInfo1.imageFile,
              //   fit: BoxFit.cover,
              //   width: double.infinity,
              // ),
            ),
            SizedBox(
              height: usableHeight * 0.01,
            ),
            Text(
              "Date: ${classInfo1.currDate}",
            ),
            SizedBox(
              height: usableHeight * 0.002,
            ),
            Text(
              "Time: ${classInfo1.currTime}",
            ),
            SizedBox(
              height: usableHeight * 0.002,
            ),
            Text(
              "Number Of Students: ${classInfo1.numOfStudents}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: usableHeight * 0.05,
            ),
            Text(
              "Ending of the Class",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: usableHeight * 0.0025,
            ),
            Container(
              alignment: Alignment.center,
              width: screenWidth * 0.9,
              height: usableHeight * 0.45,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              child: Image.network(
                classInfo2.classroomUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              // Image.file(
              //   classInfo2.imageFile,
              //   fit: BoxFit.cover,
              //   width: double.infinity,
              // ),
            ),
            SizedBox(
              height: usableHeight * 0.01,
            ),
            Text(
              "Date: ${classInfo1.currDate}",
            ),
            SizedBox(
              height: usableHeight * 0.002,
            ),
            Text(
              "Time: ${classInfo1.currTime}",
            ),
            SizedBox(
              height: usableHeight * 0.002,
            ),
            Text(
              "Number Of Students: ${classInfo2.numOfStudents}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: usableHeight * 0.02,
            ),
            Text(
              "Address: \n${classInfo1.currAddress}",
            ),
            SizedBox(
              height: usableHeight * 0.01,
            ),
            Text(
              "Duration: ${classDuration}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: usableHeight * 0.01,
            ),
          ],
        ),
      ),
    );
  }
}
