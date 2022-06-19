import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/providers/user_details.dart';
import 'package:flutter_complete_guide/screens/tabs_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPaths;
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:ui' as ui;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import '../providers/auth_details.dart';
import '../providers/class_details.dart';
import '../providers/user_details.dart';
import '../providers/hardData_details.dart';
import '../providers/location_details.dart';

import '../screens/tabs_screen.dart';
import '../models/visitor_info.dart';

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

  TextEditingController userUniqueIdValue = TextEditingController();

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

    userUniqueIdValue.text = Provider.of<UserDetails>(context, listen: false).getLoggedInUserUniqueId();
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
    if (true) {

    }
    else {
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

      // Provider.of<LocationDetails>(context, listen: false)
      //     .addLocationDetails(
      //       context,
      //       visitorName.text,
      //       visitorMobileNumber.text,
      //       visitorDayitva.text,
      //       visitorAddressTypeValue.text,
      //       defaultStateValue.text,
      //       defaultRegionValue.text,
      //       defaultDistrictValue.text,
      //       defaultAnchalValue.text,
      //       defaultSankulValue.text,
      //       defaultClusterValue.text,
      //       defaultSubClusterValue.text,
      //       defaultVillageValue.text,
      //       userUniqueIdValue.text,
      //       _storedImage,
      //       DateTime.now().toString(),
      //       latitudeValue.toString(),
      //       longitudeValue.toString(),
      //       addressValue.toString(),
      //     ).then((value) => Navigator.of(context).pushReplacementNamed(TabsScreen.routeName));
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

    ekalList = Provider.of<HardDataDetails>(context, listen: false)
        .getEkalLocationCategoryList();
    
    hierarchyDayitvaList = Provider.of<HardDataDetails>(context, listen: false)
        .getHierarchyDayitvaLocationList();

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
                            height: screenHeight * 3.1,
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
                                  height: screenHeight * 0.03,
                                ),
                                // Container(
                                //   height: useableHeight * 0.075,
                                //   padding: EdgeInsets.symmetric(
                                //     vertical: useableHeight * 0.001,
                                //     horizontal: screenWidth * 0.01,
                                //   ),
                                //   margin: EdgeInsets.symmetric(
                                //     vertical: useableHeight * 0.001,
                                //     horizontal: screenWidth * 0.0075,
                                //   ),
                                //   width: double.infinity,
                                //   child: ElevatedButton(
                                //     child: !_isSubmitLoadingSpinner
                                //         ? Text(
                                //             'Submit the Location\nस्थान जमा करें',
                                //             textAlign: TextAlign.center,
                                //             style: TextStyle(
                                //               fontWeight: FontWeight.bold,
                                //             ),
                                //           )
                                //         : CircularProgressIndicator(
                                //             color: Colors.white,
                                //           ),
                                //     onPressed: () {
                                //       _submitCapturedLocationInformation(
                                //         context,
                                //         scaffoldKey,
                                //       );
                                //     },
                                //   ),
                                // ),
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
