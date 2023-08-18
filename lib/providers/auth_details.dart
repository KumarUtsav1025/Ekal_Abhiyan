import 'dart:async';
import 'dart:convert';
// import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthDetails with ChangeNotifier {
  List<String> existingUserPhoneNumberList = [];

  List<String> get getUserPhoneNumberList {
    return [...this.existingUserPhoneNumberList];
  }

  final urlLink = Uri.https(
    'ekal-db-default-rtdb.firebaseio.com',
    '/UsersPhoneNumber.json',
  );

  final urlParse = Uri.parse(
    'https://ekal-db-default-rtdb.firebaseio.com/UsersPhoneNumber.json',
  );

  bool get isPhoneNumberListEmpty {
    if (this.existingUserPhoneNumberList.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> getExistingUserPhoneNumbers() async {
    // var currLoggedInUser = await FirebaseAuth.instance.currentUser;
    // var loggedInUserId = currLoggedInUser?.uid as String;

    final urlLink = Uri.https(
      'ekal-db-default-rtdb.firebaseio.com',
      '/UsersPhoneNumber.json',
    );

    final urlParse = Uri.parse(
      'https://ekal-db-default-rtdb.firebaseio.com/UsersPhoneNumber.json',
    );

    try {
      final dataBaseResponse = await http.get(urlLink);
      final extractedUserPhoneNumbers =
          json.decode(dataBaseResponse.body) as Map<String, dynamic>;

      if (extractedUserPhoneNumbers.length !=
          this.existingUserPhoneNumberList.length) {
        final List<String> phoneNumberList = [];
        extractedUserPhoneNumbers.forEach(
          (phoneId, phoneData) {
            phoneNumberList.add(phoneData['phoneNumber']);
          },
        );

        existingUserPhoneNumberList = phoneNumberList;
        notifyListeners();
      }
    } catch (errorVal) {
      print("Error Value");
      print(errorVal);
    }
  }

  Future<bool> checkIfEnteredNumberExists(
    BuildContext context,
    TextEditingController userPhoneNumber,
  ) async {
    try {
      final dataBaseResponse = await http.get(urlLink);
      final extractedUserPhoneNumbers =
          json.decode(dataBaseResponse.body) as Map<String, dynamic>;

      if (extractedUserPhoneNumbers.length !=
          this.existingUserPhoneNumberList.length) {
        final List<String> phoneNumberList = [];
        extractedUserPhoneNumbers.forEach(
          (phoneId, phoneData) {
            phoneNumberList.add(phoneData['phoneNumber']);
          },
        );

        existingUserPhoneNumberList = phoneNumberList;
        notifyListeners();
      }
    } catch (errorVal) {
      print("Error Value");
      print(errorVal);
    }

    String enteredNumber = userPhoneNumber.text.toString();
    print(existingUserPhoneNumberList);
    print(enteredNumber);

    if (this.existingUserPhoneNumberList.length == 0) {
      return false;
    } else {
      bool isUserPresent = false;

      bool checkForResponse = await Future.forEach(
        this.existingUserPhoneNumberList,
        (phoneNum) {
          if (!isUserPresent && phoneNum.toString() == enteredNumber) {
            isUserPresent = true;
            return true;
          }
        },
      ).then((value) {
        return isUserPresent;
      });

      return checkForResponse;
    }

    // final urlLink = Uri.https(
    //   'ekal-db-default-rtdb.firebaseio.com',
    //   '/UsersPhoneNumber.json',
    // );

    // try {
    //   final dataBaseResponse = await http.get(urlLink);
    //   final extractedUserPhoneNumbers = json.decode(dataBaseResponse.body) as Map<String, dynamic>;

    //   if (extractedUserPhoneNumbers.length == 0) {
    //     return false;
    //   } else {
    //     bool checkForResponse = await Future.forEach(
    //       extractedUserPhoneNumbers,
    //       (phoneElement) => {
    //         print(phoneElement)
    //       },
    //     ).then((value) => false);

    //     return checkForResponse;
    //   }
    // } catch (errorVal) {
    //   print(errorVal);
    // }
  }
}
