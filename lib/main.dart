// ignore_for_file: deprecated_member_use
import 'dart:math';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import './screens/home_screen.dart';
import './screens/create_class_screen.dart';
import './screens/previous_class_screen.dart';
import './screens/my_profile_screen.dart';
import './screens/tabs_screen.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';
import './screens/detail_class_screen.dart';

import './providers/class_details.dart';

import './widgets/live_location.dart';

// void main() => runApp(MyApp());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ClassDetails(),
        ),
      ],
      child: MaterialApp(
        title: 'Instructor Monitor',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.amber,
          canvasColor: Color.fromRGBO(255, 254, 229, 0.9),
          fontFamily: 'Raleway',
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1: TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                bodyText2: TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                headline6: TextStyle(
                  fontSize: 18,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
        // initialRoute: ,
        home: LoginScreen(),
        routes: {
          LoginScreen.routeName: (ctx) => LoginScreen(),
          SignUpScreen.routeName: (ctx) => SignUpScreen(),
          TabsScreen.routeName: (ctx) => TabsScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          CreateNewClass.routeName: (ctx) => CreateNewClass(),
          PreviousClass.routeName: (ctx) => PreviousClass(),
          MyProfile.routeName: (ctx) => MyProfile(),
        },
      ),
    );
  }
}
