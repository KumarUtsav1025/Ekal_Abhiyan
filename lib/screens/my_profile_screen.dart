import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyProfile extends StatefulWidget {
  static const routeName = '/my-profile';
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('My Profile'),
    );
  }
}
