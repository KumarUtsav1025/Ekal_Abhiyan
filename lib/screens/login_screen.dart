import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'com.google.firebase.database.ValueEventListener';

import './signup_screen.dart';

import '../providers/auth_details.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login-screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final ekalVidyalayaImage = 'assets/images/Ekal-Vidyalaya.jpg';
  final aurigaCareImage = 'assets/images/ac_logo.png';
  late AnimationController _animeController;
  late Animation<Size> _heightAnimation;
  FirebaseAuth _auth = FirebaseAuth.instance;

  // Define a boolean flag to indicate if the widget is still mounted
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    Provider.of<AuthDetails>(context, listen: false)
        .getExistingUserPhoneNumbers();
  }

  @override
  void dispose() {
    // Set the flag to false when the widget is being disposed
    _isMounted = false;
    super.dispose();
  }

  bool _isOtpSent = false;
  bool _isAuthenticationAccepted = false;
  bool _showLoading = false;
  bool _userVerified = false;
  bool _userExists = false;
  bool _signInClicked = false;
  bool _submitOtpClicked = false;

  String _verificationId = "";
  TextEditingController _userPhoneNumber = TextEditingController();
  TextEditingController _userOtpValue = TextEditingController();
  TextEditingController _otpValue = TextEditingController();

  Future<void> _checkIfUserExists(BuildContext context) async {
    // var currLoggedInUser = await FirebaseAuth.instance.currentUser;
    // var loggedInUserId = currLoggedInUser?.uid as String;
    // DatabaseReference rootRef = await FirebaseDatabase.instance.reference();
    // DatabaseReference uidRef = rootRef.child("UsersPhoneNumber").child(loggedInUserId);
    // final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: '');
  }

  Future<void> _userSignIn(
    BuildContext context,
    TextEditingController userPhoneNumber,
  ) async {
    if (userPhoneNumber.text.length != 10) {
      String titleText = "Invild Mobile Number";
      String contextText = "Please Enter a Valid 10 Digit Number!";
      _checkForError(context, titleText, contextText);
    } else if (int.tryParse(userPhoneNumber.text) == null) {
      String titleText = "Invild Mobile Number";
      String contextText = "Entered Number is Not Valid!";
      _checkForError(context, titleText, contextText);
    } else if (int.parse(userPhoneNumber.text) < 0) {
      String titleText = "Invild Mobile Number";
      String contextText = "Mobile Number Cannot be Negative!";
      _checkForError(context, titleText, contextText);
    } else {
      // to bypass login
      // Navigator.of(context).pushNamedAndRemoveUntil("/test", (route) => false);
      // bypass login ends

      String titleText = "Authentication";
      String contextText = "Enter the Otp:";
      _checkIfUserExists(context);
      _enterUserOtp(context, titleText, contextText);

      if ((await Provider.of<AuthDetails>(context, listen: false)
              .checkIfEnteredNumberExists(context, userPhoneNumber)) ==
          true) {
        // if ((await Provider.of<AuthDetails>(context, listen: false)
        //         .checkIfEnteredNumberExists(context, userPhoneNumber)) ==
        //     true) {
        print('User Already Exists!');

        setState(() {
          _showLoading = true;
          _signInClicked = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Verifying your Phone Number..."),
          ),
        );

        _checkForAuthentication(context, _userPhoneNumber);
      } else {
        print("New User!");

        String titleText = "New User";
        String contextText =
            "Please Create your Account!\nकृपया अपना खाता बनाएं।";
        _checkForError(context, titleText, contextText);
      }
    }
  }

  // Future<void> _otpVerification(BuildContext context)
  Future<void> openOtpWidget() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Otp Sent!"),
      ),
    );

    String titleText = "Mobile Authentication";
    String contextText = "Enter the Otp:";
    _enterUserOtp(context, titleText, contextText);
  }

  Future<void> _enterUserOtp(
    BuildContext context,
    String titleText,
    String contextText,
  ) async {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${titleText}'),
        content: Text('${contextText}'),
        actions: <Widget>[
          Container(
            height: screenHeight * 0.2,
            width: screenWidth * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            margin: EdgeInsets.all(screenWidth * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  maxLength: 6,
                  decoration: InputDecoration(labelText: 'Enter the OTP: '),
                  controller: _userOtpValue,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) {},
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.5),
              ),
              backgroundColor: Colors.blue.shade400,
            ),
            onPressed: () async {
              PhoneAuthCredential phoneAuthCredential =
                  PhoneAuthProvider.credential(
                verificationId: this._verificationId,
                smsCode: _userOtpValue.text,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text("Verifying the Entered Otp..."),
                ),
              );
              signInWithPhoneAuthCred(context, phoneAuthCredential);
              Navigator.of(ctx).pop(false);
            },
            child: Text('Submit Otp'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkForAuthentication(
    BuildContext context,
    TextEditingController phoneController,
  ) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: "+91${phoneController.text}",

      // Setting the Otp Timeout Duration
      timeout: Duration(seconds: 60),

      // After the Authentication has been Completed Successfully
      verificationCompleted: (phoneAuthCredential) async {
        setState(() {
          _isAuthenticationAccepted = true;
          print('auth successful');
        });
        // signInWithPhoneAuthCred(context, phoneAuthCredential);
      },

      // After the Authentication has been Failed/Declined
      verificationFailed: (verificationFailed) async {
        setState(() {
          _isOtpSent = false;
          _isAuthenticationAccepted = false;
          _showLoading = false;
          _signInClicked = false;
          _submitOtpClicked = false;
        });
        print('verification failed');
        print(verificationFailed);

        const String titleText = "Authenticatoin Failed!";
        const String contextText = "Unable to generate the OTP.";
        _checkForError(context, titleText, contextText);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(contextText),
          ),
        );
      },

      // After the OTP has been sent to Mobile Number Successfully
      codeSent: (verificationId, resendingToken) async {
        print('otp sent');
        openOtpWidget();

        setState(() {
          _isOtpSent = true;
          _isAuthenticationAccepted = false;
          _showLoading = false;

          this._verificationId = verificationId;
        });
      },

      // After the Otp Timeout period
      codeAutoRetrievalTimeout: (verificationID) async {
        if (_isMounted) {
          // Check if the widget is still mounted
          try {
            setState(() {
              _isOtpSent = false;
              _isAuthenticationAccepted = false;
              _showLoading = false;
              _signInClicked = false;
            });
          } catch (error) {
            print("OTP TIMEOUT ERROR");
            print(error);
          }

          if (!_userVerified) {
            String titleText = "Authenticatoin Timeout!";
            String contextText = "Please Re-Try Again";
            _checkForError(context, titleText, contextText);
          }
        }
      },
    );
  }

  void signInWithPhoneAuthCred(
    BuildContext context,
    PhoneAuthCredential phoneAuthCredential,
  ) async {
    setState(() {
      _showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        _showLoading = false;
      });

      if (authCredential.user != null) {
        print('authentication complete!');
        setState(() {
          _userVerified = true;
          _isOtpSent = false;
          _isAuthenticationAccepted = false;
          _showLoading = false;
          _userExists = false;
          _signInClicked = false;
          _submitOtpClicked = false;
        });

        // Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/tab-screen", (route) => false);
      }
    } on FirebaseAuthException catch (errorVal) {
      print(errorVal);

      if (_isOtpSent) {
        setState(() {
          _signInClicked = false;
          _submitOtpClicked = false;
          _showLoading = false;
        });

        String titleText = "Authentication Failed!";
        String contextText =
            "Entered Otp is InValid!\nदर्ज किया गया ओटीपी अमान्य है।";
        _checkForError(context, titleText, contextText);

        print(errorVal.message);
      }
    }
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white70,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: screenHeight * 0.045,
              ),
              Container(
                // decoration: BoxDecoration(color: Colors.blue),
                child: Image.asset(
                  ekalVidyalayaImage,
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.2,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.001,
              ),
              Container(
                color: Colors.blue.shade200,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.01,
                    horizontal: screenWidth * 0.025,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Text(
                    'Ekal Attendence App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.035,
                      decorationStyle: TextDecorationStyle.wavy,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Container(
                alignment: Alignment.center,
                color: Colors.white70,
                height: screenHeight * 0.4,
                width: screenWidth * 0.9,
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                padding: EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    Card(
                      elevation: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade100,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.02,
                        ),
                        margin: EdgeInsets.all(screenWidth * 0.02),
                        child: TextField(
                          maxLength: 10,
                          decoration: InputDecoration(
                              labelText: 'Mobile Number/मोबाइल नंबर: '),
                          controller: _userPhoneNumber,
                          keyboardType: TextInputType.number,
                          onSubmitted: (_) {},
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.025,
                    ),
                    ButtonTheme(
                      minWidth: screenWidth * 0.5,
                      height: screenHeight * 0.07,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.5),
                          ),
                        ),
                        onPressed: _signInClicked
                            ? null
                            : () async {
                                _userSignIn(context, _userPhoneNumber);
                              },
                        child: !_signInClicked
                            ? Padding(
                              padding: EdgeInsets.fromLTRB(screenWidth*0.15, screenHeight*0.025, screenWidth*0.15, screenHeight*0.025),
                              child: Text(
                                  'Sign-In',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenHeight * 0.030,
                                    color: Colors.white,
                                  ),
                                ),
                            )
                            : const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.005,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(SignUpScreen.routeName);
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue.shade500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.025,
              ),
              const Text(
                "Developed Under:",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset(
                aurigaCareImage,
                width: screenWidth * 0.75,
                height: screenHeight * 0.075,
              ),
              // SizedBox(
              //   height: screenHeight * 0.12,
              // ),
              Container(
                margin: EdgeInsets.only(
                  // left: screenWidth * 0.45,
                  // right: screenWidth * 0.01,
                  top: screenHeight * 0.0025,
                  bottom: screenHeight * 0.0025,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.025,
                  vertical: screenHeight * 0.01,
                ),
                child: RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "",
                        style: TextStyle(
                          color: Colors.black,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      const WidgetSpan(
                        child: Icon(
                          Icons.ads_click_rounded,
                        ),
                      ),
                      TextSpan(
                        // style: linkText,
                        text: "  --Website Link--",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            var url = "https://ail.auriga.co.in";
                            // ignore: deprecated_member_use
                            if (await canLaunch(url)) {
                              // ignore: deprecated_member_use
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.15,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: screenWidth * 0.45,
                  right: screenWidth * 0.01,
                  top: screenHeight * 0.0025,
                  bottom: screenHeight * 0.0025,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.025,
                  vertical: screenHeight * 0.01,
                ),
                child: RichText(
                  textAlign: TextAlign.right,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Developer: ",
                        style: TextStyle(
                          color: Colors.black,
                          // fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
