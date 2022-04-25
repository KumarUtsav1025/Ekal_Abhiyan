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
import 'package:sqflite/sqflite.dart' as sql;

import './tabs_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup-screen';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isDateSet = false;
  String dateBtnString = "Enter D.O.B";

  var _firstName = TextEditingController();
  var _lastName = TextEditingController();
  var _age = TextEditingController();
  var _gender = TextEditingController();
  late DateTime _dateOfBirth;
  var _localAddress = TextEditingController();
  var _permanentAddress = TextEditingController();
  var _phoneNumber = TextEditingController();
  var _districtName = TextEditingController();
  var _stateName = TextEditingController();
  var _postalCode = TextEditingController();
  var _eduQualification = TextEditingController();

  bool _isFirstNameSet = false;
  bool _islastNameSet = false;
  bool _isAgeSet = false;
  bool _isDateTimeSet = false;
  bool _isLocalAddressSet = false;
  bool _isPermanentAddressSet = false;
  bool _isPhoneNumberSet = false;
  bool _isDistrictNameSet = false;
  bool _isStateNameSet = false;
  bool _isPostalCodeSet = false;
  bool _isEducationQualificationSet = false;

  Future<void> _checkInputFields(BuildContext context) async {
    if (_firstName.text.trim().length == 0) {
      String titleText = "Invalid First Name!";
      String contextText = "Please enter your 'First Name'...";
      _checkForError(context, titleText, contextText);
    } else if (_firstName.text.trim().length <= 3) {
      String titleText = "First Name is too Short";
      String contextText = "'First Name' should have atleast 3 characters.";
      _checkForError(context, titleText, contextText);
    } else if (_lastName.text.trim().length == 0) {
      String titleText = "Invalid Last Name!";
      String contextText = "Please enter your 'Last Name'...";
      _checkForError(context, titleText, contextText);
    } else if (_firstName.text.trim().length <= 3) {
      String titleText = "Last Name is too Short";
      String contextText = "'Last Name' should have atleast 3 characters.";
      _checkForError(context, titleText, contextText);
    } else if (_age.text.trim().length == 0 || int.tryParse(_age.text) == null || int.parse(_age.text) > 10) {
      String titleText = "Invalid Age";
      String contextText = "Please enter your age!";
      _checkForError(context, titleText, contextText);
    } else if (isDateSet == false) {
      String titleText = "Invali Date of Birth(D.O.B)";
      String contextText = "Please enter your Date of Birth(D.O.B)!";
      _checkForError(context, titleText, contextText);
    } else if (_gender.text.trim().length == 0) {
      String titleText = "Invalid Gender";
      String contextText = "Please Enter your Gender/Sex!";
      _checkForError(context, titleText, contextText);
    } else if (_eduQualification.text.trim().length <= 5) {
      String titleText = "Invalid Education Qualification";
      String contextText = "Define in atleast 5 characters";
      _checkForError(context, titleText, contextText);
    } else if (_localAddress.text.trim().length <= 10) {
      String titleText = "Invalid Address";
      String contextText = "Please enter your complete address";
      _checkForError(context, titleText, contextText);
    } else if (_permanentAddress.text.trim().length == 0) {
      String titleText = "Invalid Address";
      String contextText = "Please enter your complete address";
      _checkForError(context, titleText, contextText);
    } else if (_districtName.text.trim().length < 2) {
      String titleText = "Invalid District Name";
      String contextText = "Please enter your District";
      _checkForError(context, titleText, contextText);
    } else if (_stateName.text.trim().length < 2) {
      String titleText = "Invalid State Name";
      String contextText = "Please enter your State";
      _checkForError(context, titleText, contextText);
    } else if (_postalCode.text.trim().length != 6 ||
        int.tryParse(_postalCode.text) == null ||
        int.parse(_postalCode.text) < 0) {
      String titleText = "Invalid Pincode";
      String contextText = "Please enter a valid Pin Code!";
      _checkForError(context, titleText, contextText);
    } else if (_postalCode.text.trim().length != 6) {
      String titleText = "Invalid Pincode";
      String contextText = "Please enter a valid Pin Code!";
      _checkForError(context, titleText, contextText);
    } else if (_phoneNumber.text.length != 10) {
      String titleText = "Invild Mobile Number";
      String contextText = "Please Enter a Valid 10 Digit Number!";
      _checkForError(context, titleText, contextText);
    } else if (int.tryParse(_phoneNumber.text) == null) {
      String titleText = "Invild Mobile Number";
      String contextText = "Entered Number is Not Valid!";
      _checkForError(context, titleText, contextText);
    } else if (int.parse(_phoneNumber.text) < 0) {
      String titleText = "Invild Mobile Number";
      String contextText = "Mobile Number Cannot be Negative!";
      _checkForError(context, titleText, contextText);
    }
    else {

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

  void _presentDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      initialDate: DateTime(2002),
      lastDate: DateTime(2005),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          isDateSet = true;
          _dateOfBirth = pickedDate;
          dateBtnString = "Change D.O.B";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: screenHeight * 0.01),
            // First Name
            TextFieldContainer(
                context, "First Name", 30, _firstName, TextInputType.name),
            SizedBox(height: screenHeight * 0.005),
            // Last Name
            TextFieldContainer(
                context, "Last Name", 30, _lastName, TextInputType.name),
            SizedBox(height: screenHeight * 0.005),
            // Age
            TextFieldContainer(context, "Age", 2, _age, TextInputType.number),
            SizedBox(height: screenHeight * 0.005),
            // Date Of Birth
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100,
              ),
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.008,
                horizontal: screenWidth * 0.03,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      isDateSet == false
                          ? 'Select D.0.B -> '
                          : 'Your D.O.B: ${DateFormat('dd/MM/yyyy').format(_dateOfBirth)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FlatButton(
                    color: Colors.grey.shade400,
                    textColor: Colors.black,
                    child: Text(
                      '${dateBtnString}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _presentDatePicker(context);
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            // Gender
            TextFieldContainer(
                context, "Gender", 20, _gender, TextInputType.name),
            SizedBox(height: screenHeight * 0.005),
            // Education Qualification:
            TextFieldContainer(context, "Education Qualification", 80,
                _eduQualification, TextInputType.name),
            SizedBox(height: screenHeight * 0.005),
            // Current Address
            TextFieldContainer(context, "Current Address", 100, _localAddress,
                TextInputType.name),
            SizedBox(height: screenHeight * 0.005),
            // Permanent Address
            TextFieldContainer(context, "Permanent Address", 100,
                _permanentAddress, TextInputType.name),
            SizedBox(height: screenHeight * 0.005),
            // District Name:
            TextFieldContainer(
              context,
              "District",
              50,
              _districtName,
              TextInputType.name,
            ),
            SizedBox(height: screenHeight * 0.005),
            // State Name:
            TextFieldContainer(
              context,
              "State",
              50,
              _stateName,
              TextInputType.name,
            ),
            SizedBox(height: screenHeight * 0.005),
            // Postal Code:
            TextFieldContainer(context, "Postal/Pin - Code", 6, _postalCode,
                TextInputType.number),
            SizedBox(height: screenHeight * 0.005),
            // Phone Number:
            TextFieldContainer(context, "Phone Number: ", 10, _phoneNumber,
                TextInputType.number),
            SizedBox(height: screenHeight * 0.04),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: screenWidth * 0.95,
                  height: screenHeight * 0.08,
                  margin: EdgeInsets.only(
                    left: screenWidth * 0.02,
                    right: screenWidth * 0.02,
                    bottom: screenHeight * 0.008,
                  ),
                  child: RaisedButton(
                    color: Colors.amber.shade500,
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      _checkInputFields(context);
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget TextFieldContainer(BuildContext context, String textLabel, int maxLgt,
      TextEditingController _textCtr, TextInputType keyBoardType) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.008,
        horizontal: screenWidth * 0.03,
      ),
      child: TextField(
        maxLength: maxLgt,
        decoration: InputDecoration(labelText: '${textLabel}: '),
        controller: _textCtr,
        keyboardType: keyBoardType,
        onSubmitted: (_) {},
      ),
    );
  }
}
