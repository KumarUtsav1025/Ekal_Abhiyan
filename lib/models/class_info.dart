import 'dart:io';

// part 'class_info.g.dart';

class ClassInformation {
  final String unqId;
  final String currDateTime;
  final String currTime;
  final String currDate;
  final int numOfStudents;
  final double currLatitude;
  final double currLongitude;
  final String currAddress;
  String classroomUrl;
  final File imageFile;

  ClassInformation({
    required this.unqId,
    required this.currDateTime,
    required this.currTime,
    required this.currDate,
    required this.numOfStudents,
    required this.currLatitude,
    required this.currLongitude,
    required this.currAddress,
    required this.classroomUrl,
    required this.imageFile,
  });
}
