import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizer_student/constants.dart';
import 'package:quizer_student/models/question/question.dart';

class MultipleChoiceScreen extends StatefulWidget {
  MultipleChoiceScreen({
    Key? key,
    required this.question,
    required this.student,
  }) : super(key: key);
  final Question question;
  final DocumentReference student;

  @override
  State<MultipleChoiceScreen> createState() => _MultipleChoiceScreenState();
}

class _MultipleChoiceScreenState extends State<MultipleChoiceScreen> {
  List<bool> isSelected = [false, false, false, false];
  incrementCounter() {
    FirebaseFirestore.instance
        .collection('students')
        .doc(widget.student.id)
        .update({'correctAnswerCounter': FieldValue.increment(1)});
  }

  decrementCounter() {
    FirebaseFirestore.instance
        .collection('students')
        .doc(widget.student.id)
        .update({'correctAnswerCounter': FieldValue.increment(-1)});
  }

  getUserAnswer() {
    if (widget.question.answer != "") {
      int answerIndex = int.parse(
          widget.question.answer.substring(widget.question.answer.length - 1));
      isSelected[answerIndex - 1] = true;
    }
  }

  @override
  void initState() {
    getUserAnswer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.question.question),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: secondaryColor,
                  width: 10.0,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(20),
              splashColor: Colors.green,
              direction: Axis.vertical,
              selectedBorderColor: Colors.green,
              fillColor: Colors.green,
              children: [
                Row(
                  children: [
                    buildChoiceContainer("A"),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.question.option1!,
                          style: TextStyle(
                            color: isSelected[0] ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    buildChoiceContainer("B"),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.question.option2!,
                            style: TextStyle(
                              color:
                                  isSelected[1] ? Colors.black : Colors.white,
                            ),
                          )),
                    )
                  ],
                ),
                Row(
                  children: [
                    buildChoiceContainer("C"),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.question.option3!,
                            style: TextStyle(
                              color:
                                  isSelected[2] ? Colors.black : Colors.white,
                            ),
                          )),
                    )
                  ],
                ),
                Row(
                  children: [
                    buildChoiceContainer("D"),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.question.option4!,
                            style: TextStyle(
                              color:
                                  isSelected[3] ? Colors.black : Colors.white,
                            ),
                          )),
                    )
                  ],
                ),
              ],
              isSelected: isSelected,
              onPressed: (int index) {
                setState(() {
                  if (isSelected[index] == true) {
                    if (("option" + (index + 1).toString()) ==
                        widget.question.correctAnswer) {
                      decrementCounter();
                    }
                    isSelected[index] = false;
                    widget.question.answer = "";
                  } else {
                    for (var i = 0; i < isSelected.length; i++) {
                      if (isSelected[i] == true) {
                        String temp = "option" + (i + 1).toString();
                        if (temp == widget.question.correctAnswer) {
                          decrementCounter();
                        }
                      }
                    }
                    isSelected = [false, false, false, false];
                    isSelected[index] = !isSelected[index];
                    widget.question.answer = "option" + (index + 1).toString();
                    if (widget.question.answer ==
                        widget.question.correctAnswer) {
                      incrementCounter();
                    }
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding buildChoiceContainer(String letter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: secondaryColor,
          border: Border.all(
            color: Colors.black,
            width: 5,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(letter,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
