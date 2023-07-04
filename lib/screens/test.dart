import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Test());
}

class Test extends StatelessWidget {
  static String routeName = "/test";
  @override
  Widget build(BuildContext context) {
    FirebaseApp firebaseApp = Firebase.app();
    String appName = firebaseApp.name;
    String projectId = firebaseApp.options.projectId;
    print('Firebase App Name: $appName');
    print('Firebase Project ID: $projectId');

    return MaterialApp(
      title: 'Firebase Project Name',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firebase Project Name'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Firebase App Name: $appName'),
              Text('Firebase Project ID: $projectId'),
            ],
          ),
        ),
      ),
    );
  }
}
