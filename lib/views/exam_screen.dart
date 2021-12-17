import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizer_student/components/progress_bar.dart';
import 'package:quizer_student/constants.dart';

class ExamScreen extends StatefulWidget {
  ExamScreen({Key? key, required this.student}) : super(key: key);
  final DocumentReference student;

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  bool isBetween = true;
  int _totalTime = 60;
  late int _leftTime;
  late Timer _timer;
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
    _leftTime = _totalTime;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_leftTime == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _leftTime--;
            print("Süre: " + _leftTime.toString());
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isBetween
                      ? TextButton(
                          onPressed: () {},
                          child: Text("Önceki soru"),
                        )
                      : Container(),
                  TextButton(
                    onPressed: () {},
                    child: Text("Sonraki soru"),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FAProgressBar(
                    currentValue: _leftTime,
                    size: 25,
                    maxValue: _totalTime,
                    changeColorValue: 100,
                    changeProgressColor: Colors.pink,
                    backgroundColor: secondaryColor,
                    progressColor: primaryColor,
                    animatedDuration: const Duration(milliseconds: 300),
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.up,
                    displayText: 'dk kaldı.',
                  ),
                ),
              ],
            )));
  }
}
