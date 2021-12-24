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
      required this.totalTime})
      : super(key: key);
  final DocumentReference student;
  final String docId;
  final bool switchBetweenQuestions;
  final bool threeWrongsOneTrue;
  final String questionName;
  final String roomName;
  final int totalTime;

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late int _leftTime;
  late Timer _timer;
  PageController _pageViewController = PageController(initialPage: 0);

  List<Question> questions = [
    Question(
        question: "Aşağıdakilerden hangisi bir prgramlama dili degildir?",
        questionType: "multiple",
        correctAnswer: "option3",
        option1: "Dart",
        option2: "C",
        option3: "Html",
        option4: "Java"),
    Question(
        question: "Aşağıdakilerden hangisi bir prgramlama dilidir?",
        questionType: "multiple",
        correctAnswer: "option4",
        option1: "Html",
        option2: "Css",
        option3: "Xml",
        option4: "C"),
    Question(
      question: "Türkiyenin başkenti _____'dır",
      questionType: "gap_filling",
      correctAnswer: "ankara",
    ),
    Question(
      question: "Aşagıdakilerden hangisi dogrudur?",
      questionType: "true/false",
      correctAnswer: "true",
    ),
  ];
  //Future<void> setExamSettings() async {
  //await FirebaseFirestore.instance
  //.collection('examManagement')
  //.doc(widget.docId)
  //.get()
  //.then((DocumentSnapshot snapshot) {
  //Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //setState(() {
  //switchBetweenQuestions = data['switchBetweenQuestions'];
  //threeWrongsOneTrue = data['threeWrongsOneTrue'];
  //_totalTime = data['totalTime'];
  //roomName = data['roomName'];
  //questionName = data['questionName'];
  //});
  //});
  //}

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
    print(widget.docId);
    print(widget.totalTime.toString());
    print(widget.switchBetweenQuestions.toString());
    print(widget.threeWrongsOneTrue.toString());
    print(widget.questionName);
    print(widget.roomName);
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PageView.builder(
                    controller: _pageViewController,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      // questionType a göre ekran döndüreceğiz
                      return GapFillingScreen(question: questions[index]);
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
