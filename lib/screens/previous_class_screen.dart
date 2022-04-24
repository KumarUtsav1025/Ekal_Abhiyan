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

import '../providers/class_details.dart';

import '../widgets/old_class_view.dart';

class PreviousClass extends StatefulWidget {
  static const routeName = '/previous-class-screen';
  @override
  State<PreviousClass> createState() => _PreviousClassState();
}

class _PreviousClassState extends State<PreviousClass> {

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var _isInit = true;

    var classInfoData = Provider.of<ClassDetails>(context);

    @override
    void initState() {
      super.initState();

      // Future.delayed(Duration.zero).then((_) {
      //   Provider.of<ClassDetails>(context).fetchUserPrevClasses();
      // });
    }

    @override
    void didChangeDependencies() {
      if (_isInit) {
        Provider.of<ClassDetails>(context).fetchUserPrevClasses();
      }
      _isInit = true;

      super.didChangeDependencies();
    }

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
                return OldClassView(
                  indexClass: classInfoData.items.length-1-index,
                  infoClass: classInfoData.items[index],
                );
              },
            ),
    );
  }
}
