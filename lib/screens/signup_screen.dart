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

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup-screen';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    bool isDateSet = false;
    String dateBtnString = "Enter D.O.B";

    var _firstName = TextEditingController();
    var _lastName = TextEditingController();
    var _age = TextEditingController();
    late DateTime _dateOfBirth;
    var _localAddress = TextEditingController();
    var _permanentAddress = TextEditingController();
    var _phoneNumber = TextEditingController();
    var _districtName = TextEditingController();
    var _stateName = TextEditingController();
    var _postalCode = TextEditingController();
    var _eduQualification = TextEditingController();

    void _presentDatePicker(BuildContext context) {
      showDatePicker(
        context: context,
        initialDate: DateTime(2008),
        firstDate: DateTime(1950),
        lastDate: DateTime(2010),
      ).then((pickedDate) {
        if (pickedDate == null) {
          return;
        } else {
          setState(() {
            isDateSet = true;
            _dateOfBirth = pickedDate;
            dateBtnString = "Change D.O.B";
            print(_dateOfBirth);
          });
        }
      });
    }

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
            // Education Qualification:
            TextFieldContainer(context, "Education Qualification", 80,
                _eduQualification, TextInputType.name),
            SizedBox(height: screenHeight * 0.005),
            // Gender
            TextFieldContainer(context, "Gender", 20, _age, TextInputType.name),
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
                    onPressed: () {},
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
