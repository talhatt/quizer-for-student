import 'package:flutter/material.dart';
import 'package:quizer_student/constants.dart';
import 'package:quizer_student/models/question/question.dart';

class TrueFalseScreen extends StatefulWidget {
  const TrueFalseScreen({Key? key, required this.question}) : super(key: key);
  final Question question;

  @override
  State<TrueFalseScreen> createState() => _TrueFalseScreenState();
}

class _TrueFalseScreenState extends State<TrueFalseScreen> {
  List<bool> isSelected = [false, false];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
                isSelected = [false, false];
                isSelected[index] = !isSelected[index];
                (index == 0)
                    ? widget.question.correctAnswer = "true"
                    : widget.question.correctAnswer = "false";
              });
            },
          ),
        ),
      ],
    );
  }
}
