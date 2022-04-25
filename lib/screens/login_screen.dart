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

import './tabs_screen.dart';
import './signup_screen.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login-screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isOtpSent = false;
  bool _isAuthenticationAccepted = false;
  String _verificationId = "";
  TextEditingController _userPhoneNumber = TextEditingController();
  TextEditingController _userOtpValue = TextEditingController();
  TextEditingController _otpValue = TextEditingController();

  Future<void> _userSignIn(
    BuildContext context,
    TextEditingController userPhoneNumber,
  ) async {
    if (userPhoneNumber.text.length != 10) {
      String titleText = "Invild Mobile Number";
      String contextText = "Please Enter a Valid 10 Digit Number!";
      _checkForError(context, titleText, contextText);
    } else if (int.tryParse(userPhoneNumber.text) == null) {
      String titleText = "Invild Mobile Number";
      String contextText = "Entered Number is Not Valid!";
      _checkForError(context, titleText, contextText);
    } else if (int.parse(userPhoneNumber.text) < 0) {
      String titleText = "Invild Mobile Number";
      String contextText = "Mobile Number Cannot be Negative!";
      _checkForError(context, titleText, contextText);
    } else {
      String titleText = "Authentication";
      String contextText = "Enter the Otp:";

      _enterUserOtp(context, titleText, contextText);
      _checkForAuthentication(context, _userPhoneNumber);
    }
  }

  // Future<void> _otpVerification(BuildContext context)

  Future<void> _enterUserOtp(
    BuildContext context,
    String titleText,
    String contextText,
  ) async {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${titleText}'),
        content: Text('${contextText}'),
        actions: <Widget>[
          Container(
            height: screenHeight * 0.2,
            width: screenWidth * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            margin: EdgeInsets.all(screenWidth * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  maxLength: 6,
                  decoration: InputDecoration(labelText: 'Enter the OTP: '),
                  controller: _userOtpValue,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) {},
                ),
              ],
            ),
          ),
          RaisedButton(
            child: Text('Submit'),
            onPressed: () {
              AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
                verificationId: this._verificationId,
                smsCode: _otpValue.text,
              );
              signInWithPhoneAuthCred(context, phoneAuthCredential);
              // Navigator.of(context).pushNamed(TabsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _checkForAuthentication(
    BuildContext context,
    TextEditingController phoneController,
  ) async {

    var funcAuth = await _auth.verifyPhoneNumber (
      phoneNumber: "+91${phoneController.text}",

      // After the Authentication has been Completed Successfully
      verificationCompleted: (phoneAuthCredential) async {
        setState(() {
          _isAuthenticationAccepted = true;
          print('auth successful');
        });
      },

      // After the Authentication has been Failed/Declined
      verificationFailed: (verificationFailed) {
        setState(() {
          _isOtpSent = false;
          _isAuthenticationAccepted = false;
        });
        print('verification failed');
        print(verificationFailed);
        String titleText = "Authenticatoin Failed!";
        String contextText = "Entered Otp is Invalid.";
        _checkForError(context, titleText, contextText);
      },

      // After the OTP has been sent to Mobile Number Successfully
      codeSent: (verificationID, resendingToken) async {
        print('otp sent');
        setState(() {
          _isOtpSent = true;
          _isAuthenticationAccepted = false;

          this._verificationId = verificationID;
          print(this._verificationId);
        });
      },

      // After the Otp Timeout period
      codeAutoRetrievalTimeout: (verificationID) async {
        setState(() {
          _isOtpSent = false;
          _isAuthenticationAccepted = false;
        });
        String titleText = "Authenticatoin Timeout!";
        String contextText = "Please Re-Try Again";
        _checkForError(context, titleText, contextText);
        Navigator.of(context).pushNamed(TabsScreen.routeName);
      },
    );
  }


  Future<void> signInWithPhoneAuthCred(
      BuildContext context, AuthCredential phoneAuthCredential) async {
    try {
      final authCred = await _auth.signInWithCredential(phoneAuthCredential);

      if (authCred.user != null) {
        print('authentication complete!');
      }
    } on FirebaseAuthException catch (errorVal) {
      String titleText = "Authentication has been Failed!";
      String contextText = "Otp is InValid!";
      _checkForError(context, titleText, contextText);
    }
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
                        decoration:
                            InputDecoration(labelText: 'Phone Number: '),
                        controller: _userPhoneNumber,
                        keyboardType: TextInputType.number,
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
