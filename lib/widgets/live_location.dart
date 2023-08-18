// ignore_for_file: dead_code

import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

import './live_map.dart';

class LiveLocation extends StatefulWidget {
  static const routeName = '/live-location';

  final isSubmitted;

  Function(bool, bool) checkUserLocation;
  Function(List<Position>) userLoctionList;
  Function(List<Placemark>) userLocPlaceMarkList;

  LiveLocation(
    this.isSubmitted,
    this.checkUserLocation,
    this.userLoctionList,
    this.userLocPlaceMarkList,
  );

  @override
  State<LiveLocation> createState() => _LiveLocationState();
}

class _LiveLocationState extends State<LiveLocation> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  bool isCurrLocBtnActive = false;
  bool isLiveLocBtnActive = false;

  var startLocLatitude = "";
  var startLocLongitude = "";
  var startLocAddress = "";

  var latitudeValue = 'Getting Latitude...'.obs;
  var longitudeValue = 'Getting Longitude...'.obs;
  var addressValue = 'Getting Address...'.obs;
  late StreamSubscription<Position> streamSubscription;

  static List<Placemark> placemarkUserLocationList = [];
  static List<Position> userLatLongList = [];
  int locListLgt = placemarkUserLocationList.length;
  int posListLgt = userLatLongList.length;

  

  Future<void> _checkLocatoinService(
      BuildContext context, String titleText, String contextText) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${titleText}'),
        content: Text('${contextText}'),
        actions: <Widget>[
          ElevatedButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.isSubmitted == true) {
      _stopListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 5,
      child: Container(
        height: screenHeight * 0.3,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.01,
                vertical: screenHeight * 0.005,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                        left: screenWidth * 0.005,
                        top: screenHeight * 0.002,
                      ),
                      child: Text(
                        'Add Current \nLocation',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue.shade500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    onPressed: !isCurrLocBtnActive
                        ? () {
                            isCurrLocBtnActive = true;
                            widget.checkUserLocation(
                              isCurrLocBtnActive,
                              isLiveLocBtnActive,
                            );
                            _getLocation(context);
                          }
                        : null,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                        right: screenWidth * 0.005,
                        top: screenHeight * 0.002,
                      ),
                      child: Text(
                        'Start Live \nLocation',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue.shade500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    onPressed: !isLiveLocBtnActive
                        ? () {
                            isLiveLocBtnActive = true;
                            widget.checkUserLocation(
                                isCurrLocBtnActive, isLiveLocBtnActive);
                            _listenLocation();
                          }
                        : null,
                  ),
                ],
              ),
            ),
            Container(
              child: Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('location')
                      .snapshots(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            snapshot.data!.docs[index]['name'].toString(),
                          ),
                          subtitle: Row(
                            children: <Widget>[
                              Text(snapshot.data!.docs[index]['latitude']
                                  .toString()),
                              SizedBox(
                                width: screenHeight * 0.01,
                              ),
                              Text(
                                snapshot.data!.docs[index]['longitude']
                                    .toString(),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.directions),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MyMap(snapshot.data!.docs[index].id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            !isCurrLocBtnActive
                ? Text('')
                : Container(
                    height: screenHeight * 0.04,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.002,
                      horizontal: screenWidth * 0.001,
                    ),
                    child: Text(
                      '${addressValue.value}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  _getLocation(BuildContext context) async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();

      await FirebaseFirestore.instance.collection('location').doc('user1').set(
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

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();

      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentLocation) async {
      await FirebaseFirestore.instance.collection('location').doc('user1').set(
        {
          'latitude': currentLocation.latitude,
          'longitude': currentLocation.longitude,
          'name': 'Latitude / Longitude',
        },
        SetOptions(merge: true),
      );
    });
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
      print('Stopped Live Location!');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
  ///////////////////////////////////////////////

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

    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      latitudeValue.value = '${position.latitude}';
      longitudeValue.value = '${position.longitude}';

      setState(() {
        if (userLatLongList.length == 0) {
          userLatLongList.add(position);
          widget.userLoctionList(userLatLongList);
        } else {
          if (!userLatLongList.contains(position)) {
            userLatLongList.add(position);
            widget.userLoctionList(userLatLongList);

            int l = 0;
            double lgt = 0.0;
            double latitude1 = 0.0,
                longitude1 = 0.0,
                latitude2 = 0.0,
                longitude2 = 0.0;
            double dlat = 0.0, dlong = 0.0;
            double radius = 6371.0; // km

            if (userLatLongList.length <= 1) {
              return;
            }

            double factorVal = 0.01744533;
            l = userLatLongList.length;
            latitude1 = userLatLongList[0].latitude;
            longitude1 = userLatLongList[0].longitude;
            latitude2 = userLatLongList[l - 1].latitude;
            longitude2 = userLatLongList[l - 1].longitude;
            dlat = factorVal * (latitude2 - latitude1);
            dlong = factorVal * (longitude2 - longitude1);

            double a = 0.0, c = 0.0, d = 0.0;
            a = (sin(dlat / 2) * sin(dlat / 2)) +
                cos(factorVal * latitude1) *
                    cos(factorVal * latitude2) *
                    sin(dlong / 2) *
                    sin(dlong / 2);
            c = 2 * atan2(sqrt(a), sqrt(1 - a));

            d = radius * c;

            if (d > 0.150) {
              _checkLocatoinService(
                  context, "Out of Range", "Kindly go back to the Classroom.");
            }
          }
        }
      });

      getAddressFromLatLang(position);
    });
  }

  Future<void> getAddressFromLatLang(Position position) async {
    placemarkUserLocationList = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    setState(() {
      Placemark place = placemarkUserLocationList[0];
      addressValue.value =
          'Address: ${place.subLocality}, ${place.locality}, ${place.postalCode}.';

      widget.userLocPlaceMarkList(placemarkUserLocationList);
    });
  }
}
