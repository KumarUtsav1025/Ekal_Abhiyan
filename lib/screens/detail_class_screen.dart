import 'package:flutter/material.dart';
import '../models/class_info.dart';

class ClassDetailScreen extends StatelessWidget {
  static const routeName = '/class-detail-screen';

  final ClassInformation detailInfoClass1;
  final ClassInformation detailInfoClass2;
  ClassDetailScreen({
    required this.detailInfoClass1,
    required this.detailInfoClass2,
  });

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var avlScreenHeight = screenHeight - topInsets - bottomInsets;

    bool _isCompleteInfo = false;
    if (detailInfoClass2.unqId.length != 0) {
      _isCompleteInfo = true;
    }

    String classDuration = "";
    int minVal = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Class Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.005,
            horizontal: screenWidth * 0.01,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              !_isCompleteInfo
                  ? partialInfoWidget(
                      context,
                      detailInfoClass1,
                    )
                  : completeInfoWidget(
                      context,
                      detailInfoClass1,
                      detailInfoClass2,
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget partialInfoWidget(BuildContext ctx, ClassInformation classInfo1) {
    var screenHeight = MediaQuery.of(ctx).size.height;
    var screenWidth = MediaQuery.of(ctx).size.width;
    var topInsets = MediaQuery.of(ctx).viewInsets.top;
    var bottomInsets = MediaQuery.of(ctx).viewInsets.bottom;
    var usableHeight = screenHeight - topInsets - bottomInsets;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: screenHeight * 0.005,
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.01,
          ),
          width: double.infinity,
          child: Text(
            "Starting of the Class:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenHeight * 0.025,
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.0075,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Card(
            elevation: 10,
            child: Container(
              alignment: Alignment.center,
              width: screenWidth * 0.9,
              height: usableHeight * 0.45,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.045,
                vertical: screenHeight * 0.02,
              ),
              child: Image.network(
                classInfo1.classroomUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.04,
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            "Class Details",
            style: TextStyle(
              fontSize: screenHeight * 0.05,
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.01,
        ),
        Card(
          elevation: 5,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.1,
            ),
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.001,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Number Of Students: ${classInfo1.numOfStudents}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Card(
          elevation: 5,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.1,
            ),
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.001,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
            ),
            child: Text(
              "Date: ${classInfo1.currDate}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Card(
          elevation: 5,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.1,
            ),
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.001,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
            ),
            child: Text(
              "Starting Time: ${classInfo1.currTime}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Card(
          elevation: 5,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.1,
            ),
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.001,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
            ),
            child: Text(
              "Location  Details: \n\n${classInfo1.currAddress}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.025,
        ),
      ],
    );
  }

  Widget completeInfoWidget(
    BuildContext ctx,
    ClassInformation classInfo1,
    ClassInformation classInfo2,
  ) {
    var screenHeight = MediaQuery.of(ctx).size.height;
    var screenWidth = MediaQuery.of(ctx).size.width;
    var topInsets = MediaQuery.of(ctx).viewInsets.top;
    var bottomInsets = MediaQuery.of(ctx).viewInsets.bottom;
    var usableHeight = screenHeight - topInsets - bottomInsets;

    DateTime t1 = DateTime.parse(classInfo1.currDateTime);
    DateTime t2 = DateTime.parse(classInfo2.currDateTime);

    final diff_dy = t2.difference(t1).inDays;
    final diff_hr = t2.difference(t1).inHours;
    final diff_mn = t2.difference(t1).inMinutes;
    final rmn_mn = diff_mn - (diff_hr*60);

    String classDuration = "";
    if (diff_hr == 0) {
      classDuration = "${diff_mn} min";
    } else if (diff_mn == 0) {
      classDuration = "${diff_hr} hr";
    } else {
      classDuration = "${diff_hr} hr ${rmn_mn} min";
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: screenHeight * 0.005,
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.01,
          ),
          width: double.infinity,
          child: Text(
            "Starting of the Class:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenHeight * 0.025,
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.0075,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Card(
            elevation: 10,
            child: Container(
              alignment: Alignment.center,
              width: screenWidth * 0.9,
              height: usableHeight * 0.45,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.045,
                vertical: screenHeight * 0.02,
              ),
              child: Image.network(
                classInfo1.classroomUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.04,
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            "Class Details - 1",
            style: TextStyle(
              fontSize: screenHeight * 0.05,
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.01,
        ),
        Card(
          elevation: 5,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.1,
            ),
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.001,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Number Of Students: ${classInfo1.numOfStudents}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Card(
          elevation: 5,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.1,
            ),
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.001,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
            ),
            child: Text(
              "Date: ${classInfo1.currDate}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Card(
          elevation: 5,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.1,
            ),
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.001,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
            ),
            child: Text(
              "Starting Time: ${classInfo1.currTime}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Card(
          elevation: 5,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.1,
            ),
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.001,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
            ),
            child: Text(
              "Location  Details: \n\n${classInfo1.currAddress}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.025,
        ),
        Container(
            child: Divider(
          color: Colors.black,
        )),
        SizedBox(
          height: screenHeight * 0.025,
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.01,
          ),
          width: double.infinity,
          child: Text(
            "Ending of the Class:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenHeight * 0.025,
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.0075,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Card(
            elevation: 10,
            child: Container(
              alignment: Alignment.center,
              width: screenWidth * 0.9,
              height: usableHeight * 0.45,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.045,
                vertical: screenHeight * 0.02,
              ),
              child: Image.network(
                classInfo2.classroomUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.04,
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            "Class Details - 2",
            style: TextStyle(
              fontSize: screenHeight * 0.05,
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.01,
        ),
        Card(
          elevation: 5,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.1,
            ),
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.001,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Number Of Students: ${classInfo2.numOfStudents}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Card(
          elevation: 5,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.1,
            ),
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.001,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
            ),
            child: Text(
              "Date: ${classInfo2.currDate}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Card(
          elevation: 5,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.1,
            ),
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.001,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
            ),
            child: Text(
              "Ending Time: ${classInfo2.currTime}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Card(
          elevation: 5,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.1,
            ),
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.001,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
            ),
            child: Text(
              "Location  Details: \n\n${classInfo2.currAddress}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.025,
        ),
        Container(
          child: Divider(
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: screenHeight * 0.025,
        ),
        Card(
          elevation: 5,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.1,
            ),
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.005,
              horizontal: screenWidth * 0.001,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
            ),
            child: Text(
              "Class Duration: \n${classDuration}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenHeight * 0.025,
                decoration: TextDecoration.underline,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.01,
        ),
      ],
    );
  }
}
