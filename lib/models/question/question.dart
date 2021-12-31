import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  late String question;
  late String questionType;
  late String correctAnswer;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  String answer = "";
  Question({
    required this.question,
    required this.questionType,
    required this.correctAnswer,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
  });

  Question.multiple({
    required this.question,
    required this.correctAnswer,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
  }) {
    questionType = "multipleChoice";
  }
  Question.gapFilling({
    required this.question,
    required this.correctAnswer,
  }) {
    questionType = "gapFilling";
  }
  Question.trueFalse({
    required this.question,
    required this.correctAnswer,
  }) {
    questionType = "trueFalse";
  }
}
