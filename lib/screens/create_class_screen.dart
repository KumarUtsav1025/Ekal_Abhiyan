import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';

import '../constants/stringConst.dart';
import '../screens/tabs_screen.dart';

import '../widgets/live_location.dart';
import '../widgets/image_input.dart';
import '../widgets/stop_watch.dart';

import '../models/place.dart';

import '../providers/class_details.dart';

class CreateNewClass extends StatefulWidget {
  static const routeName = '/create-new-class';
  @override
  State<CreateNewClass> createState() => _CreateNewClassState();
}

class _CreateNewClassState extends State<CreateNewClass> {
  final _numberOfStudents = TextEditingController();
  var _durationOfClass = 1;
  String dateBtnString = S.chooseDateClassCommandText;
  late DateTime _selectedDate;

  bool isDateSet = false;
  bool isNumStudentsFilled = false;
  bool isClassDurationFilled = false;
  bool isCurrentLocSet = false;
  bool isLiveLocationOn = false;
  bool isPic1Clicked = false;
  bool isStopWatchOn = false;
  bool isPic2Clicked = false;

  bool isCard1Visible = true;
  bool isCard2Visible = false;
  bool isCard3Visible = false;
  bool isCard4Visible = false;
  bool isCard5Visible = false;
  bool isCard6Visible = false;
  bool isCard7Visible = false;

  Future<void> _checkCard1Input(BuildContext context) async {
    if (_numberOfStudents.text.length > 0) {
      if (int.parse(_numberOfStudents.text) > 0) {
        isNumStudentsFilled = true;
      } else if (isNumStudentsFilled == true &&
          int.parse(_numberOfStudents.text) <= 0) {
        isNumStudentsFilled = false;
      }
    }

    // Condition checking
    if (!isNumStudentsFilled && !isDateSet) {
      String titleText = S.inputErrText;
      String contextText = S.inputErrSubText1;
      _checkForError(context, titleText, contextText);
    } else if (!isNumStudentsFilled) {
      String titleText = S.inputErrText;
      String contextText = "${S.inputErrSubText1} \n${S.inputErrSubText2}";
      _checkForError(context, titleText, contextText);
    } else if (!isDateSet) {
      String titleText = S.inputErrText;
      String contextText = S.inputErrSubText3;
      _checkForError(context, titleText, contextText);
    } else {
      setState(() {
        isCard2Visible = true;
      });
    }
  }

  Future<void> _checkCard2Input(BuildContext context) async {
    if (isCurrentLocSet == true && isLiveLocationOn == true) {
      setState(() {
        isCard3Visible = true;
      });
    } else if (!isCurrentLocSet && !isLiveLocationOn) {
      String titleText = S.currLivLocationErr;
      String contextText = S.currLivLocationSubErr;
      _checkForError(context, titleText, contextText);
    } else if (!isCurrentLocSet) {
      String titleText = S.currLocationErr;
      String contextText = S.currLocationSubErr;
      _checkForError(context, titleText, contextText);
    } else {
      String titleText = S.livLocationErr;
      String contextText = S.livLocationSubErr;
      _checkForError(context, titleText, contextText);
    }
  }

  Future<void> _checkCard3Input(BuildContext context) async {
    if (isPic1Clicked) {
      setState(() {
        isCard4Visible = true;
      });
    } else {
      String titleText = S.pictureErr;
      String contextText = S.pictureSubErr;
      _checkForError(context, titleText, contextText);
    }
  }

  Future<void> _checkCard4Input(BuildContext context) async {
    if (!isCard5Visible) {
      String titleText = S.onGoingClassErr;
      String contextText = S.onGoingClassSubErr;
      _checkForError(context, titleText, contextText);
    }
  }

  Future<void> _checkCard5Input(BuildContext context) async {
    if (isPic2Clicked) {
      String titleText = S.inputErrText;
      String contextText = S.inputErrSubText1;
      _checkForConfirmation(context, titleText, contextText);
    } else {
      String titleText = S.pictureErr;
      String contextText = S.pictureSubErr;
      _checkForError(context, titleText, contextText);
    }
  }

  Future<void> _checkForConfirmation(
      BuildContext context, String titleText, String contextText) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${titleText}'),
        content: Text('${contextText}'),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          ElevatedButton(
            child: const Text('yes'),
            onPressed: () {
              setState(() {
                isCard6Visible = true;
              });
              Navigator.of(ctx).pop(false);
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
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          isDateSet = true;
          _selectedDate = DateTime.now();
          dateBtnString = S.changeDateClassCommand;
        });
      }
    });
  }

  //////////////////////////////////////////////////////
  bool _isSubmitLoading = false;
  bool _liveLocationDeactive = false;
  late File _pickedImage1;
  late File _pickedImage2;

  void _selectImagePic1(File pickedImg1) {
    _pickedImage1 = pickedImg1;
  }

  void _selectImagePic2(File pickedImg2) {
    _pickedImage2 = pickedImg2;
  }

  static List<Position> userLocationLatLong = [];
  static List<Placemark> userLocationPlaceMarkList = [];

  Future<void> _sumbitNewCreatedClass(BuildContext funcContext) async {
    setState(() {
      _isSubmitLoading = true;
      _liveLocationDeactive = true;
    });
    DateTime finalDateTime = _selectedDate;
    int finalNumStudents = int.parse(_numberOfStudents.text);
    int finalClassDuration = _durationOfClass;

    int l = userLocationPlaceMarkList.length;
    int ll = userLocationLatLong.length;
    String address1 =
        '${userLocationPlaceMarkList[0].subLocality}, ${userLocationPlaceMarkList[0].locality}, ${userLocationPlaceMarkList[0].postalCode}';
    PlaceLocation placeLoc1 = new PlaceLocation(
      latitude: userLocationLatLong[0].latitude,
      longitude: userLocationLatLong[0].longitude,
      address: address1,
    );
    Place placeValue1 = new Place(
      id: DateTime.now().toString(),
      // image: _pickedImage1,
      location: placeLoc1,
      title: S.userInfoText,
    );

    String address2 =
        '${userLocationPlaceMarkList[l - 1].subLocality}, ${userLocationPlaceMarkList[l - 1].locality}, ${userLocationPlaceMarkList[l - 1].postalCode}';
    PlaceLocation placeLoc2 = new PlaceLocation(
      latitude: userLocationLatLong[ll - 1].latitude,
      longitude: userLocationLatLong[ll - 1].longitude,
      address: address2,
    );
    Place placeValue2 = new Place(
      id: '${placeValue1.id} + ${DateTime.now()}',
      // image: _pickedImage2,
      location: placeLoc2,
      title: S.userInfoText,
    );

    List<Position> finalLocList = userLocationLatLong;

    // try {
    //   Provider.of<ClassDetails>(funcContext, listen: false)
    //       .addNewClass(
    //     finalDateTime,
    //     finalNumStudents,
    //     finalClassDuration,
    //     placeValue1,
    //     placeValue2,
    //     finalLocList,
    //   )
    //       .catchError((onError) {
    //     _checkForError(
    //       funcContext,
    //       'Error Occoured',
    //       'Something went Wrong...',
    //       popVal: true,
    //     );
    //   }).then((_) {
    //     setState(() {
    //       _isSubmitLoading = false;
    //     });
    //     Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
    //   });
    // } catch (errorVal) {
    //   print(errorVal);
    //   _checkForError(funcContext, 'Error Detected', 'Something went Wrong...');
    // }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    final classInfoData = Provider.of<ClassDetails>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: topInsets + screenHeight * 0.001,
              left: screenWidth * 0.01,
              right: screenWidth * 0.01,
              bottom: bottomInsets + screenHeight * 0.001,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.005,
                          bottom: screenHeight * 0.005,
                          left: screenWidth * 0.02,
                          right: screenWidth * 0.02,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                isDateSet == false
                                    ? S.selectDateClassCommandText
                                    : 'Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    Colors.black, // Sets the text color
                                backgroundColor: Colors.grey.shade400,
                              ),
                              onPressed: !isCard4Visible
                                  ? () {
                                      _presentDatePicker(context);
                                    }
                                  : null,
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

                      // Input for Number of Students in the Class
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenHeight * 0.01,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                              labelText: S.createClassStudentNumText),
                          controller: _numberOfStudents,
                          keyboardType: TextInputType.number,
                          onSubmitted: (_) {},
                          onChanged: (newCount) {
                            setState(() {
                              if (_numberOfStudents.text.length == 0 ||
                                  int.parse(_numberOfStudents.text) <= 0) {
                                isNumStudentsFilled = false;
                                isCard2Visible = false;
                                _numberOfStudents.text = newCount;
                              }
                            });
                          },
                          readOnly: isCard4Visible ? true : false,
                        ),
                      ),
                    ],
                  ),
                ),
                // End Of Card: number of students, duration of class
                SizedBox(
                  height: screenHeight * 0.02,
                ),

                // Card-2 Starting
                !isCard2Visible
                    ? Column(
                        children: <Widget>[
                          Text(S.createClassFillDetailsText),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          ElevatedButton(
                            child: Text('Next'),
                            onPressed: () {
                              _checkCard1Input(context);
                            },
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.04,
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(bottom: screenHeight * 0.005),
                            child: Text(
                              S.classBeginText,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize: screenHeight * 0.02,
                              ),
                            ),
                          ),

                          // Location of the User
                          LiveLocation(_liveLocationDeactive, (btn1, btn2) {
                            setState(() {
                              isCurrentLocSet = btn1;
                              isLiveLocationOn = btn2;
                            });
                          }, (userLocList) {
                            setState(() {
                              userLocationLatLong = userLocList;
                            });
                          }, (userPlaceMarkList) {
                            setState(() {
                              userLocationPlaceMarkList = userPlaceMarkList;
                            });
                          }),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),

                          // Card-3 Starting
                          !isCard3Visible
                              ? Column(
                                  children: <Widget>[
                                    Text(S.classLocationBeginText),
                                    SizedBox(
                                      height: screenHeight * 0.015,
                                    ),
                                    ElevatedButton(
                                      child: Text('Next'),
                                      onPressed: () {
                                        _checkCard2Input(context);
                                      },
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Text(
                                      S.classPictureBeginText,
                                      textAlign: TextAlign.left,
                                    ),

                                    // 1st Picture of the Classroom
                                    // ImageInput((btnClicked) {
                                    //   setState(() {
                                    //     isPic1Clicked = btnClicked;
                                    //   });
                                    // }),
                                    ImageInput(
                                      isCard4Visible,
                                      (btnClicked) {
                                        setState(() {
                                          isPic1Clicked = btnClicked;
                                        });
                                      },
                                      _selectImagePic1,
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.02,
                                    ),

                                    !isCard4Visible
                                        ? Column(
                                            children: <Widget>[
                                              Text(S.classPictureClickText),
                                              SizedBox(
                                                height: screenHeight * 0.01,
                                              ),
                                              ElevatedButton(
                                                child: Text('Next'),
                                                onPressed: () {
                                                  _checkCard3Input(context);
                                                },
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.005,
                                              ),
                                            ],
                                          )
                                        : Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: screenHeight * 0.03,
                                              ),
                                              Text(S.classDurationText),
                                              SizedBox(
                                                height: screenHeight * 0.02,
                                              ),

                                              // StopWatch
                                              StopWatch(
                                                  (isBtnActive, totTimeInMin) {
                                                setState(() {
                                                  _durationOfClass =
                                                      totTimeInMin;
                                                  isCard5Visible = true;
                                                });
                                              }),
                                              SizedBox(
                                                height: screenHeight * 0.02,
                                              ),

                                              !isCard5Visible
                                                  ? Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: screenHeight *
                                                              0.05),
                                                      child: Text(
                                                        S.classSetDurationText,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    )
                                                  : Column(
                                                      children: <Widget>[
                                                        Text(
                                                          S.classCompleteText,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: screenHeight *
                                                              0.05,
                                                        ),
                                                        Text(
                                                          S.classEndPictureText,
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                        // 2nd Picture of the Classroom
                                                        ImageInput(
                                                          isCard6Visible,
                                                          (btnClicked) {
                                                            setState(() {
                                                              isPic2Clicked =
                                                                  btnClicked;
                                                            });
                                                          },
                                                          _selectImagePic2,
                                                        ),
                                                        SizedBox(
                                                          height: screenHeight *
                                                              0.05,
                                                        ),

                                                        !isCard6Visible
                                                            ? Column(
                                                                children: <Widget>[
                                                                  Text(S
                                                                      .classPictureClickText),
                                                                  SizedBox(
                                                                    height:
                                                                        screenHeight *
                                                                            0.01,
                                                                  ),
                                                                  ElevatedButton(
                                                                    child: Text(
                                                                        'Next'),
                                                                    onPressed:
                                                                        () {
                                                                      _checkCard5Input(
                                                                          context);
                                                                    },
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        screenHeight *
                                                                            0.005,
                                                                  ),
                                                                ],
                                                              )
                                                            :

                                                            // Submit Button
                                                            Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .stretch,
                                                                children: [
                                                                  Container(
                                                                    // padding: EdgeInsets.symmetric(vertical: ),
                                                                    margin: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            screenWidth *
                                                                                0.015,
                                                                        vertical:
                                                                            screenHeight *
                                                                                0.01),
                                                                    child:
                                                                        Material(
                                                                          elevation: 10,
                                                                          child: ElevatedButton(
                                                                            style: ElevatedButton.styleFrom(
                                                                              backgroundColor: Colors.amber,
                                                                            ),
                                                                            onPressed: () {
                                                                              _sumbitNewCreatedClass(context);
                                                                              // Future.delayed(Duration(seconds: 10), () {
                                                                              //   Navigator.of(context)
                                                                              //   .pushReplacementNamed(TabsScreen.routeName);
                                                                              // });
                                                                            },
                                                                            child: _isSubmitLoading
                                                                                ? CircularProgressIndicator()
                                                                                : Text(
                                                                                    'Submit',
                                                                                    style: TextStyle(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: screenHeight * 0.025,
                                                                                    ),
                                                                                  ),
                                                                          ),
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                      ],
                                                    ),
                                            ],
                                          ),
                                  ],
                                ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
