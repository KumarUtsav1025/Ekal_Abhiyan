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

import './tabs_screen.dart';
import './signup_screen.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login-screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> _userSignIn(BuildContext context, TextEditingController userPhoneNumber) async {
    if (userPhoneNumber.text.length != 10) {
      String titleText = "Invild Mobile Number";
      String contextText = "Please Enter a Valid Number!";
      _checkForError(context, titleText, contextText);
    }
  }

  Future<void> _enterUserOtp(
    BuildContext context,
    String titleText,
    String contextText,
  ) async {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var _otpUserInput = TextEditingController();

    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${titleText}'),
        content: Text('${contextText}'),
        actions: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            margin: EdgeInsets.all(screenWidth * 0.02),
            child: TextField(
              maxLength: 6,
              decoration: InputDecoration(labelText: 'Phone Number: '),
              controller: _otpUserInput,
              keyboardType: TextInputType.number,
              onSubmitted: (_) {},
              onChanged: (newCount) {},
            ),
          ),
          RaisedButton(
            child: Text('Submit'),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _checkForError(
      BuildContext context, String titleText, String contextText,
      {bool popVal = false}) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${titleText}'),
        content: Text('${contextText}'),
        actions: <Widget>[
          RaisedButton(
            child: Text('OK'),
            onPressed: () {
              if (popVal == false) {
                Navigator.of(ctx).pop(false);
              } else {
                Navigator.of(context)
                    .pushReplacementNamed(TabsScreen.routeName);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    var _userPhoneNumber = TextEditingController();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white70,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: screenHeight * 0.15,
                color: Colors.blue.shade200,
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                  horizontal: screenWidth * 0.05,
                ),
                margin: EdgeInsets.only(
                  top: screenHeight * 0.1,
                  left: screenWidth * 0.1,
                  right: screenWidth * 0.1,
                  bottom: screenHeight * 0.05,
                ),
                child: Text(
                  'Shikshak',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.12,
                    decorationStyle: TextDecorationStyle.wavy,
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Container(
                alignment: Alignment.center,
                color: Colors.white70,
                height: screenHeight * 0.4,
                width: screenWidth * 0.9,
                padding: EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.02,
                      ),
                      margin: EdgeInsets.all(screenWidth * 0.02),
                      child: TextField(
                        maxLength: 10,
                        decoration: InputDecoration(labelText: 'Phone Number: '),
                        controller: _userPhoneNumber,
                        keyboardType: TextInputType.number,
                        onChanged: (cngValue) {
                          setState(() {
                            _userPhoneNumber.text = cngValue;
                          });
                        },
                        onSubmitted: (_) {},
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    ButtonTheme(
                      minWidth: screenWidth * 0.5,
                      height: screenHeight * 0.07,
                      child: RaisedButton(
                        child: Text(
                          'Sign-In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenHeight * 0.025,
                          ),
                        ),
                        onPressed: () {
                          _userSignIn(context, _userPhoneNumber);
                        },
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(SignUpScreen.routeName);
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue.shade500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
