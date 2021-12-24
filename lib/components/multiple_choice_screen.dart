import 'package:flutter/material.dart';
import 'package:quizer_student/constants.dart';
import 'package:quizer_student/models/question/question.dart';

class MultipleChoiceScreen extends StatefulWidget {
  MultipleChoiceScreen({Key? key, required this.question}) : super(key: key);
  Question question;

  @override
  State<MultipleChoiceScreen> createState() => _MultipleChoiceScreenState();
}

class _MultipleChoiceScreenState extends State<MultipleChoiceScreen> {
  List<bool> isSelected = [false, false, false, false];
  String? questionText;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  @override
  Widget build(BuildContext context) {
    return Column(
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
                      child: Text(widget.question.option1!),
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
                      child: Text(widget.question.option2!),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  buildChoiceContainer("C"),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.question.option3!),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  buildChoiceContainer("D"),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.question.option4!),
                    ),
                  )
                ],
              ),
            ],
            isSelected: isSelected,
            onPressed: (int index) {
              setState(() {
                isSelected = [false, false, false, false];
                isSelected[index] = !isSelected[index];
                widget.question.correctAnswer =
                    "option" + (index + 1).toString();
              });
            },
          ),
        ),
      ],
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
