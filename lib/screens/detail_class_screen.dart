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

  final ClassInformation detailInfoClass;
  ClassDetailScreen(this.detailInfoClass);

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var avlScreenHeight = screenHeight - topInsets - bottomInsets;

    String classDuration = "";
    int minVal = 0;
    int hrVal = 0;
    if (detailInfoClass.durationOfClass < 60) {
      classDuration = '${detailInfoClass.durationOfClass} min';
    } else {
      hrVal = (detailInfoClass.durationOfClass / 60) as int;
      minVal = detailInfoClass.durationOfClass - hrVal * 60;

      if (minVal == 0) {
        classDuration = '${hrVal} hrs';
      } else {
        classDuration = '${hrVal} hrs ${minVal} min';
      }
    }



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
              Text('Date: ${DateFormat.yMMMEd().format(detailInfoClass.currDateTime)}'),
              Text('Time: ${DateFormat('hh:mma').format(detailInfoClass.currDateTime)}'),
              Text('Number of Students: ${detailInfoClass.numOfStudents}'),
              Text('Duration: ${classDuration}'),
              Text('Address: ${detailInfoClass.imgLocEnd.location.address}'),
              Text('Beginning of the Class:'),
              Image.file(detailInfoClass.imgLocStart.image),
              Text('Ending of the Class:'),
              Image.file(detailInfoClass.imgLocEnd.image),
            ],
          ),
        ),
      ),
    );
  }
}
