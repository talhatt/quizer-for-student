import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizer_student/components/gap_filling_screen.dart';
import 'package:quizer_student/components/multiple_choice_screen.dart';
import 'package:quizer_student/components/progress_bar.dart';
import 'package:quizer_student/components/true_false_screen.dart';
import 'package:quizer_student/constants.dart';
import 'package:quizer_student/helper/utility.dart';
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
  PageController _pageViewController = PageController(initialPage: 0);
  int currentQuestionNumber = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _leftTime = widget.totalTime;
  }

  Future<void> saveAndQuit() async {
    List<String> answers = <String>[];
    for (var question in widget.questions) {
      answers.add(question.answer);
    }
    FirebaseFirestore.instance
        .collection('students')
        .doc(widget.student.id)
        .update({
      'studentAnswers': answers,
    }).then((_) {
      Utiliy.customSnackBar(_scaffoldKey, "Sonuçlar kaydedildi.");
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('examManagement')
        .doc(widget.docId)
        .get()
        .then((document) {
      _leftTime = document['leftTime'];
    });
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
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
                  currentQuestionNumber != widget.questions.length
                      ? "Soru " +
                          (currentQuestionNumber + 1).toString() +
                          " / " +
                          widget.questions.length.toString()
                      : "Sınav bitti!",
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PageView.builder(
                    controller: _pageViewController,
                    physics: widget.switchBetweenQuestions
                        ? AlwaysScrollableScrollPhysics()
                        : NeverScrollableScrollPhysics(),
                    itemCount: widget.questions.length + 1,
                    itemBuilder: (context, index) {
                      currentQuestionNumber = index;
                      if (index == widget.questions.length) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                ),
                                itemCount: widget.questions.length,
                                itemBuilder: (BuildContext context, int value) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          2.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              2.5,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          widget.switchBetweenQuestions
                                              ? _pageViewController
                                                  .jumpToPage(value)
                                              : null;
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                (value + 1).toString(),
                                              ),
                                              Icon(widget.questions[value]
                                                          .answer ==
                                                      ""
                                                  ? Icons.close
                                                  : Icons.check),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                saveAndQuit();
                              },
                              child: Text("Kaydet ve çık"),
                            ),
                          ],
                        );
                      } else if (widget.questions[index].questionType ==
                          "multipleChoice") {
                        return MultipleChoiceScreen(
                          question: widget.questions[index],
                          student: widget.student,
                        );
                      } else if (widget.questions[index].questionType ==
                          "trueFalse") {
                        return TrueFalseScreen(
                          question: widget.questions[index],
                          student: widget.student,
                        );
                      } else if (widget.questions[index].questionType ==
                          "gapFilling") {
                        return GapFillingScreen(
                          question: widget.questions[index],
                          student: widget.student,
                        );
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
