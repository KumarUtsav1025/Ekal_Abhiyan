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
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import './tabs_screen.dart';

import '../providers/class_details.dart';
import '../providers/user_details.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup-screen';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isOtpSent = false;
  bool _isAuthenticationAccepted = false;
  bool _showLoading = false;
  bool _userVerified = false;
  bool _isSubmitClicked = false;

  String _verificationId = "";
  TextEditingController _userPhoneNumber = TextEditingController();
  TextEditingController _userOtpValue = TextEditingController();
  TextEditingController _otpValue = TextEditingController();

  bool isDateSet = false;
  String dateBtnString = "Enter D.O.B/";

  File _profilePicture = new File("");
  var _firstName = TextEditingController();
  var _lastName = TextEditingController();
  var _age = TextEditingController();
  var _gender = TextEditingController();
  late DateTime _dateOfBirth = DateTime.now();
  var _localAddress = TextEditingController();
  var _permanentAddress = TextEditingController();
  var _state_SAMBHAG_Name = TextEditingController();
  var _district_BHAG_Name = TextEditingController();
  var _block_ANCHAL_Name = TextEditingController();
  var _groupVillage_SANCH_Name = TextEditingController();
  var _village_Village_Name = TextEditingController();

  var _postalCode = TextEditingController();
  var _eduQualification = TextEditingController();

  bool _isProfilePicTaken = false;
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

  final genderSelectionList = ["Male/पुरुष", "Female/नारी", "Others/अन्य लिंग"];
  List<dynamic> states_SAMBHAG_SelectionList = [
    {"id": 1, "stateName": "Andhra Pradesh"},
    {"id": 2, "stateName": "Arunachal Pradesh"},
    {"id": 3, "stateName": "Assam"},
    {"id": 4, "stateName": "Bihar"},
    {"id": 5, "stateName": "Chhattisgarh"},
    {"id": 6, "stateName": "Goa"},
    {"id": 7, "stateName": "Gujarat"},
    {"id": 8, "stateName": "Haryana"},
    {"id": 9, "stateName": "Himachal Pradesh"},
    {"id": 10, "stateName": "Jammu and Kashmir"},
    {"id": 11, "stateName": "Jharkhand"},
    {"id": 12, "stateName": "Karnataka"},
    {"id": 13, "stateName": "Kerala"},
    {"id": 14, "stateName": "Madhya Pradesh"},
    {"id": 15, "stateName": "Maharashtra"},
    {"id": 16, "stateName": "Manipur"},
    {"id": 17, "stateName": "Meghalaya"},
    {"id": 18, "stateName": "Mizoram"},
    {"id": 19, "stateName": "Nagaland"},
    {"id": 20, "stateName": "Odisha"},
    {"id": 21, "stateName": "Punjab"},
    {"id": 22, "stateName": "Rajasthan"},
    {"id": 23, "stateName": "Sikkim"},
    {"id": 24, "stateName": "Tamil Nadu"},
    {"id": 25, "stateName": "Telangana"},
    {"id": 26, "stateName": "Tripura"},
    {"id": 27, "stateName": "Uttar Pradesh"},
    {"id": 28, "stateName": "Uttarakhand"},
    {"id": 29, "stateName": "West Bengal"},
    {"id": 30, "stateName": "Union Territory"},
  ];

  List<dynamic> district_BHAG_SelectionList = [
    {"id": 1, "districtName": "Ambikapur", "parentStateID": 5}
  ];

  List<dynamic> block_ANCHAL_SelectionList = [
    {"id": 1, "blockName": "Ambikapur", "parentDistrictID": 1}
  ];

  List<dynamic> groupVillage_SANCH_SelectionList = [
    {"id": 1, "groupVillageName": "Darima", "parentBlockID": 1}
  ];

  List<dynamic> village_VILLAGE_SelectionList = [
    {"id": 1, "villageName": "Damali", "parentGroupVillageID": 1}
  ];

  Future<void> _checkInputFields(BuildContext context) async {
    if (_eduQualification.text.trim().length == 0) {
      _eduQualification.text = "No Data Available/कोई डेटा मौजूद नहीं";
    }
    if (_postalCode.text.trim().length == 0) {
      _postalCode.text = "No Data Available/कोई डेटा मौजूद नहीं";
    }
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
    } else if (isDateSet == false) {
      String titleText = "Invali Date of Birth(D.O.B)";
      String contextText = "Please enter your Date of Birth(D.O.B)!";
      _checkForError(context, titleText, contextText);
    } else if (_gender.text.trim().length == 0) {
      String titleText = "Invalid Gender";
      String contextText = "Please Enter your Gender/Sex!";
      _checkForError(context, titleText, contextText);
    } else if (_localAddress.text.trim().length <= 3) {
      String titleText = "Invalid Address";
      String contextText = "Please enter your complete address";
      _checkForError(context, titleText, contextText);
    } else if (_permanentAddress.text.trim().length == 3) {
      String titleText = "Invalid Address";
      String contextText = "Please enter your complete address";
      _checkForError(context, titleText, contextText);
    } else if (_state_SAMBHAG_Name.text.trim().length < 2) {
      String titleText = "Invalid State Name";
      String contextText = "Please enter your State/Sambhag";
      _checkForError(context, titleText, contextText);
    } else if (_district_BHAG_Name.text.trim().length < 2) {
      String titleText = "Invalid District Name";
      String contextText = "Please enter your District/Bhag";
      _checkForError(context, titleText, contextText);
    } else if (_block_ANCHAL_Name.text.trim().length < 2) {
      String titleText = "Invalid Block Name";
      String contextText = "Please enter your Block/Anchal";
      _checkForError(context, titleText, contextText);
    } else if (_groupVillage_SANCH_Name.text.trim().length < 2) {
      String titleText = "Invalid Group Village Name";
      String contextText = "Please enter your Group Village/Sanch";
      _checkForError(context, titleText, contextText);
    } else if (_village_Village_Name.text.trim().length < 2) {
      String titleText = "Invalid Village Name";
      String contextText = "Please enter your Village";
      _checkForError(context, titleText, contextText);
    } else if (_userPhoneNumber.text.length != 10) {
      String titleText = "Invild Mobile Number";
      String contextText = "Please Enter a Valid 10 Digit Number!";
      _checkForError(context, titleText, contextText);
    } else if (int.tryParse(_userPhoneNumber.text) == null) {
      String titleText = "Invild Mobile Number";
      String contextText = "Entered Number is Not Valid!";
      _checkForError(context, titleText, contextText);
    } else if (int.parse(_userPhoneNumber.text) < 0) {
      String titleText = "Invild Mobile Number";
      String contextText = "Mobile Number Cannot be Negative!";
      _checkForError(context, titleText, contextText);
    } else {
      String titleText = "Authentication";
      String contextText = "Enter the Otp:";

      setState(() {
        _isSubmitClicked = true;
        _showLoading = true;
      });

      // _enterUserOtp(context, titleText, contextText);
      _scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text("Verifiying your Number..."),
        ),
      );
      _checkForAuthentication(context, _userPhoneNumber);
    }
  }

  Future<void> openOtpSubmittingWidget() async {
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Text("Otp Sent to your Number..."),
      ),
    );
    String titleText = "Authentication";
    String contextText = "Enter the Otp:";
    _enterUserOtp(context, titleText, contextText);
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
        DateTime t1 = _dateOfBirth;
        DateTime t2 = DateTime.now();
        final diff_dy = t2.difference(t1).inDays;
        String ageVal = (diff_dy / 365).floor().toString();

        setState(() {
          isDateSet = true;
          _dateOfBirth = pickedDate;
          dateBtnString = "Change D.O.B";
          _age.text = ageVal;
        });
      }
    });
  }

  Future<void> createUserInformationInDatabase(
    BuildContext context,
    UserCredential authCredential,
  ) async {
    // AuthResult _authResult = await _auth.
    // FirebaseFirestore.instance.collection('userInformation').document();

    await FirebaseFirestore.instance
        .collection('userPersonalInformation')
        .doc(authCredential.user?.uid)
        .set({
      'first_Name': _firstName.text.toString(),
      'last_Name': _lastName.text.toString(),
      'age': _age.text.toString(),
      'date_Of_Birth': DateFormat('dd/MM/yyyy').format(_dateOfBirth).toString(),
      'gender': _gender.text.toString(),
      'education_Qualification': _eduQualification.text.toString(),
      'current_Address': _localAddress.text.toString(),
      'permanent_Address': _permanentAddress.text.toString(),
      'state': _state_SAMBHAG_Name.text.toString(),
      'district': _district_BHAG_Name.text.toString(),
      'postal_Code': _postalCode.text.toString(),
      'phone_Number': _userPhoneNumber.text.toString(),
    });

    _scaffoldKey.currentState
        ?.showSnackBar(SnackBar(content: Text("Creating your Account")));
    Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text(
          'Sign Up / साइन अप करें',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: screenHeight * 0.01),
            imageContainer(
              context,
            ),
            SizedBox(height: screenHeight * 0.01),
            // Mobile Number
            TextFieldContainer(
              context,
              "Mobile Number/मोबाइल नंबर *",
              10,
              _userPhoneNumber,
              TextInputType.number,
            ),
            SizedBox(height: screenHeight * 0.005),
            // First Name
            TextFieldContainer(
              context,
              "First Name/पहला नाम *",
              30,
              _firstName,
              TextInputType.name,
            ),
            SizedBox(height: screenHeight * 0.005),
            // Last Name
            TextFieldContainer(
              context,
              "Last Name/उपनाम *",
              30,
              _lastName,
              TextInputType.name,
            ),
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
                          ? 'Date Of Birth  \nजन्म की तारीख *-> '
                          : 'D.O.B/जन्म की तारीख: ${DateFormat('dd/MM/yyyy').format(_dateOfBirth)}',
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
            dropDownMenu(
              context,
              genderSelectionList,
              _gender,
              "Gender/लिंग *",
            ),
            SizedBox(height: screenHeight * 0.005),
            // Education Qualification:
            TextFieldContainer(
              context,
              "Education Qfy/शैक्षणिक योग्यता",
              80,
              _eduQualification,
              TextInputType.name,
            ),
            SizedBox(height: screenHeight * 0.005),
            // Current Address
            TextFieldContainer(
              context,
              "Home Address/शिक्षक के घर का पता *",
              100,
              _localAddress,
              TextInputType.name,
            ),
            SizedBox(height: screenHeight * 0.005),
            // Permanent Address
            TextFieldContainer(
              context,
              "School Address/स्कूल का पता *",
              100,
              _permanentAddress,
              TextInputType.name,
            ),
            SizedBox(height: screenHeight * 0.005),
            customDropDownMenu(
              context,
              states_SAMBHAG_SelectionList,
              _state_SAMBHAG_Name,
              "--Select State/राज्य चुनें--",
              "",
              "your State: ",
              "id",
              "stateName",
              "State/सम्भाग *",
            ),
            SizedBox(height: screenHeight * 0.005),
            // District Name:
            TextFieldContainer(
              context,
              "District/भाग *",
              50,
              _district_BHAG_Name,
              TextInputType.name,
            ),
            SizedBox(height: screenHeight * 0.005),
            // Block Level Name:
            TextFieldContainer(
              context,
              "Block/आँचल *",
              50,
              _block_ANCHAL_Name,
              TextInputType.name,
            ),
            SizedBox(height: screenHeight * 0.005),
            // Group Village Name:
            TextFieldContainer(
              context,
              "Village Group/साँच *",
              50,
              _groupVillage_SANCH_Name,
              TextInputType.name,
            ),
            SizedBox(height: screenHeight * 0.005),
            // Village Name:
            TextFieldContainer(
              context,
              "Village/गांव *",
              50,
              _village_Village_Name,
              TextInputType.name,
            ),
            SizedBox(height: screenHeight * 0.005),
            // Postal Code:
            TextFieldContainer(
              context,
              "Pin Code/पिन कोड ",
              6,
              _postalCode,
              TextInputType.number,
            ),
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
                    child: !_isSubmitClicked
                        ? Text(
                            'Submit/जमा करे',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : CircularProgressIndicator(),
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

  Widget TextFieldContainer(
    BuildContext context,
    String textLabel,
    int maxLgt,
    TextEditingController _textCtr,
    TextInputType keyBoardType,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

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
        decoration: InputDecoration(
            labelText: '${textLabel}: ',
            hintStyle: TextStyle(fontWeight: FontWeight.bold)),
        controller: _textCtr,
        keyboardType: keyBoardType,
        onSubmitted: (_) {},
      ),
    );
  }

  Widget dropDownMenu(
    BuildContext context,
    List<String> dropDownList,
    TextEditingController _textCtr,
    String hintText,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.009,
        horizontal: screenWidth * 0.03,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Align(
            alignment: Alignment.centerLeft,
            child: _textCtr.text.length == 0
                ? Text("${hintText}")
                : Text(
                    "${_textCtr.text}",
                    style: TextStyle(color: Colors.black),
                  ),
          ),
          isDense: true,
          iconSize: 35,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
          ),
          isExpanded: true,
          items: dropDownList.map(buildMenuItem).toList(),
          onChanged: (value) => setState(() {
            _textCtr.text = value!;
          }),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
      );

  Widget customDropDownMenu(
    BuildContext context,
    List<dynamic> dropDownList,
    TextEditingController _textCtr,
    String hintText,
    String inputValue,
    String selectionInfo,
    String optValue,
    String optLabel,
    String labelName,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

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
      child: Column(
        children: <Widget>[
          FormHelper.dropDownWidgetWithLabel(
            context,
            labelName,
            hintText,
            inputValue,
            dropDownList,
            (onChangedVal) {
              inputValue = onChangedVal;
              setState(() {
                int idx = int.parse(onChangedVal);
                _textCtr.text = dropDownList[idx - 1][optLabel];
              });
            },
            (onValidateVal) {
              if (onValidateVal == null) {
                return "Select ${selectionInfo}";
              }
              return null;
            },
            borderColor: Colors.grey.shade100,
            optionValue: "${optValue}",
            optionLabel: "${optLabel}",
          ),
        ],
      ),
    );
  }

  ///////////// Authentication Part ////////////////

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
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.5),
            ),
            color: Colors.blue.shade400,
            child: Text('Submit Otp'),
            onPressed: () async {
              print(_otpValue.text);
              print(_userOtpValue.text);
              PhoneAuthCredential phoneAuthCredential =
                  PhoneAuthProvider.credential(
                verificationId: this._verificationId,
                smsCode: _userOtpValue.text,
              );
              signInWithPhoneAuthCred(context, phoneAuthCredential);
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
    await _auth.verifyPhoneNumber(
      phoneNumber: "+91${phoneController.text}",

      // After the Authentication has been Completed Successfully
      verificationCompleted: (phoneAuthCredential) async {
        setState(() {
          _isAuthenticationAccepted = true;
          print('auth successful');
        });
        // signInWithPhoneAuthCred(context, phoneAuthCredential);
      },

      // After the Authentication has been Failed/Declined
      verificationFailed: (verificationFailed) async {
        setState(() {
          _isOtpSent = false;
          _isAuthenticationAccepted = false;
          _showLoading = false;
          _isSubmitClicked = false;
        });
        print('verification failed');
        print(verificationFailed);
        String titleText = "Authenticatoin Failed!";
        String contextText = "Unable to generate the OTP.";
        _checkForError(context, titleText, contextText);

        _scaffoldKey.currentState
            ?.showSnackBar(SnackBar(content: Text("${contextText}")));
      },

      // After the OTP has been sent to Mobile Number Successfully
      codeSent: (verificationId, resendingToken) async {
        print('otp sent');

        openOtpSubmittingWidget();

        setState(() {
          _isOtpSent = true;
          _isAuthenticationAccepted = false;
          _showLoading = false;
          _isSubmitClicked = false;

          this._verificationId = verificationId;
        });
      },

      // After the Otp Timeout period
      codeAutoRetrievalTimeout: (verificationID) async {
        setState(() {
          _isOtpSent = false;
          _isAuthenticationAccepted = false;
          _showLoading = false;
          _isSubmitClicked = false;
        });

        if (!_userVerified) {
          // String titleText = "Authenticatoin Timeout!";
          // String contextText = "Please Re-Try Again";
          // _checkForError(context, titleText, contextText);
          _scaffoldKey.currentState?.showSnackBar(
              SnackBar(content: Text("Otp Timeout. Please Re-Try Again!")));
        }
      },
    );
  }

  void signInWithPhoneAuthCred(
    BuildContext context,
    PhoneAuthCredential phoneAuthCredential,
  ) async {
    setState(() {
      _showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        _showLoading = false;
      });

      if (authCredential.user != null) {
        print('authentication completed!');
        _scaffoldKey.currentState
            ?.showSnackBar(SnackBar(content: Text("Creating your Account...")));
        setState(() {
          _userVerified = true;
        });

        Provider.of<UserDetails>(context, listen: false)
            .upLoadNewUserPersonalInformation(
          context,
          authCredential,
          _firstName,
          _lastName,
          _age,
          _dateOfBirth,
          _gender,
          _eduQualification,
          _localAddress,
          _permanentAddress,
          _state_SAMBHAG_Name,
          _district_BHAG_Name,
          _block_ANCHAL_Name,
          _groupVillage_SANCH_Name,
          _village_Village_Name,
          _postalCode,
          _userPhoneNumber,
          _isProfilePicTaken,
          _profilePicture,
        );

        // Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
      }
    } on FirebaseAuthException catch (errorVal) {
      print(errorVal);

      if (_isOtpSent) {
        setState(() {
          _showLoading = false;
        });

        String titleText = "Authentication Failed!";
        String contextText = "Otp is InValid!";
        _checkForError(context, titleText, contextText);

        print(errorVal.message);

        // _scaffoldKey.currentState?.showSnackBar(
        //   SnackBar(
        //     behavior: SnackBarBehavior.floating,
        //     content: Text("Firebase Error!"),
        //   ),
        // );
      }
    }
  }

  ////////////////////// Image Container /////////////////////////

  Widget imageContainer(
    BuildContext context,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    String preUploading = "Tap To Upload Image\nछवि अपलोड करने के लिए टैप करें";
    String postUploading = "Tap To Change Image\nछवि बदलने के लिए टैप करें";
    final defaultImg = 'assets/images/uProfile.png';

    return InkWell(
      onTap: () {
        _seclectImageUploadingType(
          context,
          "Set your Profile Picture",
          "Image Picker",
        );
      },
      child: Container(
        height: screenHeight * 0.425,
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.010,
          horizontal: screenWidth * 0.015,
        ),
        margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.0025,
        ),
        child: Card(
          elevation: 5,
          child: Column(
            children: <Widget>[
              Container(
                height: 0.3 * screenHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade100,
                ),
                padding: EdgeInsets.only(
                  top: screenHeight * 0.01,
                  bottom: screenHeight * 0.025,
                ),
                alignment: Alignment.center,
                child: Container(
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: screenWidth * 0.25,
                    child: ClipOval(
                      child: _isProfilePicTaken
                          ? Image.file(
                              _profilePicture,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : Image.asset(defaultImg),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Text(
                !_isProfilePicTaken ? "${preUploading}" : "${postUploading}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _seclectImageUploadingType(
    BuildContext context,
    String titleText,
    String contextText,
  ) async {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    String str1 = "Pick From Galary";
    String str2 = "Click a Picture";

    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${titleText}'),
        content: Text('${contextText}'),
        actions: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.purple.shade300,
                  ),
                  height: screenHeight * 0.08,
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.06,
                  ),
                  margin: EdgeInsets.only(
                    left: screenWidth * 0.008,
                    bottom: screenHeight * 0.008,
                  ),
                  child: Icon(
                    Icons.photo_size_select_actual_rounded,
                  ),
                ),
                Container(
                  width: screenWidth * 0.6,
                  height: screenHeight * 0.08,
                  margin: EdgeInsets.only(
                    right: screenWidth * 0.02,
                    bottom: screenHeight * 0.008,
                  ),
                  child: RaisedButton(
                    color: Colors.purple.shade300,
                    child: Text(
                      '${str1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final imageFile = await picker.getImage(
                        source: ImageSource.gallery,
                        imageQuality: 80,
                        maxHeight: 650,
                        maxWidth: 650,
                      );

                      if (imageFile == null) {
                        return;
                      }

                      setState(() {
                        _profilePicture = File(imageFile.path);
                        _isProfilePicTaken = true;
                      });
                      Navigator.of(context).pop(false);
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.purple.shade300,
                  ),
                  height: screenHeight * 0.08,
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.06,
                  ),
                  margin: EdgeInsets.only(
                    left: screenWidth * 0.008,
                    bottom: screenHeight * 0.008,
                  ),
                  child: Icon(Icons.camera_alt_rounded),
                ),
                Container(
                  width: screenWidth * 0.6,
                  height: screenHeight * 0.08,
                  margin: EdgeInsets.only(
                    right: screenWidth * 0.02,
                    bottom: screenHeight * 0.008,
                  ),
                  child: RaisedButton(
                    color: Colors.purple.shade300,
                    child: Text(
                      '${str2}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final imageFile = await picker.getImage(
                        source: ImageSource.camera,
                        imageQuality: 80,
                        maxHeight: 650,
                        maxWidth: 650,
                      );

                      if (imageFile == null) {
                        return;
                      }

                      Navigator.of(context).pop(false);
                      setState(() {
                        _profilePicture = File(imageFile.path);
                        _isProfilePicTaken = true;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
