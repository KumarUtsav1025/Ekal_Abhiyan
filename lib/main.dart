import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ekal_jaagran/providers/user_details.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/home_screen.dart';
import './screens/new_class_screen.dart';
import './screens/create_class_screen.dart';
import './screens/previous_class_screen.dart';
import './screens/capture_location_screen.dart';
import './screens/my_profile_screen.dart';
import './screens/tabs_screen.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';
import './screens/test.dart';

import './providers/class_details.dart';
import './providers/auth_details.dart';
import './providers/hardData_details.dart';
import './providers/location_details.dart';

// void main() {
//   runApp(const GeeksForGeeks());
// }

// class GeeksForGeeks extends StatelessWidget {
//   const GeeksForGeeks({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Center(child: Text('Hello World')),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  late UserCredential userCred;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ClassDetails(),
        ),
        ChangeNotifierProvider.value(
          value: UserDetails(),
        ),
        ChangeNotifierProvider.value(
          value: AuthDetails(),
        ),
        ChangeNotifierProvider.value(
          value: HardDataDetails(),
        ),
        ChangeNotifierProvider.value(
          value: LocationDetails(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shikshak',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: const ColorScheme.light().copyWith(
            secondary: Colors.amber,
          ),
          canvasColor: const Color.fromRGBO(255, 254, 229, 0.9),
          fontFamily: 'Raleway',
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyLarge: const TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                bodyMedium: const TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                titleLarge: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
        // initialRoute: ,
        // home: TabsScreen(),
        home: StreamBuilder(
          stream: _auth.authStateChanges(),
          builder: (ctx, userSnapShot) {
            if (userSnapShot.hasData) {
              return TabsScreen();
            } else {
              return LoginScreen();
            }
          },
        ),
        // initialRoute: '/',
        routes: {
          // '/': (ctx) => StreamBuilder<User?>(
          //       stream: _auth.authStateChanges(),
          //       builder: (ctx, userSnapShot) {
          //         if (userSnapShot.hasData) {
          //           return TabsScreen();
          //         } else {
          //           return LoginScreen();
          //         }
          //       },
          //     ),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          SignUpScreen.routeName: (ctx) => SignUpScreen(),
          TabsScreen.routeName: (ctx) => TabsScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          NewClassScreen.routeName: (ctx) => NewClassScreen(),
          CreateNewClass.routeName: (ctx) => CreateNewClass(),
          PreviousClass.routeName: (ctx) => PreviousClass(),
          CaptureLocationScreen.routeName: (ctx) => CaptureLocationScreen(),
          MyProfile.routeName: (ctx) => MyProfile(),
          Test.routeName: (ctx) => Test(),
        },
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}
