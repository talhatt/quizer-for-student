import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizer_student/constants.dart';
import 'package:quizer_student/models/question/question.dart';

class TrueFalseScreen extends StatefulWidget {
  const TrueFalseScreen({
    Key? key,
    required this.question,
    required this.student,
  }) : super(key: key);
  final Question question;
  final DocumentReference student;

  @override
  State<TrueFalseScreen> createState() => _TrueFalseScreenState();
}

class _TrueFalseScreenState extends State<TrueFalseScreen> {
  List<bool> isSelected = [false, false];
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
      if (widget.question.answer == "true") {
        isSelected[0] = true;
      } else {
        isSelected[1] = true;
      }
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.check, color: Colors.white),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        "Doğru",
                        style: TextStyle(
                            color: isSelected[0] ? Colors.black : Colors.white),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        "Yanlış",
                        style: TextStyle(
                            color: isSelected[1] ? Colors.black : Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
              isSelected: isSelected,
              onPressed: (int index) {
                setState(() {
                  if (widget.question.answer == "") {
                    (index == 0)
                        ? widget.question.answer = "true"
                        : widget.question.answer = "false";
                    isSelected[index] = !isSelected[index];
                    if (widget.question.answer ==
                        widget.question.correctAnswer) {
                      incrementCounter();
                    }
                  } else {
                    if (widget.question.answer ==
                        widget.question.correctAnswer) {
                      decrementCounter();
                      if (index == 0 && widget.question.answer == "true") {
                        isSelected = [false, false];
                        widget.question.answer = "";
                      } else if (index == 1 &&
                          widget.question.answer == "false") {
                        isSelected = [false, false];
                        widget.question.answer = "";
                      } else {
                        (index == 0)
                            ? widget.question.answer = "true"
                            : widget.question.answer = "false";
                        isSelected = [false, false];
                        isSelected[index] = !isSelected[index];
                      }
                    } else {
                      if (index == 0 && widget.question.answer == "true") {
                        isSelected = [false, false];
                        widget.question.answer = "";
                      } else if (index == 1 &&
                          widget.question.answer == "false") {
                        isSelected = [false, false];
                        widget.question.answer = "";
                      } else {
                        (index == 0)
                            ? widget.question.answer = "true"
                            : widget.question.answer = "false";
                        isSelected = [false, false];
                        isSelected[index] = !isSelected[index];
                        incrementCounter();
                      }
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
}
