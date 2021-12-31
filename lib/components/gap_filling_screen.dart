import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizer_student/constants.dart';
import 'package:quizer_student/models/question/question.dart';

class GapFillingScreen extends StatefulWidget {
  const GapFillingScreen({
    Key? key,
    required this.question,
    required this.student,
  }) : super(key: key);
  final Question question;
  final DocumentReference student;

  @override
  State<GapFillingScreen> createState() => _GapFillingScreenState();
}

class _GapFillingScreenState extends State<GapFillingScreen> {
  String oldAnswer = "";
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    oldAnswer = widget.question.answer;
    controller.text = widget.question.answer;
  }

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

  checkAnswer() {
    widget.question.answer = controller.text.toLowerCase();
    if (oldAnswer != widget.question.answer) {
      if (widget.question.answer ==
          widget.question.correctAnswer.toLowerCase()) {
        incrementCounter();
        oldAnswer = widget.question.answer;
      } else if (oldAnswer == widget.question.correctAnswer.toLowerCase()) {
        decrementCounter();
        oldAnswer = widget.question.answer;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
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
            padding: const EdgeInsets.all(8.0),
          ),
          TextField(
            onSubmitted: checkAnswer(),
            controller: controller,
            //onChanged: (value) {
            //widget.question.answer = value.toLowerCase();
            //},
            decoration: InputDecoration(
              hintText: "Cevabınız?",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
