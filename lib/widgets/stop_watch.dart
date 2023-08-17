import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StopWatch extends StatefulWidget {
  final Function(bool, int) classDurationTime;

  StopWatch(
    this.classDurationTime,
  );

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  bool isSDbtnActive = false;
  Future<void> _checkNullStopWatch(BuildContext context) async {
    int hrs = countdownDuration.inHours;
    int min = countdownDuration.inMinutes;

    if (hrs <= 0 && min <= 0) {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('InValid Duration!'),
          content: Text('Please enter a Valid Duration of Class...'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
            ),
          ],
        ),
      );
    } else {
      Navigator.of(context).pop(false);
    }
  }

  Future<void> selctionOfClassDuration(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Select Class Duration'),
        content: buildTimePicker(context),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Ok'),
            onPressed: () {
              // Navigator.of(ctx).pop(false);
              _checkNullStopWatch(context);

              // setState(() {
              //   int minCnt = ((countdownDuration.inHours*60)+countdownDuration.inMinutes);
              //   Future.delayed(Duration(minutes: minCnt), () {
              //     setState(() {
              //       widget.classDurationTime(true, minCnt);
              //     });
              //   });
              // });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _checkForResetTimer(BuildContext context, String titleText,
      String contextText, VoidCallback stopTimerFunc) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${titleText}'),
        content: Text('${contextText}'),
        actions: <Widget>[
          ElevatedButton(
            child: Text('NO'),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          ElevatedButton(
            child: Text('Yes'),
            onPressed: () {
              stopTimerFunc();
              Navigator.of(ctx).pop(false);

              isSDbtnActive = false;
            },
          ),
        ],
      ),
    );
  }

  Duration userDuration = Duration();

  static var countdownDuration = Duration(
    hours: 0,
    minutes: 1,
    seconds: 0,
  );

  Duration duration = Duration();
  Timer? timer;

  bool isCountDown = true;

  @override
  void initState() {
    super.initState();

    // startTimer();
    reset();
  }

  void reset() {
    if (isCountDown) {
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = Duration());
    }
  }

  void addTime() {
    final addSeconds = isCountDown ? -1 : 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;

      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }

    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Container(
      child: buildTime(context),
    );
  }

  Widget buildTime(BuildContext ctx) {
    var screenHeight = MediaQuery.of(ctx).size.height;
    var screenWidtht = MediaQuery.of(ctx).size.width;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.025,
        ),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              child: Text('Select Duration'),
              onPressed: !isSDbtnActive
                  ? () {
                      selctionOfClassDuration(ctx);
                    }
                  : null,
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: screenHeight * 0.02,
              ),
              child: Text(
                'Time Left:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildTimeCard(
                  time: hours,
                  header: 'Hrs',
                  ctx: ctx,
                ),
                SizedBox(
                  width: screenWidtht * 0.03,
                ),
                buildTimeCard(
                  time: minutes,
                  header: 'Min',
                  ctx: ctx,
                ),
                SizedBox(
                  width: screenWidtht * 0.03,
                ),
                buildTimeCard(
                  time: seconds,
                  header: 'Sec',
                  ctx: ctx,
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            buildButtons(ctx),
          ],
        ),
      ),
    );
  }

  Widget buildButtons(BuildContext ctx) {
    var screenHeight = MediaQuery.of(ctx).size.height;
    var screenWidth = MediaQuery.of(ctx).size.width;

    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = duration.inSeconds == 0;

    return isRunning
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  if (isRunning) {
                    stopTimer(resets: false);

                    setState(() {
                      // Do something here with double.infinity or any other operation
                      // that you intended to perform
                      // Example: int minCnt = 5; // Replace with your logic
                      // widget.classDurationTime(true, minCnt);
                    });
                  }
                },
                child: Text(
                  'STOP',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                ),
              ),
              SizedBox(
                width: screenWidth * 0.01,
              ),
              ElevatedButton(
                onPressed: () {
                  _checkForResetTimer(
                    context,
                    'Request For Reset!',
                    'Are you sure you want to Reset Timer?',
                    stopTimer,
                  );
                },
                child: Text(
                  'RESET',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                ),
              ),
            ],
          )
        : ElevatedButton(
            onPressed: () {
              startTimer();

              setState(() {
                isSDbtnActive = true;
                int minCnt = ((countdownDuration.inHours * 60) +
                    countdownDuration.inMinutes);
                Future.delayed(Duration(minutes: minCnt), () {
                  setState(() {
                    widget.classDurationTime(true, minCnt);
                  });
                });
              });
            },
            child: Text(
              'Start Timer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              onPrimary: Colors.white,
            ),
          );
  }

  Widget buildTimeCard({
    required String time,
    required String header,
    required BuildContext ctx,
  }) {
    var screenHeight = MediaQuery.of(ctx).size.height;
    var screenWidth = MediaQuery.of(ctx).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.005,
            horizontal: screenWidth * 0.01,
          ),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            '${time}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: screenHeight * 0.07,
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.008,
        ),
        Text(header),
      ],
    );
  }

  Widget buildTimePicker(BuildContext ctx) {
    var screenHeight = MediaQuery.of(ctx).size.height;
    var screenWidth = MediaQuery.of(ctx).size.width;

    return SizedBox(
      height: screenHeight * 0.4,
      width: screenWidth,
      child: CupertinoTimerPicker(
        initialTimerDuration: countdownDuration,
        mode: CupertinoTimerPickerMode.hms,
        minuteInterval: 1,
        secondInterval: 30,
        onTimerDurationChanged: (currDuration) => setState(() {
          countdownDuration = currDuration;
          reset();
        }),
      ),
    );
  }
}
