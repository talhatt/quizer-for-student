import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizer_student/components/custom_app_bar.dart';
import 'package:quizer_student/constants.dart';
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
  bool isExamStarted = false;
  @override
  //void initState() {
  //checkExam();
  //super.initState();
  //}

  //checkExam() {
  //setState(() {
  //isExamStarted = widget.querySnapshot.docs[0]['examIsStarted'];
  //});
  //}

  @override
  Widget build(BuildContext context) {
    //StreamSubscription exam = FirebaseFirestore.instance
    //.collection('examManagement')
    //.doc(widget.docId)
    //.snapshots()
    //.listen((snapshot) {
    //Map<String, dynamic>? examManagement = snapshot.data();
    //print(examManagement!['examIsStarted']);
    //if (examManagement['examIsStarted']) {
    //setState(() {
    //examIsStarted = true;
    //});
    //print("exam: $examIsStarted");
    //} else {
    //setState(() {
    //examIsStarted = false;
    //});
    //}
    //});

    // check it exam is started?
    //WidgetsBinding.instance!.addPostFrameCallback((_) {
    //if (widget.querySnapshot.docs[0]['examIsStarted']) {
    ////exam.cancel();
    //Navigator.push(
    //context,
    //MaterialPageRoute(
    //builder: (context) => ExamScreen(student: widget.student)));
    //}
    //});

    // get teacher information
    FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: widget.querySnapshot.docs[0]['userId'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        userName = querySnapshot.docs[0]['userName'];
        userSurname = querySnapshot.docs[0]['userSurname'];
        userSchool = querySnapshot.docs[0]['userSchool'];
      });
    });
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
      return ExamScreen(student: widget.student);
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
