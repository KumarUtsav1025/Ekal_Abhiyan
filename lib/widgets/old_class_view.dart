import 'package:flutter/material.dart';
import '../models/class_info.dart';
import '../screens/detail_class_screen.dart';

class OldClassView extends StatelessWidget {
  @required
  int indexClass1;
  @required
  int indexClass2;
  @required
  ClassInformation infoClass1;
  @required
  ClassInformation infoClass2;

  OldClassView({
    required this.indexClass1,
    required this.indexClass2,
    required this.infoClass1,
    required this.infoClass2,
  });

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var avlScreenHeight = screenHeight - topInsets - bottomInsets;

    void _goToDetailClassScreen(
      BuildContext ctx,
      ClassInformation classInfoObj1,
      ClassInformation classInfoObj2,
    ) {
      Navigator.of(ctx).push(
        MaterialPageRoute(
          builder: (_) {
            return ClassDetailScreen(
              detailInfoClass1: classInfoObj1,
              detailInfoClass2: classInfoObj2,
            );
          },
        ),
      );
    }

    return InkWell(
      onTap: () {
        _goToDetailClassScreen(context, infoClass1, infoClass2);
      },
      splashColor: Theme.of(context).primaryColorDark,

      ////////////
      child: Card(
        elevation: 10,
        margin: EdgeInsets.only(
          top: avlScreenHeight * 0.015,
          bottom: avlScreenHeight * 0.005,
          left: screenWidth * 0.025,
          right: screenWidth * 0.025,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: screenWidth * 0.05,
            right: screenWidth * 0.15,
            top: screenHeight * 0.02,
            bottom: screenHeight * 0.02,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: screenWidth * 0.1,
                child: Container(
                  padding: EdgeInsets.all(
                    screenWidth * 0.01,
                  ),
                  child: FittedBox(
                    child: Icon(
                      Icons.open_in_new_rounded,
                      size: screenWidth * 0.40,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Text('Students: ${infoClass.numOfStudents}'),
                  // Text('Duration: ${classDuration}'),
                  // Text(
                  //   'Date: ${DateFormat('dd/MM/yyyy').format(infoClass.currDateTime)}',
                  // ),
                  Text("Date: ${infoClass1.currDate}"),
                  Text("Starting Time: ${infoClass1.currTime}"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
