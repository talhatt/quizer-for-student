import 'package:flutter/material.dart';
import 'package:quizer_student/constants.dart';
import 'package:quizer_student/models/question/question.dart';

class GapFillingScreen extends StatefulWidget {
  const GapFillingScreen({Key? key, required this.question}) : super(key: key);
  final Question question;

  @override
  State<GapFillingScreen> createState() => _GapFillingScreenState();
}

class _GapFillingScreenState extends State<GapFillingScreen> {
  String? correctAnswer;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
          onChanged: (value) {
            setState(() {
              correctAnswer = value;
            });
          },
          //controller: controller,
          decoration: InputDecoration(
            hintMaxLines: 4,
            hintText:
                "Cevaplar arasında virgül bırakınız. Örnek: cevap1,cevap2,cevap3 gibi",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }
}
