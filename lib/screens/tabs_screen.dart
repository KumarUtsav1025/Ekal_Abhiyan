import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ekal_jaagran/providers/class_details.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../constants/stringConst.dart';
import './home_screen.dart';
import './new_class_screen.dart';
import './previous_class_screen.dart';
import './capture_location_screen.dart';
import './my_profile_screen.dart';

import '../providers/user_details.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tab-screen';

  // final UserCredential userCred;
  // TabsScreen(this.userCred);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    _pages = [
      {'page': HomeScreen(), 'title': S.homeTitle},
      {'page': NewClassScreen(), 'title': S.newClassTitle},
      {'page': PreviousClass(), 'title': S.previousClassTitle},
      {'page': CaptureLocationScreen(), 'title': S.captureLocationTitle},
      {'page': MyProfile(), 'title': S.profileTitle},
    ];
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    final iconItems = <Widget>[
      Icon(Icons.home, size: 30),
      Icon(Icons.add_card_rounded, size: 30),
      Icon(Icons.analytics, size: 30),
      Icon(Icons.add_location_alt_rounded, size: 30),
      Icon(Icons.person, size: 30),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pages[_selectedPageIndex]['title'] as String,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: screenWidth*0.05),
            child: GestureDetector(
              onTap: () async {
                String titleText = "Logout";
                String contextText = "Are you sure your want to Logout?";
                _checkForLogout(context, titleText, contextText, popVal: true);
              },
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: _pages[_selectedPageIndex]['page'] as Widget,
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: _selectPage,
      //   backgroundColor: Theme.of(context).primaryColor,
      //   unselectedItemColor: Colors.white,
      //   selectedItemColor: Theme.of(context).accentColor,
      //   currentIndex: _selectedPageIndex,
      //   type: BottomNavigationBarType.fixed,
      //   items: [
      //     BottomNavigationBarItem(
      //       backgroundColor: Theme.of(context).primaryColor,
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       backgroundColor: Theme.of(context).primaryColor,
      //       icon: Icon(Icons.add_card_rounded),
      //       label: 'Create Class',
      //     ),
      //     BottomNavigationBarItem(
      //       backgroundColor: Theme.of(context).primaryColor,
      //       icon: Icon(Icons.analytics),
      //       label: 'Your Classes',
      //     ),
      //     BottomNavigationBarItem(
      //       backgroundColor: Theme.of(context).primaryColor,
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: Colors.white),
        ),
        child: CurvedNavigationBar(
          onTap: _selectPage,
          backgroundColor: Colors.transparent,
          color: Theme.of(context).primaryColor,
          buttonBackgroundColor: Theme.of(context).primaryColor,
          index: 0,
          height: screenHeight * 0.085,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 300),
          items: iconItems,
        ),
      ),
    );
  }

  Future<void> _checkForLogout(
      BuildContext context, String titleText, String contextText,
      {bool popVal = false}) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${titleText}'),
        content: Text('${contextText}'),
        actions: <Widget>[
          ElevatedButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          ElevatedButton(
            child: Text('Yes'),
            onPressed: () {
              Provider.of<ClassDetails>(context, listen: false)
                  .clearClassDetails(context);
              Provider.of<UserDetails>(context, listen: false)
                  .clearStateOfLoggedInUser(context);
              // _auth.signOut();
              // Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
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
              }
            },
          ),
        ],
      ),
    );
  }
}
