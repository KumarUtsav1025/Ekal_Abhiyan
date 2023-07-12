// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/user_details.dart';
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
import 'dart:ui' as ui;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/stringConst.dart';
import '../screens/tabs_screen.dart';

import '../widgets/live_location.dart';
import '../widgets/image_input.dart';
import '../widgets/stop_watch.dart';

import '../models/class_info.dart';
import '../models/place.dart';
import '../models/http_exeception.dart';

import '../providers/class_details.dart';
import '../providers/class_details.dart';

class NewClassScreen extends StatefulWidget {
  static const routeName = '/new-class-screen';

  @override
  State<NewClassScreen> createState() => _NewClassScreenState();
}

class _NewClassScreenState extends State<NewClassScreen> {
  bool _isFloatingButtonActive = true;
  bool _isSpinnerLoading = false;
  bool _isCurrentLocationAccessGiven = false;
  bool _isCurrentLocationTaken = false;
  bool _isCameraOpened = false;
  bool _isClassPictureTaken = false;
  bool _isSubmitLoadingSpinner = false;
  bool _getAddressFunc = false;
  bool _isClassCreated = false;

  bool _numberStudents = false;
  TextEditingController numStudents = new TextEditingController();

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
  List<Face> _faces = [];
  bool isLoading = false;
  late ui.Image _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _requestPermission();
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

  Future<void> _submitTheClassInformation(
    BuildContext context,
    GlobalKey<ScaffoldState> sKey,
  ) async {
    ClassInformation classInfo = new ClassInformation(
      unqId: DateTime.now().toString() + _picTiming.toString(),
      currDateTime: _picTiming.toString(),
      currTime: DateFormat.jm().format(_picTiming).toString(),
      currDate: DateFormat.yMMMd('en_US').format(_picTiming).toString(),
      numOfStudents: _numberOfStudents,
      currLatitude: double.parse(latitudeValue.value),
      currLongitude: double.parse(longitudeValue.value),
      currAddress: addressValue.value,
      classroomUrl: "",
      imageFile: _storedImage,
    );

    if (int.tryParse(numStudents.text) == null) {
      String titleText = S.invalidStudentCountErr;
      String contextText = S.invalidStudentCountErrSub;
      _checkForError(context, titleText, contextText);
    } else if (int.parse(numStudents.text) < 0) {
      String titleText = S.invalidStudentCountErr;
      String contextText = S.invalidStudentCountErrSub;
      _checkForError(context, titleText, contextText);
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(S.classSubmitText),
        ),
      );
      setState(() {
        _isSubmitLoadingSpinner = true;
      });

      try {
        Provider.of<ClassDetails>(context, listen: false)
            .addNewClass(classInfo, _storedImage, numStudents)
            .catchError((onError) {
          print(onError);
          _checkForError(
            context,
            S.errorTitle,
            S.errorSub,
            popVal: true,
          );
        }).then((_) {
          // Scaffold.of(context).showSnackBar(
          //     SnackBar(content: Text('Class Submitted Successfully!')));
          setState(() {
            _isFloatingButtonActive = true;
            _isSpinnerLoading = false;
            _isCurrentLocationAccessGiven = false;
            _isCurrentLocationTaken = false;
            _isCameraOpened = false;
            _isClassPictureTaken = false;
            _isSubmitLoadingSpinner = false;
            _getAddressFunc = false;

            _isSubmitLoadingSpinner = false;
          });

          // Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/tab-screen", (route) => false);
        });
      } catch (errorVal) {
        _checkForError(context, S.errorTitle, S.errorSub);
      }
    }
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

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

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
                          S.newClassScreenBodyText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : (!_isCurrentLocationTaken || !_isClassPictureTaken)
                        ? SizedBox(
                            height: 0,
                          )
                        : Container(
                            height: screenHeight * 1.5,
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
                                    S.newClassPicText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 5,
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
                                  height: useableHeight * 0.01,
                                ),
                                TextFieldContainer(
                                  context,
                                  S.newClassStudentNumText,
                                  3,
                                  numStudents,
                                  TextInputType.number,
                                ),
                                SizedBox(
                                  height: useableHeight * 0.02,
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
                                            S.newClassSubmitText,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                    onPressed: () {
                                      _submitTheClassInformation(
                                        context,
                                        scaffoldKey,
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: useableHeight * 0.02,
                                ),
                                Container(
                                  child: Text(
                                    "Date/दिनांक: ${DateFormat.yMMMd('en_US').format(_picTiming)}.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: useableHeight * 0.02,
                                ),
                                Container(
                                  child: Text(
                                    "Time/समय: ${DateFormat.jm().format(_picTiming)}.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: useableHeight * 0.02,
                                ),
                                Container(
                                  child: Text(
                                    "${S.newClassStudentNumText} ${_numberOfStudents}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: useableHeight * 0.02,
                                ),
                                Container(
                                  child: Text(
                                    "--------------------------------------------\n${S.newClassAddressTitle} \n\n${addressValue.value}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: useableHeight * 0.1,
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
                S.newClassPicClickText,
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

      String titleText = S.locationErrText;
      String contextText = S.locationErrSubText1;
      _checkLocatoinService(context, titleText, contextText);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      String titleText = S.locationErrText;
      String contextText = S.locationErrSubText2;
      if (permission == LocationPermission.denied) {
        _checkLocatoinService(context, titleText, contextText);
      }
    }

    String titleText = S.locationErrText;
    String contextText = S.locationErrSubText3;

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
      String titleText = S.cameraErrText;
      String contextText = S.cameraSubText;
      _checkForError(context, titleText, contextText);
      setState(() {
        _isFloatingButtonActive = true;
        _isSpinnerLoading = false;
      });
      return;
    }

    setState(() {
      _storedImage = File(imageFile.path);
      _isClassPictureTaken = true;
      _isSpinnerLoading = false;
      _isClassCreated = true;
    });

    final appDir = await sysPaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final _savedImageFile =
        await File(imageFile.path).copy('${appDir.path}/${fileName}');

    _savedImageFilePath = _savedImageFile.toString();
    _getImage(context);
  }

  ////////////////////////// Number of Faces in the Image ///////////////////////////

  _getImage(BuildContext context) async {
    final imageFile = _storedImage;
    setState(() {
      isLoading = true;
    });

    final image = FirebaseVisionImage.fromFile(File(imageFile.path));
    final faceDetector = FirebaseVision.instance.faceDetector();
    List<Face> faces = await faceDetector.processImage(image);

    if (mounted) {
      setState(() {
        _imageFile = File(imageFile.path);
        _faces = faces;
        _loadImage(File(imageFile.path));
      });
    }
  }

  _loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then(
      (value) => setState(
        () {
          _image = value;
          isLoading = false;
          _numberOfStudents = _faces.length;
        },
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  final ui.Image image;
  final List<Face> faces;
  final List<Rect> rects = [];

  FacePainter(this.image, this.faces) {
    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.yellow;

    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      canvas.drawRect(rects[i], paint);
    }
  }

  @override
  bool shouldRepaint(FacePainter old) {
    return image != old.image || faces != old.faces;
  }
}
