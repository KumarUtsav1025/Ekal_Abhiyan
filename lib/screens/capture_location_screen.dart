import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/user_details.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPaths;
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/user_details.dart';
import '../providers/hardData_details.dart';
import '../providers/location_details.dart';

class CaptureLocationScreen extends StatefulWidget {
  static const routeName = '/capture-location-screen';

  @override
  State<CaptureLocationScreen> createState() => _CaptureLocationScreenState();
}

class _CaptureLocationScreenState extends State<CaptureLocationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isFloatingButtonActive = true;
  bool _isSpinnerLoading = false;
  bool _isCurrentLocationAccessGiven = false;
  bool _isCurrentLocationTaken = false;
  bool _isCameraOpened = false;
  bool _isLocationPictureTaken = false;
  bool _isSubmitLoadingSpinner = false;
  bool _getAddressFunc = false;
  bool _isClassCreated = false;
  bool _isSubmitClicked = false;

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

  TextEditingController _sthalType = TextEditingController();
  TextEditingController _astherType = TextEditingController();
  TextEditingController userUniqueIdValue = TextEditingController();
  TextEditingController locationDescriptionValue = TextEditingController();

  TextEditingController _defaultDayitva_PrabhagType = TextEditingController();
  TextEditingController _defaultDayitva_SambhagType = TextEditingController();
  TextEditingController _defaultDayitva_BhagType = TextEditingController();
  TextEditingController _defaultDayitva_AnchalType = TextEditingController();
  TextEditingController _defaultDayitva_ClusterType = TextEditingController();
  TextEditingController _defaultDayitva_SanchType = TextEditingController();
  TextEditingController _defaultDayitva_SubSanchType = TextEditingController();
  TextEditingController _defaultDayitva_VillageType = TextEditingController();

  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  var latitudeValue = 'Getting Latitude...'.obs;
  var longitudeValue = 'Getting Longitude...'.obs;
  var addressValue = 'Getting Address...'.obs;
  late StreamSubscription<Position> streamSubscription;

  late File _storedImage;
  var _picTiming;
  var _savedImageFilePath = "";
  var _numberOfStudents = 0;

  late File _imageFile;
  bool isLoading = false;
  final picker = ImagePicker();

  List<dynamic> ekalList = [];

  @override
  void initState() {
    super.initState();
    _requestPermission();

    userUniqueIdValue.text = Provider.of<UserDetails>(context, listen: false)
        .getLoggedInUserUniqueId();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      if (_isCurrentLocationTaken == true) {
        _stopListening();
      }
    });
  }

  List<dynamic> hierarchyDayitvaList = [];

  final sthalTypeList = [
    "आचार्य घर",
    "ग्राम समिति",
    "अभिभावक",
    "सामुदायिक भवन",
    "सांस्कृतिक मंच",
    "चबूतरा",
    "प्रांगण",
    "योग केंद्र",
    "संस्कार केंद्र",
    "पोषण वाटिका",
    "जैविक पिट",
    "विद्यालय",
    "योग दिवस 2022",
  ];

  final astherTypeList = [
    "Prabhaag -- प्रभाग",
    "Sambhaag -- संभाग",
    "Bhaag -- भाग",
    "Anchal -- अंचल",
    "Cluster -- क्लस्टर",
    "Sanch -- संच",
    "Sub-Sanch -- उपसंच",
    "Village -- गाव",
  ];

  final addressSelectionList = [
    "Ekal_Samiti",
    "Residence",
    "Student",
    "Sarpanch",
    "Sacheev",
    "Panch",
    "Vaidya",
    "Pandit"
  ];

  final stharPrahagList = [
    "प्रभाग कार्यालय",
    "समिति निवास",
  ];
  final stharSambhagList = ["सम्भाग कार्यालय", "समिति का निवास"];
  final stharBhagList = ["भाग कार्यालय", "समिति का निवास"];
  final stharAnchalList = ["अंचल कार्यालय", "समिति का निवास"];
  final stharClusterList = ["कार्यालय", "समिति का निवास"];
  final stharSanchList = ["आचार्य मासिक बैठक स्थल", "समिति का निवास"];
  final stharUpSanchList = ["आचार्य मासिक बैठक स्थल", "समिति का निवास"];
  final stharVillageList = [
    "आचार्य घर",
    "ग्राम समिति",
    "अभिभावक",
    "सामुदायिक भवन",
    "सांस्कृतिक मंच",
    "चबूतरा",
    "प्रांगण",
    "योग केंद्र",
    "संस्कार केंद्र",
    "पोषण वाटिका",
    "जैविक पिट",
    "विद्यालय",
    "योग दिवस 2022",
  ];

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
              Navigator.of(ctx).pop(false);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _checkLocatoinService(
    BuildContext context,
    String titleText,
    String contextText,
  ) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${titleText}'),
        content: Text('${contextText}'),
        actions: <Widget>[
          RaisedButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _submitCapturedLocationInformation(
    BuildContext context,
    GlobalKey<ScaffoldState> sKey,
  ) async {
    if (_astherType.text.length == 0) {
      String titleText = "Invalid Sthar/स्तर Type!";
      String contextText = "Please select your 'Sthar/स्तर'...";
      _checkForError(context, titleText, contextText);
    } 
    else if (_sthalType.text.length == 0) {
      String titleText = "Invalid Sthal/स्थल Type!";
      String contextText = "Please select your 'Sthal/स्थल'...";
      _checkForError(context, titleText, contextText);
    } 
    else if (_astherType.text == "Prabhaag -- प्रभाग" &&
        _defaultDayitva_PrabhagType.text == "") {
      String titleText = "Invalid Prabhag!";
      String contextText = "Please select till Prabhag...";
      _checkForError(context, titleText, contextText);
    } else if (_astherType.text == "Sambhaag -- संभाग" &&
        _defaultDayitva_SambhagType.text == "") {
      String titleText = "Invalid Sambhag!";
      String contextText = "Please select till Sambhag...";
      _checkForError(context, titleText, contextText);
    } else if (_astherType.text == "Bhaag -- भाग" &&
        _defaultDayitva_BhagType.text == "") {
      String titleText = "Invalid Bhag!";
      String contextText = "Please select till Bhag...";
      _checkForError(context, titleText, contextText);
    } else if (_astherType.text == "Anchal -- अंचल" &&
        _defaultDayitva_AnchalType.text == "") {
      String titleText = "Invalid Anchal!";
      String contextText = "Please select till Anchal...";
      _checkForError(context, titleText, contextText);
    } else if (_astherType.text == "Cluster -- क्लस्टर" &&
        _defaultDayitva_ClusterType.text == "") {
      String titleText = "Invalid Cluster!";
      String contextText = "Please select till Cluster...";
      _checkForError(context, titleText, contextText);
    } else if (_astherType.text == "Sanch -- संच" &&
        _defaultDayitva_SanchType.text == "") {
      String titleText = "Invalid Sanch!";
      String contextText = "Please select till Sanch...";
      _checkForError(context, titleText, contextText);
    } else if (_astherType.text == "Sub-Sanch -- उपसंच" &&
        _defaultDayitva_SubSanchType.text == "") {
      String titleText = "Invalid UpSanch!";
      String contextText = "Please select till UpSanch...";
      _checkForError(context, titleText, contextText);
    } else if (_astherType.text == "Village -- गाव" &&
        _defaultDayitva_VillageType.text == "") {
      String titleText = "Invalid Village!";
      String contextText = "Please select till Village...";
      _checkForError(context, titleText, contextText);
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Submitting the Location!\nस्थान जमा करने की प्रक्रिया में।',
            textAlign: TextAlign.center,
          ),
        ),
      );
      setState(() {
        _isSubmitLoadingSpinner = true;
      });

      Provider.of<LocationDetails>(context, listen: false).addLocationDetails(
        context,
        userUniqueIdValue,
        _storedImage,
        DateTime.now().toString(),
        latitudeValue.toString(),
        longitudeValue.toString(),
        addressValue.toString(),
        locationDescriptionValue,
        _sthalType,
        _astherType,
        _defaultDayitva_PrabhagType,
        _defaultDayitva_SambhagType,
        _defaultDayitva_BhagType,
        _defaultDayitva_AnchalType,
        _defaultDayitva_ClusterType,
        _defaultDayitva_SanchType,
        _defaultDayitva_SubSanchType,
        _defaultDayitva_VillageType,
      );
    }
  }

  // _astherType.text == "Prabhaag -- प्रभाग" ? stharPrahagList : _astherType.text == "Sambhaag -- संभाग" ? stharSambhagList : _astherType.text == "Bhaag -- भाग" ? stharBhagList : _astherType.text == "Anchal -- अंचल" ? stharAnchalList : _astherType.text == "Cluster -- क्लस्टर" ? stharClusterList ? _astherType.text == "Sanch -- संच" ? _astherType.text == "Sub-Sanch -- उपसंच" ? stharUpSanchList : stharVillageList

  List<String> returnSthalListType(BuildContext context) {
    if (_astherType.text == "Prabhaag -- प्रभाग") {
      return stharPrahagList;
    } else if (_astherType.text == "Sambhaag -- संभाग") {
      return stharSambhagList;
    } else if (_astherType.text == "Bhaag -- भाग") {
      return stharBhagList;
    } else if (_astherType.text == "Anchal -- अंचल") {
      return stharAnchalList;
    } else if (_astherType.text == "Cluster -- क्लस्टर") {
      return stharClusterList;
    } else if (_astherType.text == "Sanch -- संच") {
      return stharSanchList;
    } else if (_astherType.text == "Sub-Sanch -- उपसंच") {
      return stharUpSanchList;
    } else if (_astherType.text == "Village -- गाव") {
      return stharVillageList;
    } else {
      List<String> lt = ["Select Sthar!"];
      return lt;
    }
  }

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    hierarchyDayitvaList = Provider.of<HardDataDetails>(context, listen: false)
        .getHierarchyDayitvaLocationList();

    setState(() {
      if (_astherType.text == "Prabhaag -- प्रभाग" &&
          !stharPrahagList.contains(_sthalType.text)) {
        _sthalType.text = "";
      } else if (_astherType.text == "Sambhaag -- संभाग" &&
          !stharSambhagList.contains(_sthalType.text)) {
        _sthalType.text = "";
      } else if (_astherType.text == "Bhaag -- भाग" &&
          !stharBhagList.contains(_sthalType.text)) {
        _sthalType.text = "";
      } else if (_astherType.text == "Anchal -- अंचल" &&
          !stharAnchalList.contains(_sthalType.text)) {
        _sthalType.text = "";
      } else if (_astherType.text == "Cluster -- क्लस्टर" &&
          !stharClusterList.contains(_sthalType.text)) {
        _sthalType.text = "";
      } else if (_astherType.text == "Sanch -- संच" &&
          !stharSanchList.contains(_sthalType.text)) {
        _sthalType.text = "";
      } else if (_astherType.text == "Sub-Sanch -- उपसंच" &&
          !stharUpSanchList.contains(_sthalType.text)) {
        _sthalType.text = "";
      } else if (_astherType.text == "Village -- गाव" &&
          !stharVillageList.contains(_sthalType.text)) {
        _sthalType.text = "";
      }
    });

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          margin: EdgeInsets.only(
            left: screenWidth * 0.0125,
            right: screenWidth * 0.0125,
            top: screenHeight * 0.00625,
            bottom: screenHeight * 0.025,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 10,
            child: ListView(
              children: <Widget>[
                _isFloatingButtonActive
                    ? Container(
                        margin: EdgeInsets.symmetric(
                          vertical: useableHeight * 0.35,
                        ),
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: Text(
                          "Identify the Location\n-------------------------------------------\nस्थान की पहचान करें",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : (!_isCurrentLocationTaken || !_isLocationPictureTaken)
                        ? SizedBox(
                            height: 0,
                          )
                        : Container(
                            height: _astherType.text.length == 0
                                ? screenHeight * 1.85
                                : screenHeight * 2.65,
                            width: screenWidth * 0.9,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: useableHeight * 0.015,
                                ),
                                Container(
                                  child: Text(
                                    'Picture of the Location\nस्थान की तस्वीर',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 15,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.01,
                                      vertical: useableHeight * 0.005,
                                    ),
                                    height: useableHeight * 0.45,
                                    width: screenWidth * 0.95,
                                    child: Image.file(
                                      _storedImage,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: useableHeight * 0.02,
                                ),
                                Card(
                                  elevation: 15,
                                  child: Container(
                                    width: screenWidth * 0.9,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.05,
                                      vertical: screenHeight * 0.015,
                                    ),
                                    child: Text(
                                      "Date/दिनांक: ${DateFormat.yMMMd('en_US').format(_picTiming)}.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: useableHeight * 0.0025,
                                ),
                                Card(
                                  elevation: 15,
                                  child: Container(
                                    width: screenWidth * 0.9,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.05,
                                      vertical: screenHeight * 0.015,
                                    ),
                                    child: Text(
                                      "Time/समय: ${DateFormat.jm().format(_picTiming)}.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.0025,
                                ),
                                Card(
                                  elevation: 15,
                                  child: Container(
                                    width: screenWidth * 0.9,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.05,
                                      vertical: screenHeight * 0.015,
                                    ),
                                    child: Text(
                                      "Location Address/स्थान का पता:\n${addressValue.value}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    '\n---------------------------------------\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    'Fill Form Details\nफॉर्म विवरण भरें',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                TextFieldContainer(
                                  context,
                                  "Location Description/स्थान विवरण ",
                                  50,
                                  locationDescriptionValue,
                                  TextInputType.streetAddress,
                                ),
                                SizedBox(
                                  height: screenHeight * 0.01,
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
                                  child: dropDownMenu(
                                    context,
                                    astherTypeList,
                                    _astherType,
                                    "Sthar /स्तर *",
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
                                  child: _astherType.text.length == 0
                                      ? SizedBox(
                                          height: 0,
                                        )
                                      : dropDownMenu(
                                          context,
                                          returnSthalListType(context),
                                          _sthalType,
                                          "Sthal /स्थल *",
                                          false,
                                          () => {},
                                        ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.05,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Container(
                                    child: visibilityForPrabhag
                                            .contains(_astherType.text)
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: screenHeight * 0.004),
                                            child:
                                                dropDownMenuForPrabhagDayitva(
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
                                    child: visibilityForSambhag
                                            .contains(_astherType.text)
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: screenHeight * 0.004),
                                            child:
                                                dropDownMenuForSambhagDayitva(
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
                                    child: visibilityForBhag
                                            .contains(_astherType.text)
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
                                    child: visibilityForAnchal
                                            .contains(_astherType.text)
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
                                    child: visibilityForCluster
                                            .contains(_astherType.text)
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: screenHeight * 0.004),
                                            child:
                                                dropDownMenuForClusterDayitva(
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
                                    child: visibilityForSanch
                                            .contains(_astherType.text)
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
                                    child: visibilityForUpSanch
                                            .contains(_astherType.text)
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: screenHeight * 0.004),
                                            child:
                                                dropDownMenuForUpSanchDayitva(
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
                                    child: visibilityForVillage
                                            .contains(_astherType.text)
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: screenHeight * 0.004),
                                            child:
                                                dropDownMenuForVillageDayitva(
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
                                SizedBox(
                                  height: screenHeight * 0.05,
                                ),
                                Container(
                                  height: useableHeight * 0.075,
                                  padding: EdgeInsets.symmetric(
                                    vertical: useableHeight * 0.001,
                                    horizontal: screenWidth * 0.01,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    vertical: useableHeight * 0.001,
                                    horizontal: screenWidth * 0.0075,
                                  ),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    child: !_isSubmitLoadingSpinner
                                        ? Text(
                                            'Submit the Location\nस्थान जमा करें',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                    onPressed: () {
                                      _submitCapturedLocationInformation(
                                        context,
                                        scaffoldKey,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 20,
        onPressed: _isFloatingButtonActive
            ? () {
                setState(
                  () {
                    _isSpinnerLoading = true;
                    _isFloatingButtonActive = false;
                    _getLocation(
                      context,
                      Provider.of<UserDetails>(context, listen: false)
                          .getLoggedInUserUniqueId()
                          .toString(),
                    );
                  },
                );
              }
            : null,
        label: !_isSpinnerLoading
            ? Text(
                "Capture Image\nछवि कैप्चर करें",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color:
                        _isFloatingButtonActive ? Colors.white : Colors.black),
              )
            : CircularProgressIndicator(
                color: Color.fromARGB(255, 225, 176, 176),
              ),
        icon: Icon(
          Icons.class_,
          color: _isFloatingButtonActive ? Colors.white : Colors.black,
        ),
        backgroundColor:
            _isFloatingButtonActive ? Colors.blueAccent : Colors.grey.shade200,
      ),
    );
  }

  /////////////////////////////////// Location Services ///////////////////////////////////

  _getLocation(BuildContext context, String userUniqueId) async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();

      await FirebaseFirestore.instance
          .collection('location')
          .doc('${userUniqueId}')
          .set(
        {
          'latitude': _locationResult.latitude,
          'lontitude': _locationResult.longitude,
          'name': 'Latitude / Longitude',
        },
        SetOptions(merge: true),
      );

      _getLocationList(context);
    } catch (errorVal) {}
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  _requestPermission() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      print('Live Location status checking!');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  _getLocationList(BuildContext context) async {
    bool serviceEnabled;

    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();

      String titleText = 'Location Services are Disabled';
      String contextText = 'Enable the Location Services.';
      _checkLocatoinService(context, titleText, contextText);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      String titleText = 'Location Services are Disabled';
      String contextText = 'Location Permissions Denied.';
      if (permission == LocationPermission.denied) {
        _checkLocatoinService(context, titleText, contextText);
      }
    }

    String titleText = 'Location Services are Disabled';
    String contextText =
        'Location Permissions Denied Permanently, \nRequest Permissions Halted.';
    if (permission == LocationPermission.deniedForever) {
      _checkLocatoinService(context, titleText, contextText);
    }

    if (!_isCameraOpened) {
      setState(() {
        _isCameraOpened = true;
      });
      _takePicture(context);
    }

    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      latitudeValue.value = '${position.latitude}';
      longitudeValue.value = '${position.longitude}';

      if (!_getAddressFunc) {
        _getAddressFunc = true;
        getAddressFromLatLang(position);
      }
    });
  }

  Future<void> getAddressFromLatLang(Position position) async {
    List<Placemark> placemarkUserLocationList = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    setState(() {
      _isCurrentLocationAccessGiven = true;
      Placemark place = placemarkUserLocationList[0];

      latitudeValue.value = position.latitude.toString();
      longitudeValue.value = position.longitude.toString();

      addressValue.value =
          'Place Name/No: ${place.name},\nStreet: ${place.street},\nArea: ${place.subLocality},\nDistrict: ${place.locality},\nState: ${place.administrativeArea},\nPostal Code: ${place.postalCode},\nAdm. Area: ${place.subAdministrativeArea},\nCountry: ${place.country}.';

      _isCurrentLocationTaken = true;
    });
  }

  ////////////////////////// Class Image ///////////////////////////

  Future<void> _takePicture(BuildContext context) async {
    _picTiming = DateTime.now();
    print(_picTiming);
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 480,
      maxWidth: 640,
    );

    if (imageFile == null) {
      String titleText = "Camera Application Turned Off";
      String contextText = "Please Re-Try Again!";
      _checkForError(context, titleText, contextText);
      setState(() {
        _isFloatingButtonActive = true;
        _isSpinnerLoading = false;
      });
      return;
    }

    setState(() {
      _storedImage = File(imageFile.path);
      _isLocationPictureTaken = true;
      _isSpinnerLoading = false;
      _isClassCreated = true;
    });

    final appDir = await sysPaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final _savedImageFile =
        await File(imageFile.path).copy('${appDir.path}/${fileName}');

    _savedImageFilePath = _savedImageFile.toString();
  }

  //////////////////// Text field Container ///////////////////

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

    return Card(
      elevation: 15,
      child: Container(
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
      ),
    );
  }

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
      if ((obj as dynamic)['PRABHAG'] == '${prabhagName.text}') {
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
}
