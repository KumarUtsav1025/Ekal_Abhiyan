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

import '../screens/detail_class_screen.dart';

class OldClassView extends StatelessWidget {
  @required
  int indexClass;
  @required
  ClassInformation infoClass;

  OldClassView({
    required this.indexClass,
    required this.infoClass,
  });

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
    if (infoClass.durationOfClass < 60) {
      classDuration = '${infoClass.durationOfClass} min';
    } else {
      hrVal = (infoClass.durationOfClass / 60) as int;
      minVal = infoClass.durationOfClass - hrVal * 60;

      if (minVal == 0) {
        classDuration = '${hrVal} hrs';
      } else {
        classDuration = '${hrVal} hrs ${minVal} min';
      }
    }

    void _goToDetailClassScreen(
        BuildContext ctx, ClassInformation classInfoObj) {
      Navigator.of(ctx).push(
        MaterialPageRoute(
          builder: (_) {
            return ClassDetailScreen(classInfoObj);
          },
        ),
      );
    }

    return InkWell(
      onTap: () {
        _goToDetailClassScreen(context, infoClass);
      },
      splashColor: Theme.of(context).primaryColorDark,

      ////////////
      child: Card(
        elevation: 10,
        margin: EdgeInsets.only(
          top: avlScreenHeight * 0.02,
          bottom: avlScreenHeight * 0.01,
          left: screenWidth * 0.03,
          right: screenWidth * 0.03,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: screenWidth * 0.05,
            right: screenWidth * 0.15,
            top: screenHeight * 0.02,
            bottom: screenHeight * 0.02,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: screenWidth * 0.1,
                child: Container(
                  padding: EdgeInsets.all(
                    screenWidth * 0.01,
                  ),
                  child: FittedBox(
                    child: Icon(
                      Icons.open_in_new_rounded,
                      size: screenWidth * 0.40,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Students: ${infoClass.numOfStudents}'),
                  Text('Duration: ${classDuration}'),
                  Text(
                      'Date: ${DateFormat('dd/MM/yyyy').format(infoClass.currDateTime)}'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
