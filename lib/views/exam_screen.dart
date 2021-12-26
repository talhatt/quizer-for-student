import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizer_student/components/gap_filling_screen.dart';
import 'package:quizer_student/components/multiple_choice_screen.dart';
import 'package:quizer_student/components/progress_bar.dart';
import 'package:quizer_student/components/true_false_screen.dart';
import 'package:quizer_student/constants.dart';
import 'package:quizer_student/models/question/question.dart';

class ExamScreen extends StatefulWidget {
  ExamScreen(
      {Key? key,
      required this.student,
      required this.docId,
      required this.switchBetweenQuestions,
      required this.threeWrongsOneTrue,
      required this.questionName,
      required this.roomName,
      required this.totalTime,
      required this.questions})
      : super(key: key);
  final DocumentReference student;
  final String docId;
  final bool switchBetweenQuestions;
  final bool threeWrongsOneTrue;
  final String questionName;
  final String roomName;
  final int totalTime;
  final List<Question> questions;

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late int _leftTime;
  late Timer _timer;
  PageController _pageViewController = PageController(initialPage: 0);
  int currentQuestionNumber = 0;

  void startTimer() {
    _leftTime = widget.totalTime;
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
  void initState() {
    startTimer();
    super.initState();
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
              widget.switchBetweenQuestions
                  ? TextButton(
                      onPressed: () {
                        _pageViewController.previousPage(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.easeIn);
                      },
                      child: Text("Önceki soru"),
                    )
                  : Container(),
              TextButton(
                onPressed: () {
                  _pageViewController.nextPage(
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.easeIn);
                },
                child: Text("Sonraki soru"),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FAProgressBar(
                currentValue: _leftTime,
                size: 25,
                maxValue: widget.totalTime,
                changeColorValue: 100,
                changeProgressColor: primaryColor,
                backgroundColor: secondaryColor,
                progressColor: Colors.red,
                animatedDuration: const Duration(milliseconds: 300),
                direction: Axis.horizontal,
                verticalDirection: VerticalDirection.up,
                displayText: 'dk kaldı.',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Soru ",
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  currentQuestionNumber.toString() +
                      "/" +
                      widget.questions.length.toString(),
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PageView.builder(
                    controller: _pageViewController,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.questions.length,
                    itemBuilder: (context, index) {
                      currentQuestionNumber = index + 1;
                      // questionType a göre ekran döndüreceğiz
                      if (widget.questions[index].questionType ==
                          "multipleChoice") {
                        return MultipleChoiceScreen(
                            question: widget.questions[index]);
                      } else if (widget.questions[index].questionType ==
                          "trueFalse") {
                        return TrueFalseScreen(
                            question: widget.questions[index]);
                      } else if (widget.questions[index].questionType ==
                          "gapFilling") {
                        return GapFillingScreen(
                            question: widget.questions[index]);
                      } else {
                        return Text("Hata!");
                      }
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.roomName),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(widget.questionName),
            ),
          ],
        ),
      ),
    );
  }
}
