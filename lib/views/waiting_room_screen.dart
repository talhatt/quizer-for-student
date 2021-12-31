import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizer_student/components/custom_app_bar.dart';
import 'package:quizer_student/constants.dart';
import 'package:quizer_student/models/question/question.dart';
import 'package:quizer_student/views/exam_screen.dart';

class WaitingRoomScreen extends StatefulWidget {
  const WaitingRoomScreen(
      {Key? key,
      required this.docId,
      required this.querySnapshot,
      required this.student})
      : super(key: key);
  final QuerySnapshot querySnapshot;
  final String docId;
  final DocumentReference student;

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  String userName = "";
  String userSurname = "";
  String userSchool = "";
  String userId = "";
  List<Question> questions = <Question>[];
  bool isExamStarted = false;
  late bool switchBetweenQuestions;
  late bool threeWrongsOneTrue;
  late String questionName;
  late String roomName;
  late int totalTime;

  @override
  void initState() {
    getExamInfo();
    getUserInfo();
    findQuestions();
    super.initState();
  }

  getExamInfo() {
    FirebaseFirestore.instance
        .collection('examManagement')
        .doc(widget.docId)
        .get()
        .then((document) {
      questionName = document['questionName'];
      totalTime = document['totalTime'];
      isExamStarted = document['examIsStarted'];
      switchBetweenQuestions = document['switchBetweenQuestions'];
      threeWrongsOneTrue = document['threeWrongsOneTrue'];
      roomName = document['roomName'];
    });
  }

  findQuestions() {
    FirebaseFirestore.instance.collection('questions').get().then((snapshot) {
      snapshot.docs.forEach((document) {
        if (document.data()['name'] == questionName &&
            document.data()['userId'] == userId) {
          getQuestions(document.id.toString());
          return;
        }
      });
    });
  }

  getQuestions(String documentId) {
    FirebaseFirestore.instance
        .collection('questions')
        .doc(documentId)
        .collection('question')
        .get()
        .then((docs) {
      for (var i = 0; i < docs.docs.length; i++) {
        if (docs.docs[i]['questionType'] == "multipleChoice") {
          questions.add(Question.multiple(
            question: docs.docs[i]['question'],
            correctAnswer: docs.docs[i]['correctAnswer'],
            option1: docs.docs[i]['option1'],
            option2: docs.docs[i]['option2'],
            option3: docs.docs[i]['option3'],
            option4: docs.docs[i]['option4'],
          ));
        } else if (docs.docs[i]['questionType'] == "gapFilling") {
          questions.add(Question.gapFilling(
            question: docs.docs[i]['question'],
            correctAnswer: docs.docs[i]['correctAnswer'],
          ));
        } else if (docs.docs[i]['questionType'] == "trueFalse") {
          questions.add(Question.trueFalse(
            question: docs.docs[i]['question'],
            correctAnswer: docs.docs[i]['correctAnswer'],
          ));
        }
      }
    });
  }

  getUserInfo() {
    FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: widget.querySnapshot.docs[0]['userId'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        userName = querySnapshot.docs[0]['userName'];
        userSurname = querySnapshot.docs[0]['userSurname'];
        userSchool = querySnapshot.docs[0]['userSchool'];
        userId = querySnapshot.docs[0]['userId'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Is exam started ? Check it
    FirebaseFirestore.instance
        .collection('examManagement')
        .doc(widget.docId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        isExamStarted = documentSnapshot['examIsStarted'];
      });
    });

    if (isExamStarted) {
      return ExamScreen(
        student: widget.student,
        docId: widget.docId,
        switchBetweenQuestions: switchBetweenQuestions,
        threeWrongsOneTrue: threeWrongsOneTrue,
        totalTime: totalTime,
        roomName: roomName,
        questionName: questionName,
        questions: questions,
      );
    } else {
      return SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(userSchool),
                Text("$userName $userSurname"),
                Text(
                    "Öğretmen tarafından sınavın başlatılması bekleniyor... \nLütfen bekleyin."),
                CircularProgressIndicator(color: primaryColor),
              ],
            ),
          ),
        ),
      );
    }
  }
}
