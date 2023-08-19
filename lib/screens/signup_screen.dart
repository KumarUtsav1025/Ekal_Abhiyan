import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './tabs_screen.dart';

import '../providers/user_details.dart';
import '../providers/auth_details.dart';
import '../providers/hardData_details.dart';

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
  String dateBtnString = "Enter D.O.B";

  File _profilePicture = new File("");

  final _designationType = TextEditingController();
  final _designationRoleType = TextEditingController();
  final _dayitvaType = TextEditingController();

  var _defaultDayitva_PrabhagType = TextEditingController();
  var _defaultDayitva_SambhagType = TextEditingController();
  var _defaultDayitva_BhagType = TextEditingController();
  var _defaultDayitva_AnchalType = TextEditingController();
  var _defaultDayitva_ClusterType = TextEditingController();
  var _defaultDayitva_SanchType = TextEditingController();
  var _defaultDayitva_SubSanchType = TextEditingController();
  var _defaultDayitva_VillageType = TextEditingController();

  // var _liabilityType = TextEditingController();
  // var _bhaagType = TextEditingController();
  // var _sambhaagType = TextEditingController();
  var _firstName = TextEditingController();
  var _lastName = TextEditingController();
  var _age = TextEditingController();
  var _gender = TextEditingController();
  late DateTime _dateOfBirth = DateTime.now();
  var _homeAddress = TextEditingController();
  var _schoolAddress = TextEditingController();
  var _state_SAMBHAG_Name = TextEditingController();
  var _district_BHAG_Name = TextEditingController();
  var _block_ANCHAL_Name = TextEditingController();
  var _groupVillage_SANCH_Name = TextEditingController();
  var _village_Village_Name = TextEditingController();

  var _postalCode = TextEditingController();
  var _eduQualification = TextEditingController();

  bool _isProfilePicTaken = false;
  bool alterDropDown = false;
  bool _isDesignationTypeSet = false;
  bool _isDesignationRoleTypeSet = false;

  bool _isPrabhaagType = false;
  bool _isSambhaagType = false;
  bool _isBhaagType = false;
  bool _iSanchalType = false;
  bool _isClusterType = false;
  bool _isSanchType = false;
  bool _isSubSanchType = false;
  bool _isVillageType = false;

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

  bool _isStateDropDownSet = false;
  bool _isRegionDropDownSet = false;
  bool _isDistrictDropDownSet = false;
  bool _isAnchalDropDownSet = false;
  bool _isSankulDropDownSet = false;
  bool _isClusterDropDownSet = false;
  bool _isSubClusterDropDownSet = false;
  bool _isVillageDropDownSet = false;
  bool _submitOtpClicked = false;

  TextEditingController defaultStateValue = TextEditingController();
  TextEditingController defaultRegionValue = TextEditingController();
  TextEditingController defaultDistrictValue = TextEditingController();
  TextEditingController defaultAnchalValue = TextEditingController();
  TextEditingController defaultSankulValue = TextEditingController();
  TextEditingController defaultClusterValue = TextEditingController();
  TextEditingController defaultSubClusterValue = TextEditingController();
  TextEditingController defaultVillageValue = TextEditingController();

  // defaultStateValue.text = "";
  // defaultRegionValue.text = "";
  // defaultDistrictValue.text = "";
  // defaultAnchalValue.text = "";
  // defaultSankulValue.text = "";
  // defaultClusterValue.text = "";
  // defaultSubClusterValue.text = "";
  // defaultVillageValue.text = "";

  @override
  void initState() {
    super.initState();
    Provider.of<AuthDetails>(context, listen: false)
        .getExistingUserPhoneNumbers();
  }

  final genderSelectionList = ["Male/पुरुष", "Female/नारी", "Others/अन्य लिंग"];

  final ekalCategorySelectionList = [
    "Karyakarta -- कार्यकर्ता",
    "Samiti -- समिति",
    "Acharya -- आचार्य"
  ];

  final dayitvaTypeList = [
    "Prabhaag -- प्रभाग",
    "Sambhaag -- संभाग",
    "Bhaag -- भाग",
    "Anchal -- अंचल",
    "Cluster -- क्लस्टर",
    "Sanch -- संच",
    "Sub-Sanch -- उपसंच",
    "Village -- गाव",
  ];

  final KaryakartaDaitvaList = [
    "अभियान प्रमुख",
    "संस्कार प्रमुख",
    "ग्राम स्वराज मंच",
    "महिला प्रमुख",
    "आरोग्य प्रमुख",
    "ग्रामोत्थान प्रमुख",
    "युवा प्रमुख",
    "संवाद प्रमुख",
    "कार्यालय प्रमुख",
    "व्यास",
  ];

  final SamitiDaitvaList = [
    "अभियान समिति",
    "संस्कार समिति",
    "ग्राम स्वराज मंच ",
    "महिला समिति",
    "आरोग्य समिति",
    "ग्रामोत्थान समिति",
    "युवा समिति",
    "संवाद समिति",
    "कार्यालय प्रभारी",
  ];

  final AcharyaDaitvaList = ["आचार्य"];

  List<dynamic> ekalList = [];
  List<dynamic> hierarchyDayitvaList = [];

  final visibilityForPrabhag = [
    "Prabhaag -- प्रभाग",
    "Sambhaag -- संभाग",
    "Bhaag -- भाग",
    "Anchal -- अंचल",
    "Cluster -- क्लस्टर",
    "Sanch -- संच",
    "Sub-Sanch -- उपसंच",
    "Village -- गाव"
  ];
  final visibilityForSambhag = [
    "Sambhaag -- संभाग",
    "Bhaag -- भाग",
    "Anchal -- अंचल",
    "Cluster -- क्लस्टर",
    "Sanch -- संच",
    "Sub-Sanch -- उपसंच",
    "Village -- गाव"
  ];
  final visibilityForBhag = [
    "Bhaag -- भाग",
    "Anchal -- अंचल",
    "Cluster -- क्लस्टर",
    "Sanch -- संच",
    "Sub-Sanch -- उपसंच",
    "Village -- गाव"
  ];
  final visibilityForAnchal = [
    "Anchal -- अंचल",
    "Cluster -- क्लस्टर",
    "Sanch -- संच",
    "Sub-Sanch -- उपसंच",
    "Village -- गाव"
  ];
  final visibilityForCluster = [
    "Cluster -- क्लस्टर",
    "Sanch -- संच",
    "Sub-Sanch -- उपसंच",
    "Village -- गाव"
  ];
  final visibilityForSanch = [
    "Sanch -- संच",
    "Sub-Sanch -- उपसंच",
    "Village -- गाव"
  ];
  final visibilityForUpSanch = ["Sub-Sanch -- उपसंच", "Village -- गाव"];
  final visibilityForVillage = ["Village -- गाव"];

  Future<void> _checkInputFields(BuildContext context) async {
    if (_designationType.text.trim().length == 0) {
      String titleText = "Invalid Designation Type!";
      String contextText = "Please select your 'Designation'...";
      _checkForError(context, titleText, contextText);
    } else if (_designationRoleType.text == "") {
      String titleText = "Invalid Karyakarta/Samiti Type!";
      String contextText = "Please select your Karyakarta/Samiti Type...";
      _checkForError(context, titleText, contextText);
    } else if (_dayitvaType.text == "") {
      String titleText = "Invalid Dayitva Level!";
      String contextText = "Please select your Dayitva Level...";
      _checkForError(context, titleText, contextText);
    } else if ((_designationType.text == "Karyakarta -- कार्यकर्ता" ||
            _designationType.text == "Samiti -- समिति") &&
        _dayitvaType.text == "Prabhaag -- प्रभाग" &&
        _defaultDayitva_PrabhagType.text == "") {
      String titleText = "Invalid Prabhag!";
      String contextText = "Please select till Prabhag...";
      _checkForError(context, titleText, contextText);
    } else if ((_designationType.text == "Karyakarta -- कार्यकर्ता" ||
            _designationType.text == "Samiti -- समिति") &&
        _dayitvaType.text == "Sambhaag -- संभाग" &&
        _defaultDayitva_SambhagType.text == "") {
      String titleText = "Invalid Sambhag!";
      String contextText = "Please select till Sambhag...";
      _checkForError(context, titleText, contextText);
    } else if ((_designationType.text == "Karyakarta -- कार्यकर्ता" ||
            _designationType.text == "Samiti -- समिति") &&
        _dayitvaType.text == "Bhaag -- भाग" &&
        _defaultDayitva_BhagType.text == "") {
      String titleText = "Invalid Bhag!";
      String contextText = "Please select till Bhag...";
      _checkForError(context, titleText, contextText);
    } else if ((_designationType.text == "Karyakarta -- कार्यकर्ता" ||
            _designationType.text == "Samiti -- समिति") &&
        _dayitvaType.text == "Anchal -- अंचल" &&
        _defaultDayitva_AnchalType.text == "") {
      String titleText = "Invalid Anchal!";
      String contextText = "Please select till Anchal...";
      _checkForError(context, titleText, contextText);
    } else if ((_designationType.text == "Karyakarta -- कार्यकर्ता" ||
            _designationType.text == "Samiti -- समिति") &&
        _dayitvaType.text == "Cluster -- क्लस्टर" &&
        _defaultDayitva_ClusterType.text == "") {
      String titleText = "Invalid Cluster!";
      String contextText = "Please select till Cluster...";
      _checkForError(context, titleText, contextText);
    } else if ((_designationType.text == "Karyakarta -- कार्यकर्ता" ||
            _designationType.text == "Samiti -- समिति") &&
        _dayitvaType.text == "Sanch -- संच" &&
        _defaultDayitva_SanchType.text == "") {
      String titleText = "Invalid Sanch!";
      String contextText = "Please select till Sanch...";
      _checkForError(context, titleText, contextText);
    } else if ((_designationType.text == "Karyakarta -- कार्यकर्ता" ||
            _designationType.text == "Samiti -- समिति") &&
        _dayitvaType.text == "Sub-Sanch -- उपसंच" &&
        _defaultDayitva_SubSanchType.text == "") {
      String titleText = "Invalid UpSanch!";
      String contextText = "Please select till UpSanch...";
      _checkForError(context, titleText, contextText);
    } else if ((_designationType.text == "Karyakarta -- कार्यकर्ता" ||
            _designationType.text == "Samiti -- समिति") &&
        _dayitvaType.text == "Village -- गाव" &&
        _defaultDayitva_VillageType.text == "") {
      String titleText = "Invalid Village!";
      String contextText = "Please select till Village...";
      _checkForError(context, titleText, contextText);
    } else if (_designationType.text == "Acharya -- आचार्य" &&
        _defaultDayitva_PrabhagType.text.length == 0) {
      String titleText = "Invalid Prabhag!";
      String contextText = "Please select your Prabhag...";
      _checkForError(context, titleText, contextText);
    } else if (_designationType.text == "Acharya -- आचार्य" &&
        _defaultDayitva_SambhagType.text.length == 0) {
      String titleText = "Invalid Sambhag!";
      String contextText = "Please select your Sambhag...";
      _checkForError(context, titleText, contextText);
    } else if (_designationType.text == "Acharya -- आचार्य" &&
        _defaultDayitva_BhagType.text.length == 0) {
      String titleText = "Invalid Bhag!";
      String contextText = "Please select your Bhag...";
      _checkForError(context, titleText, contextText);
    } else if (_designationType.text == "Acharya -- आचार्य" &&
        _defaultDayitva_AnchalType.text.length == 0) {
      String titleText = "Invalid Anchal!";
      String contextText = "Please select your Anchal...";
      _checkForError(context, titleText, contextText);
    } else if (_designationType.text == "Acharya -- आचार्य" &&
        _defaultDayitva_ClusterType.text.length == 0) {
      String titleText = "Invalid Cluster!";
      String contextText = "Please select your Cluster...";
      _checkForError(context, titleText, contextText);
    } else if (_designationType.text == "Acharya -- आचार्य" &&
        _defaultDayitva_SanchType.text.length == 0) {
      String titleText = "Invalid Sanch!";
      String contextText = "Please select your Sanch...";
      _checkForError(context, titleText, contextText);
    } else if (_designationType.text == "Acharya -- आचार्य" &&
        _defaultDayitva_SubSanchType.text.length == 0) {
      String titleText = "Invalid UpSanch!";
      String contextText = "Please select your UpSanch...";
      _checkForError(context, titleText, contextText);
    } else if (_designationType.text == "Acharya -- आचार्य" &&
        _defaultDayitva_VillageType.text.length == 0) {
      String titleText = "Invalid Village!";
      String contextText = "Please select your Village...";
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
    } else if (_firstName.text.trim().length == 0) {
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
    } else if (_homeAddress.text.trim().length <= 3) {
      String titleText = "Invalid Address";
      String contextText = "Please enter your complete address";
      _checkForError(context, titleText, contextText);
    } else {
      // String titleText = "Authentication";
      // String contextText = "Enter the Otp:";
      // _enterUserOtp(context, titleText, contextText);

      if ((await Provider.of<AuthDetails>(context, listen: false)
              .checkIfEnteredNumberExists(context, _userPhoneNumber)) ==
          false) {
        print("New User");

        setState(() {
          if (_eduQualification.text.trim().length == 0) {
            _eduQualification.text = "No Data Available\nकोई डेटा मौजूद नहीं";
          }
          if (_postalCode.text.trim().length == 0) {
            _postalCode.text = "No Data Available\nकोई डेटा मौजूद नहीं";
          }
          _isSubmitClicked = true;
          _showLoading = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Verifying your Number..."),
          ),
        );

        _checkForAuthentication(context, _userPhoneNumber);
      } else {
        print('User Already Exists!');

        String titleText = "Account Already Exists!";
        String contextText =
            "Sign-In your Account!\nअपने खाते में साइन-इन करें।";
        _checkForError(context, titleText, contextText);
      }
    }
  }

  Future<void> openOtpSubmittingWidget() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
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
          ElevatedButton(
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
        DateTime t1 = pickedDate;
        DateTime t2 = DateTime.now();
        int diff_dy = t2.difference(t1).inDays;
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

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    hierarchyDayitvaList = Provider.of<HardDataDetails>(context, listen: false)
        .getHierarchyDayitvaLocationList();

    setState(() {
      if (_designationType.text == "Karyakarta -- कार्यकर्ता" ||
          _designationType.text == "Samiti -- समिति") {
        alterDropDown = true;
      }
      if (_designationType.text == "Karyakarta -- कार्यकर्ता" &&
          (SamitiDaitvaList.contains(_designationRoleType.text) ||
              _designationRoleType.text == "आचार्य")) {
        alterDropDown = true;

        _designationRoleType.text = "";
        _dayitvaType.text = "";
        _defaultDayitva_VillageType.text = "";

        _defaultDayitva_PrabhagType.text = "";
        _defaultDayitva_SambhagType.text = "";
        _defaultDayitva_BhagType.text = "";
        _defaultDayitva_AnchalType.text = "";
        _defaultDayitva_ClusterType.text = "";
        _defaultDayitva_SanchType.text = "";
        _defaultDayitva_SubSanchType.text = "";
        _defaultDayitva_VillageType.text = "";
      } else if (_designationType.text == "Samiti -- समिति" &&
          (KaryakartaDaitvaList.contains(_designationRoleType.text) ||
              _designationRoleType.text == "आचार्य")) {
        alterDropDown = true;

        _designationRoleType.text = "";
        _dayitvaType.text = "";
        _defaultDayitva_VillageType.text = "";

        _defaultDayitva_PrabhagType.text = "";
        _defaultDayitva_SambhagType.text = "";
        _defaultDayitva_BhagType.text = "";
        _defaultDayitva_AnchalType.text = "";
        _defaultDayitva_ClusterType.text = "";
        _defaultDayitva_SanchType.text = "";
        _defaultDayitva_SubSanchType.text = "";
        _defaultDayitva_VillageType.text = "";
      } else if (_designationType.text == "Acharya -- आचार्य") {
        _designationRoleType.text = "आचार्य";
        _dayitvaType.text = "Village -- गाव";

        if (alterDropDown) {
          _defaultDayitva_PrabhagType.text = "";
          _defaultDayitva_SambhagType.text = "";
          _defaultDayitva_BhagType.text = "";
          _defaultDayitva_AnchalType.text = "";
          _defaultDayitva_ClusterType.text = "";
          _defaultDayitva_SanchType.text = "";
          _defaultDayitva_SubSanchType.text = "";
          _defaultDayitva_VillageType.text = "";
          alterDropDown = false;
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
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
            // Designation Type
            dropDownMenu(
              context,
              ekalCategorySelectionList,
              _designationType,
              "Designation Type/पदनाम प्रकार *",
              true,
              () => {},
            ),
            // SizedBox(height: screenHeight * 0.015),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100,
              ),
              margin: EdgeInsets.only(
                top: screenHeight * 0.015,
                left: screenWidth * 0.02,
                right: screenWidth * 0.02,
              ),
              child: _designationType.text == ""
                  ? SizedBox(height: 0)
                  : _designationType.text == "Karyakarta -- कार्यकर्ता"
                      ? dropDownMenu(
                          context,
                          KaryakartaDaitvaList,
                          _designationRoleType,
                          "Karyakarta Types/कार्यकर्ता प्रकार *",
                          false,
                          () => {},
                        )
                      : _designationType.text == "Samiti -- समिति"
                          ? dropDownMenu(
                              context,
                              SamitiDaitvaList,
                              _designationRoleType,
                              "Samiti Types/समिति प्रकार *",
                              false,
                              () => {},
                            )
                          : dropDownMenu(
                              context,
                              AcharyaDaitvaList,
                              _designationRoleType,
                              "Archrya Types/आचार्य प्रकार *",
                              false,
                              () => {},
                            ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100,
              ),
              margin: EdgeInsets.only(
                top: screenHeight * 0.015,
                left: screenWidth * 0.02,
                right: screenWidth * 0.02,
              ),
              child: _designationType.text == ""
                  ? SizedBox(height: 0)
                  : dropDownMenu(
                      context,
                      dayitvaTypeList,
                      _dayitvaType,
                      "Dayitva Level/दयात्व स्तर *",
                      false,
                      () => {},
                    ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                child: visibilityForPrabhag.contains(_dayitvaType.text)
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.004),
                        child: dropDownMenuForPrabhagDayitva(
                          context,
                          _defaultDayitva_PrabhagType,
                          "Prabhag",
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                child: visibilityForSambhag.contains(_dayitvaType.text)
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.004),
                        child: dropDownMenuForSambhagDayitva(
                          context,
                          _defaultDayitva_SambhagType,
                          _defaultDayitva_PrabhagType,
                          "Sambhag",
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                child: visibilityForBhag.contains(_dayitvaType.text)
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.004),
                        child: dropDownMenuForBhagDayitva(
                          context,
                          _defaultDayitva_BhagType,
                          _defaultDayitva_PrabhagType,
                          _defaultDayitva_SambhagType,
                          "Bhag",
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                child: visibilityForAnchal.contains(_dayitvaType.text)
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.004),
                        child: dropDownMenuForAnchalDayitva(
                          context,
                          _defaultDayitva_AnchalType,
                          _defaultDayitva_PrabhagType,
                          _defaultDayitva_SambhagType,
                          _defaultDayitva_BhagType,
                          "Anchal",
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                child: visibilityForCluster.contains(_dayitvaType.text)
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.004),
                        child: dropDownMenuForClusterDayitva(
                          context,
                          _defaultDayitva_ClusterType,
                          _defaultDayitva_PrabhagType,
                          _defaultDayitva_SambhagType,
                          _defaultDayitva_BhagType,
                          _defaultDayitva_AnchalType,
                          "Cluster",
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                child: visibilityForSanch.contains(_dayitvaType.text)
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.004),
                        child: dropDownMenuForSanchDayitva(
                          context,
                          _defaultDayitva_SanchType,
                          _defaultDayitva_PrabhagType,
                          _defaultDayitva_SambhagType,
                          _defaultDayitva_BhagType,
                          _defaultDayitva_AnchalType,
                          _defaultDayitva_ClusterType,
                          "Sanch",
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                child: visibilityForUpSanch.contains(_dayitvaType.text)
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.004),
                        child: dropDownMenuForUpSanchDayitva(
                          context,
                          _defaultDayitva_SubSanchType,
                          _defaultDayitva_PrabhagType,
                          _defaultDayitva_SambhagType,
                          _defaultDayitva_BhagType,
                          _defaultDayitva_AnchalType,
                          _defaultDayitva_ClusterType,
                          _defaultDayitva_SanchType,
                          "Up-Sanch",
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                child: visibilityForVillage.contains(_dayitvaType.text)
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.004),
                        child: dropDownMenuForVillageDayitva(
                          context,
                          _defaultDayitva_VillageType,
                          _defaultDayitva_PrabhagType,
                          _defaultDayitva_SambhagType,
                          _defaultDayitva_BhagType,
                          _defaultDayitva_AnchalType,
                          _defaultDayitva_ClusterType,
                          _defaultDayitva_SanchType,
                          _defaultDayitva_SubSanchType,
                          "Village",
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Container(
              child: Text(
                "------------------------------------------\nEnter Personal Information\nव्यक्तिगत जानकारी दर्ज करें\n",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _presentDatePicker(context);
                      });
                    },
                    child: Text(
                      dateBtnString,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
              false,
              () => {},
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
              "Home Address/घर का पता *",
              100,
              _homeAddress,
              TextInputType.name,
            ),
            SizedBox(height: screenHeight * 0.005),
            // Permanent Address
            Padding(
              padding: const EdgeInsets.all(0),
              child: _designationType.text == "Acharya -- आचार्य"
                  ? TextFieldContainer(
                      context,
                      "School Address/स्कूल का पता *",
                      100,
                      _schoolAddress,
                      TextInputType.name,
                    )
                  : SizedBox(height: 0),
            ),
            // SizedBox(
            //   height: screenHeight * 0.035,
            // ),
            // Container(
            //   child: Text(
            //     'Select Address Categories\nपता श्रेणियां चुनें',
            //     textAlign: TextAlign.center,
            //     style: TextStyle(fontWeight: FontWeight.bold),
            //   ),
            // ),
            // SizedBox(height: screenHeight * 0.005),
            // dropDownMenuForStates(context, defaultStateValue, "State"),
            // SizedBox(height: screenHeight * 0.005),
            // dropDownMenuForRegions(
            //     context, defaultStateValue, defaultRegionValue, "Region"),
            // SizedBox(height: screenHeight * 0.005),
            // dropDownMenuForDistricts(context, defaultStateValue,
            //     defaultRegionValue, defaultDistrictValue, "District"),
            // SizedBox(height: screenHeight * 0.005),
            // dropDownMenuForAnchal(
            //   context,
            //   defaultStateValue,
            //   defaultRegionValue,
            //   defaultDistrictValue,
            //   defaultAnchalValue,
            //   "Anchal",
            // ),
            // SizedBox(height: screenHeight * 0.005),
            // dropDownMenuForSankul(
            //   context,
            //   defaultStateValue,
            //   defaultRegionValue,
            //   defaultDistrictValue,
            //   defaultAnchalValue,
            //   defaultSankulValue,
            //   "Sankul",
            // ),
            // SizedBox(height: screenHeight * 0.005),
            // dropDownMenuForCluster(
            //   context,
            //   defaultStateValue,
            //   defaultRegionValue,
            //   defaultDistrictValue,
            //   defaultAnchalValue,
            //   defaultSankulValue,
            //   defaultClusterValue,
            //   "Cluster",
            // ),
            // SizedBox(height: screenHeight * 0.005),
            // dropDownMenuForSubCluster(
            //   context,
            //   defaultStateValue,
            //   defaultRegionValue,
            //   defaultDistrictValue,
            //   defaultAnchalValue,
            //   defaultSankulValue,
            //   defaultClusterValue,
            //   defaultSubClusterValue,
            //   "Sub-Cluster",
            // ),
            // SizedBox(height: screenHeight * 0.005),
            // dropDownMenuForVillage(
            //   context,
            //   defaultStateValue,
            //   defaultRegionValue,
            //   defaultDistrictValue,
            //   defaultAnchalValue,
            //   defaultSankulValue,
            //   defaultClusterValue,
            //   defaultSubClusterValue,
            //   defaultVillageValue,
            //   "Village",
            // ),
            SizedBox(height: screenHeight * 0.025),
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade500,
                    ),
                    onPressed: _isSubmitClicked
                        ? null
                        : () {
                            _checkInputFields(context);
                          },
                    child: !_isSubmitClicked
                        ? const Text(
                            'Submit/जमा करे',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : CircularProgressIndicator(),
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
    bool callFunction,
    functionCall(),
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    if (callFunction) {
      functionCall();
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
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
          isExpanded: true,
          iconSize: 35,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
          ),
          onTap: () {},
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

  ////////////////// Drop-Down Widgets for Dayitva Hierarchy ///////////////

  Widget dropDownMenuForPrabhagDayitva(
    BuildContext context,
    TextEditingController _textCtr,
    String hintText,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    List<String> dropDownList = getPrabhagDavitvaList(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
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
          items: dropDownList.map(buildMenuItemModified).toList(),
          onChanged: (value) => setState(() {
            _textCtr.text = value!;

            _defaultDayitva_SambhagType.text = "";
            _defaultDayitva_BhagType.text = "";
            _defaultDayitva_AnchalType.text = "";
            _defaultDayitva_ClusterType.text = "";
            _defaultDayitva_SanchType.text = "";
            _defaultDayitva_SubSanchType.text = "";
            _defaultDayitva_VillageType.text = "";
          }),
        ),
      ),
    );
  }

  Widget dropDownMenuForSambhagDayitva(
    BuildContext context,
    TextEditingController _textCtr,
    TextEditingController prabhagName,
    String hintText,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    List<String> dropDownList = getSambhagDavitvaList(context, prabhagName);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
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
          items: dropDownList.map(buildMenuItemModified).toList(),
          onChanged: (value) => setState(() {
            _textCtr.text = value!;

            _defaultDayitva_BhagType.text = "";
            _defaultDayitva_AnchalType.text = "";
            _defaultDayitva_ClusterType.text = "";
            _defaultDayitva_SanchType.text = "";
            _defaultDayitva_SubSanchType.text = "";
            _defaultDayitva_VillageType.text = "";
          }),
        ),
      ),
    );
  }

  Widget dropDownMenuForBhagDayitva(
    BuildContext context,
    TextEditingController _textCtr,
    TextEditingController prabhagName,
    TextEditingController bhagName,
    String hintText,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    List<String> dropDownList =
        getBhagDavitvaList(context, prabhagName, bhagName);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
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
          items: dropDownList.map(buildMenuItemModified).toList(),
          onChanged: (value) => setState(() {
            _textCtr.text = value!;

            _defaultDayitva_AnchalType.text = "";
            _defaultDayitva_ClusterType.text = "";
            _defaultDayitva_SanchType.text = "";
            _defaultDayitva_SubSanchType.text = "";
            _defaultDayitva_VillageType.text = "";
          }),
        ),
      ),
    );
  }

  Widget dropDownMenuForAnchalDayitva(
    BuildContext context,
    TextEditingController _textCtr,
    TextEditingController prabhagName,
    TextEditingController bhagName,
    TextEditingController anchalName,
    String hintText,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    List<String> dropDownList =
        getAnchalDavitvaList(context, prabhagName, bhagName, anchalName);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
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
          items: dropDownList.map(buildMenuItemModified).toList(),
          onChanged: (value) => setState(() {
            _textCtr.text = value!;

            _defaultDayitva_ClusterType.text = "";
            _defaultDayitva_SanchType.text = "";
            _defaultDayitva_SubSanchType.text = "";
            _defaultDayitva_VillageType.text = "";
          }),
        ),
      ),
    );
  }

  Widget dropDownMenuForClusterDayitva(
    BuildContext context,
    TextEditingController _textCtr,
    TextEditingController prabhagName,
    TextEditingController bhagName,
    TextEditingController anchalName,
    TextEditingController clusterName,
    String hintText,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    List<String> dropDownList = getClusterDavitvaList(
        context, prabhagName, bhagName, anchalName, clusterName);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
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
          items: dropDownList.map(buildMenuItemModified).toList(),
          onChanged: (value) => setState(() {
            _textCtr.text = value!;

            _defaultDayitva_SanchType.text = "";
            _defaultDayitva_SubSanchType.text = "";
            _defaultDayitva_VillageType.text = "";
          }),
        ),
      ),
    );
  }

  Widget dropDownMenuForSanchDayitva(
    BuildContext context,
    TextEditingController _textCtr,
    TextEditingController prabhagName,
    TextEditingController bhagName,
    TextEditingController anchalName,
    TextEditingController clusterName,
    TextEditingController sanchName,
    String hintText,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    List<String> dropDownList = getSanchDavitvaList(
        context, prabhagName, bhagName, anchalName, clusterName, sanchName);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
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
          items: dropDownList.map(buildMenuItemModified).toList(),
          onChanged: (value) => setState(() {
            _textCtr.text = value!;

            _defaultDayitva_SubSanchType.text = "";
            _defaultDayitva_VillageType.text = "";
          }),
        ),
      ),
    );
  }

  Widget dropDownMenuForUpSanchDayitva(
    BuildContext context,
    TextEditingController _textCtr,
    TextEditingController prabhagName,
    TextEditingController bhagName,
    TextEditingController anchalName,
    TextEditingController clusterName,
    TextEditingController sanchName,
    TextEditingController upSanchName,
    String hintText,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    List<String> dropDownList = getUpSanchDavitvaList(context, prabhagName,
        bhagName, anchalName, clusterName, sanchName, upSanchName);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
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
          items: dropDownList.map(buildMenuItemModified).toList(),
          onChanged: (value) => setState(() {
            _textCtr.text = value!;

            _defaultDayitva_VillageType.text = "";
          }),
        ),
      ),
    );
  }

  Widget dropDownMenuForVillageDayitva(
    BuildContext context,
    TextEditingController _textCtr,
    TextEditingController prabhagName,
    TextEditingController bhagName,
    TextEditingController anchalName,
    TextEditingController clusterName,
    TextEditingController sanchName,
    TextEditingController upSanchName,
    TextEditingController villageName,
    String hintText,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    List<String> dropDownList = getVillageDavitvaList(context, prabhagName,
        bhagName, anchalName, clusterName, sanchName, upSanchName, villageName);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
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
          items: dropDownList.map(buildMenuItemModified).toList(),
          onChanged: (value) => setState(() {
            _textCtr.text = value!;
          }),
        ),
      ),
    );
  }

  ////////////////// Drop-Down Widgets for different User location ///////////////

  Widget dropDownMenuForStates(
    BuildContext context,
    TextEditingController _textCtr,
    String hintText,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    List<String> dropDownList = getStateList(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
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
          items: dropDownList.map(buildMenuItemModified).toList(),
          onChanged: (value) => setState(() {
            _textCtr.text = value!;

            defaultRegionValue.text = "";
            defaultDistrictValue.text = "";
            defaultAnchalValue.text = "";
            defaultSankulValue.text = "";
            defaultClusterValue.text = "";
            defaultSubClusterValue.text = "";
            defaultVillageValue.text = "";
          }),
        ),
      ),
    );
  }

  Widget dropDownMenuForRegions(
    BuildContext context,
    TextEditingController stateName,
    TextEditingController _textCtr,
    String hintText,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    List<String> dropDownList = getRegionList(context, stateName);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
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
          items: dropDownList.map(buildMenuItemModified).toList(),
          onChanged: (value) => setState(() {
            _textCtr.text = value!;

            defaultDistrictValue.text = "";
            defaultAnchalValue.text = "";
            defaultSankulValue.text = "";
            defaultClusterValue.text = "";
            defaultSubClusterValue.text = "";
            defaultVillageValue.text = "";
          }),
        ),
      ),
    );
  }

  Widget dropDownMenuForDistricts(
    BuildContext context,
    TextEditingController stateName,
    TextEditingController regionName,
    TextEditingController _textCtr,
    String hintText,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    List<String> dropDownList = getDistrictList(context, stateName, regionName);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
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
          items: dropDownList.map(buildMenuItemModified).toList(),
          onChanged: (value) => setState(() {
            _textCtr.text = value!;

            defaultAnchalValue.text = "";
            defaultSankulValue.text = "";
            defaultClusterValue.text = "";
            defaultSubClusterValue.text = "";
            defaultVillageValue.text = "";
          }),
        ),
      ),
    );
  }

  Widget dropDownMenuForAnchal(
    BuildContext context,
    TextEditingController stateName,
    TextEditingController regionName,
    TextEditingController districtName,
    TextEditingController _textCtr,
    String hintText,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    List<String> dropDownList =
        getAnchalList(context, stateName, regionName, districtName);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
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
          items: dropDownList.map(buildMenuItemModified).toList(),
          onChanged: (value) => setState(() {
            _textCtr.text = value!;

            defaultSankulValue.text = "";
            defaultClusterValue.text = "";
            defaultSubClusterValue.text = "";
            defaultVillageValue.text = "";
          }),
        ),
      ),
    );
  }

  Widget dropDownMenuForSankul(
    BuildContext context,
    TextEditingController stateName,
    TextEditingController regionName,
    TextEditingController districtName,
    TextEditingController anchalName,
    TextEditingController _textCtr,
    String hintText,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    List<String> dropDownList = getSankulList(
      context,
      stateName,
      regionName,
      districtName,
      anchalName,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
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
          items: dropDownList.map(buildMenuItemModified).toList(),
          onChanged: (value) => setState(() {
            _textCtr.text = value!;

            defaultClusterValue.text = "";
            defaultSubClusterValue.text = "";
            defaultVillageValue.text = "";
          }),
        ),
      ),
    );
  }

  Widget dropDownMenuForCluster(
    BuildContext context,
    TextEditingController stateName,
    TextEditingController regionName,
    TextEditingController districtName,
    TextEditingController anchalName,
    TextEditingController sankullName,
    TextEditingController _textCtr,
    String hintText,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    List<String> dropDownList = getClusterList(
      context,
      stateName,
      regionName,
      districtName,
      anchalName,
      sankullName,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
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
          items: dropDownList.map(buildMenuItemModified).toList(),
          onChanged: (value) => setState(() {
            _textCtr.text = value!;

            defaultSubClusterValue.text = "";
            defaultVillageValue.text = "";
          }),
        ),
      ),
    );
  }

  Widget dropDownMenuForSubCluster(
    BuildContext context,
    TextEditingController stateName,
    TextEditingController regionName,
    TextEditingController districtName,
    TextEditingController anchalName,
    TextEditingController sankullName,
    TextEditingController clusterlName,
    TextEditingController _textCtr,
    String hintText,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    List<String> dropDownList = getSubClusterList(
      context,
      stateName,
      regionName,
      districtName,
      anchalName,
      sankullName,
      clusterlName,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
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
          items: dropDownList.map(buildMenuItemModified).toList(),
          onChanged: (value) => setState(() {
            _textCtr.text = value!;

            defaultVillageValue.text = "";
          }),
        ),
      ),
    );
  }

  Widget dropDownMenuForVillage(
    BuildContext context,
    TextEditingController stateName,
    TextEditingController regionName,
    TextEditingController districtName,
    TextEditingController anchalName,
    TextEditingController sankullName,
    TextEditingController clusterlName,
    TextEditingController subClusterlName,
    TextEditingController _textCtr,
    String hintText,
  ) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    List<String> dropDownList = getVillageList(
      context,
      stateName,
      regionName,
      districtName,
      anchalName,
      sankullName,
      clusterlName,
      subClusterlName,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
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
          items: dropDownList.map(buildMenuItemModified).toList(),
          onChanged: (value) => setState(() {
            _textCtr.text = value!;
          }),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItemModified(String item) =>
      DropdownMenuItem(
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
      // child: Column(
      //   children: <Widget>[
      //     FormHelper.dropDownWidgetWithLabel(
      //       context,
      //       labelName,
      //       hintText,
      //       inputValue,
      //       dropDownList,
      //       (onChangedVal) {
      //         inputValue = onChangedVal;
      //         setState(
      //           () {
      //             int idx = int.parse(onChangedVal);
      //             _textCtr.text = dropDownList[idx - 1][optLabel];
      //           },
      //         );
      //       },
      //       (onValidateVal) {
      //         if (onValidateVal == null) {
      //           return "Select ${selectionInfo}";
      //         }
      //         return null;
      //       },
      //       borderColor: Colors.grey.shade100,
      //       optionValue: "${optValue}",
      //       optionLabel: "${optLabel}",
      //     ),
      //   ],
      // ),
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.5),
              ),
              backgroundColor: Colors.blue.shade400,
            ),
            onPressed: _submitOtpClicked
                ? null
                : () async {
                    setState(() {
                      _submitOtpClicked = true;
                    });
                    PhoneAuthCredential phoneAuthCredential =
                        PhoneAuthProvider.credential(
                      verificationId: this._verificationId,
                      smsCode: _userOtpValue.text,
                    );
                    signInWithPhoneAuthCred(context, phoneAuthCredential);
                  },
            child: const Text('Submit Otp'),
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
          _submitOtpClicked = false;
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
          _submitOtpClicked = false;
        });
        print('verification failed');
        print(verificationFailed);
        String titleText = "Authenticatoin Failed!";
        String contextText = "Unable to generate the OTP.";
        _checkForError(context, titleText, contextText);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(contextText)),
        );
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
          _submitOtpClicked = false;

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
          _submitOtpClicked = false;
        });

        if (!_userVerified) {
          // String titleText = "Authenticatoin Timeout!";
          // String contextText = "Please Re-Try Again";
          // _checkForError(context, titleText, contextText);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Otp Timeout. Please Re-Try Again!")),
          );
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Creating your Account...")),
        );
        setState(() {
          _userVerified = true;
          _submitOtpClicked = false;
        });

        Provider.of<UserDetails>(context, listen: false)
            .upLoadNewUserPersonalInformation(
          context,
          authCredential,
          _designationType,
          _designationRoleType,
          _dayitvaType,
          _defaultDayitva_PrabhagType,
          _defaultDayitva_SambhagType,
          _defaultDayitva_BhagType,
          _defaultDayitva_AnchalType,
          _defaultDayitva_ClusterType,
          _defaultDayitva_SanchType,
          _defaultDayitva_SubSanchType,
          _defaultDayitva_VillageType,
          _userPhoneNumber,
          _firstName,
          _lastName,
          _age,
          _dateOfBirth,
          _gender,
          _eduQualification,
          _homeAddress,
          _schoolAddress,
          _postalCode,
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
                  child: const Icon(
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade300,
                    ),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final imageFile = await picker.pickImage(
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
                    child: Text(
                      str1,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade300,
                    ),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final imageFile = await picker.pickImage(
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
                    child: Text(
                      str2,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  ////////////////// List function for different Dayitva positions ///////////////

  List<String> getPrabhagDavitvaList(BuildContext context) {
    List<String> prabhagList = ["PURV PRABHAG P2"];

    return prabhagList;
  }

  List<String> getSambhagDavitvaList(
    BuildContext context,
    TextEditingController prabhagName,
  ) {
    Set<String> sambhagSet = {};

    this.hierarchyDayitvaList.forEach((obj) {
      if ((obj as dynamic)['PRABHAG'] == prabhagName.text) {
        sambhagSet.add(obj['SAMBHAG']);
      }
    });

    return sambhagSet.toList();
  }

  List<String> getBhagDavitvaList(
    BuildContext context,
    TextEditingController prabhagName,
    TextEditingController sambhagName,
  ) {
    Set<String> bhagSet = {};

    this.hierarchyDayitvaList.forEach((obj) {
      if ((obj as dynamic)['PRABHAG'] == '${prabhagName.text}' &&
          (obj as dynamic)['SAMBHAG'] == '${sambhagName.text}') {
        bhagSet.add(obj['BHAG']);
      }
    });

    return bhagSet.toList();
  }

  List<String> getAnchalDavitvaList(
    BuildContext context,
    TextEditingController prabhagName,
    TextEditingController sambhagName,
    TextEditingController bhagName,
  ) {
    Set<String> anchalSet = {};

    this.hierarchyDayitvaList.forEach((obj) {
      if ((obj as dynamic)['PRABHAG'] == '${prabhagName.text}' &&
          (obj as dynamic)['SAMBHAG'] == '${sambhagName.text}' &&
          (obj as dynamic)['BHAG'] == '${bhagName.text}') {
        anchalSet.add(obj['ANCHAL']);
      }
    });

    return anchalSet.toList();
  }

  List<String> getClusterDavitvaList(
    BuildContext context,
    TextEditingController prabhagName,
    TextEditingController sambhagName,
    TextEditingController bhagName,
    TextEditingController anchalName,
  ) {
    Set<String> clusterSet = {};

    this.hierarchyDayitvaList.forEach((obj) {
      if ((obj as dynamic)['PRABHAG'] == '${prabhagName.text}' &&
          (obj as dynamic)['SAMBHAG'] == '${sambhagName.text}' &&
          (obj as dynamic)['BHAG'] == '${bhagName.text}' &&
          (obj as dynamic)['ANCHAL'] == '${anchalName.text}') {
        clusterSet.add(obj['CLUSTER']);
      }
    });

    return clusterSet.toList();
  }

  List<String> getSanchDavitvaList(
    BuildContext context,
    TextEditingController prabhagName,
    TextEditingController sambhagName,
    TextEditingController bhagName,
    TextEditingController anchalName,
    TextEditingController clusterName,
  ) {
    Set<String> sanchSet = {};

    this.hierarchyDayitvaList.forEach((obj) {
      if ((obj as dynamic)['PRABHAG'] == '${prabhagName.text}' &&
          (obj as dynamic)['SAMBHAG'] == '${sambhagName.text}' &&
          (obj as dynamic)['BHAG'] == '${bhagName.text}' &&
          (obj as dynamic)['ANCHAL'] == '${anchalName.text}' &&
          (obj as dynamic)['CLUSTER'] == '${clusterName.text}') {
        sanchSet.add(obj['SANCH']);
      }
    });

    return sanchSet.toList();
  }

  List<String> getUpSanchDavitvaList(
    BuildContext context,
    TextEditingController prabhagName,
    TextEditingController sambhagName,
    TextEditingController bhagName,
    TextEditingController anchalName,
    TextEditingController clusterName,
    TextEditingController sanchName,
  ) {
    Set<String> upSanchSet = {};

    this.hierarchyDayitvaList.forEach((obj) {
      if ((obj as dynamic)['PRABHAG'] == '${prabhagName.text}' &&
          (obj as dynamic)['SAMBHAG'] == '${sambhagName.text}' &&
          (obj as dynamic)['BHAG'] == '${bhagName.text}' &&
          (obj as dynamic)['ANCHAL'] == '${anchalName.text}' &&
          (obj as dynamic)['CLUSTER'] == '${clusterName.text}' &&
          (obj as dynamic)['SANCH'] == '${sanchName.text}') {
        upSanchSet.add(obj['UPSANCH']);
      }
    });

    return upSanchSet.toList();
  }

  List<String> getVillageDavitvaList(
    BuildContext context,
    TextEditingController prabhagName,
    TextEditingController sambhagName,
    TextEditingController bhagName,
    TextEditingController anchalName,
    TextEditingController clusterName,
    TextEditingController sanchName,
    TextEditingController upSanchName,
  ) {
    Set<String> villageSet = {};

    this.hierarchyDayitvaList.forEach((obj) {
      if ((obj as dynamic)['PRABHAG'] == '${prabhagName.text}' &&
          (obj as dynamic)['SAMBHAG'] == '${sambhagName.text}' &&
          (obj as dynamic)['BHAG'] == '${bhagName.text}' &&
          (obj as dynamic)['ANCHAL'] == '${anchalName.text}' &&
          (obj as dynamic)['CLUSTER'] == '${clusterName.text}' &&
          (obj as dynamic)['SANCH'] == '${sanchName.text}' &&
          (obj as dynamic)['UPSANCH'] == '${upSanchName.text}') {
        villageSet.add(obj['VILLAGE']);
      }
    });

    return villageSet.toList();
  }

  ////////////////// List function for different User Locations ///////////////

  List<String> getStateList(BuildContext context) {
    List<String> stateList = ["Chhattisgarh"];

    return stateList;
  }

  List<String> getRegionList(
      BuildContext context, TextEditingController stateName) {
    Set<String> regionSet = {};

    // var checkForResponse = await Future.forEach(
    //   this.ekalList,
    //   (obj) {
    //     if ((obj as dynamic)['STATE'] == '${stateName.text}') {
    //       regionSet.add(obj['REGION']);
    //     }
    //   },
    // ).then((value) {
    //   return regionSet.toList();
    // });
    this.ekalList.forEach((obj) {
      if ((obj as dynamic)['STATE'] == '${stateName.text}') {
        regionSet.add(obj['REGION']);
      }
    });

    return regionSet.toList();

    // return checkForResponse;
  }

  List<String> getDistrictList(
    BuildContext context,
    TextEditingController stateName,
    TextEditingController regionName,
  ) {
    Set<String> districtSet = {};

    // var checkForResponse = await Future.forEach(
    //   this.ekalList,
    //   (obj) {
    //     if ((obj as dynamic)['STATE'] == stateName.text &&
    //         (obj as dynamic)['REGION'] == regionName.text) {
    //       districtSet.add(obj['DISTRICT']);
    //     }
    //   },
    // ).then((value) {
    //   return districtSet.toList();
    // });

    // return checkForResponse;

    this.ekalList.forEach((obj) {
      if ((obj as dynamic)['STATE'] == stateName.text &&
          (obj as dynamic)['REGION'] == regionName.text) {
        districtSet.add(obj['DISTRICT']);
      }
    });

    return districtSet.toList();
  }

  List<String> getAnchalList(
    BuildContext context,
    TextEditingController stateName,
    TextEditingController regionName,
    TextEditingController districtName,
  ) {
    Set<String> anchalSet = {};

    // var checkForResponse = await Future.forEach(
    //   this.ekalList,
    //   (obj) {
    //     if ((obj as dynamic)['STATE'] == stateName.text &&
    //         (obj as dynamic)['REGION'] == regionName.text &&
    //         (obj as dynamic)['DISTRICT'] == districtName.text) {
    //       anchalSet.add(obj['ANCHAL']);
    //     }
    //   },
    // ).then((value) {
    //   return anchalSet.toList();
    // });

    // return checkForResponse;

    this.ekalList.forEach((obj) {
      if ((obj as dynamic)['STATE'] == stateName.text &&
          (obj as dynamic)['REGION'] == regionName.text &&
          (obj as dynamic)['DISTRICT'] == districtName.text) {
        anchalSet.add(obj['ANCHAL']);
      }
    });

    return anchalSet.toList();
  }

  List<String> getSankulList(
    BuildContext context,
    TextEditingController stateName,
    TextEditingController regionName,
    TextEditingController districtName,
    TextEditingController anchalName,
  ) {
    Set<String> sankulSet = {};

    // var checkForResponse = await Future.forEach(
    //   this.ekalList,
    //   (obj) {
    //     if ((obj as dynamic)['STATE'] == stateName.text &&
    //         (obj as dynamic)['REGION'] == regionName.text &&
    //         (obj as dynamic)['DISTRICT'] == districtName.text &&
    //         (obj as dynamic)['ANCHAL'] == anchalName.text) {
    //       sankulSet.add(obj['SANKUL']);
    //     }
    //   },
    // ).then((value) {
    //   return sankulSet.toList();
    // });

    // return checkForResponse;

    this.ekalList.forEach((obj) {
      if ((obj as dynamic)['STATE'] == stateName.text &&
          (obj as dynamic)['REGION'] == regionName.text &&
          (obj as dynamic)['DISTRICT'] == districtName.text &&
          (obj as dynamic)['ANCHAL'] == anchalName.text) {
        sankulSet.add(obj['SANKUL']);
      }
    });

    return sankulSet.toList();
  }

  List<String> getClusterList(
    BuildContext context,
    TextEditingController stateName,
    TextEditingController regionName,
    TextEditingController districtName,
    TextEditingController anchalName,
    TextEditingController sankulName,
  ) {
    Set<String> clusterSet = {};

    // var checkForResponse = await Future.forEach(
    //   this.ekalList,
    //   (obj) {
    //     if ((obj as dynamic)['STATE'] == stateName.text &&
    //         (obj as dynamic)['REGION'] == regionName.text &&
    //         (obj as dynamic)['DISTRICT'] == districtName.text &&
    //         (obj as dynamic)['ANCHAL'] == anchalName.text &&
    //         (obj as dynamic)['SANKUL'] == sankulName.text) {
    //       clusterSet.add(obj['CLUSTER']);
    //     }
    //   },
    // ).then((value) {
    //   return clusterSet.toList();
    // });

    // return checkForResponse;

    this.ekalList.forEach((obj) {
      if ((obj as dynamic)['STATE'] == stateName.text &&
          (obj as dynamic)['REGION'] == regionName.text &&
          (obj as dynamic)['DISTRICT'] == districtName.text &&
          (obj as dynamic)['ANCHAL'] == anchalName.text &&
          (obj as dynamic)['SANKUL'] == sankulName.text) {
        clusterSet.add(obj['CLUSTER']);
      }
    });

    return clusterSet.toList();
  }

  List<String> getSubClusterList(
    BuildContext context,
    TextEditingController stateName,
    TextEditingController regionName,
    TextEditingController districtName,
    TextEditingController anchalName,
    TextEditingController sankulName,
    TextEditingController clusterName,
  ) {
    Set<String> subClusterSet = {};

    // var checkForResponse = await Future.forEach(
    //   this.ekalList,
    //   (obj) {
    //     if ((obj as dynamic)['STATE'] == stateName.text &&
    //         (obj as dynamic)['REGION'] == regionName.text &&
    //         (obj as dynamic)['DISTRICT'] == districtName.text &&
    //         (obj as dynamic)['ANCHAL'] == anchalName.text &&
    //         (obj as dynamic)['SANKUL'] == sankulName.text &&
    //         (obj as dynamic)['CLUSTER'] == clusterName.text) {
    //       subClusterSet.add(obj['SUB-CLUSTER']);
    //     }
    //   },
    // ).then((value) {
    //   return subClusterSet.toList();
    // });

    // return checkForResponse;

    this.ekalList.forEach((obj) {
      if ((obj as dynamic)['STATE'] == stateName.text &&
          (obj as dynamic)['REGION'] == regionName.text &&
          (obj as dynamic)['DISTRICT'] == districtName.text &&
          (obj as dynamic)['ANCHAL'] == anchalName.text &&
          (obj as dynamic)['SANKUL'] == sankulName.text &&
          (obj as dynamic)['CLUSTER'] == clusterName.text) {
        subClusterSet.add(obj['SUB-CLUSTER']);
      }
    });

    return subClusterSet.toList();
  }

  List<String> getVillageList(
    BuildContext context,
    TextEditingController stateName,
    TextEditingController regionName,
    TextEditingController districtName,
    TextEditingController anchalName,
    TextEditingController sankulName,
    TextEditingController clusterName,
    TextEditingController subClusterName,
  ) {
    Set<String> villageSet = {};

    // var checkForResponse = await Future.forEach(
    //   this.ekalList,
    //   (obj) {
    //     if ((obj as dynamic)['STATE'] == stateName.text &&
    //         (obj as dynamic)['REGION'] == regionName.text &&
    //         (obj as dynamic)['DISTRICT'] == districtName.text &&
    //         (obj as dynamic)['ANCHAL'] == anchalName.text &&
    //         (obj as dynamic)['SANKUL'] == sankulName.text &&
    //         (obj as dynamic)['CLUSTER'] == clusterName.text &&
    //         (obj as dynamic)['SUB-CLUSTER'] == subClusterName.text) {
    //       villageSet.add(obj['VILLAGE']);
    //     }
    //   },
    // ).then((value) {
    //   return villageSet.toList();
    // });

    // return checkForResponse;

    this.ekalList.forEach((obj) {
      if ((obj as dynamic)['STATE'] == stateName.text &&
          (obj as dynamic)['REGION'] == regionName.text &&
          (obj as dynamic)['DISTRICT'] == districtName.text &&
          (obj as dynamic)['ANCHAL'] == anchalName.text &&
          (obj as dynamic)['SANKUL'] == sankulName.text &&
          (obj as dynamic)['CLUSTER'] == clusterName.text &&
          (obj as dynamic)['SUB-CLUSTER'] == subClusterName.text) {
        villageSet.add(obj['VILLAGE']);
      }
    });

    return villageSet.toList();
  }
}
