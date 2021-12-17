import 'package:flutter/material.dart';
import 'package:quizer_student/views/get_information_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => GetInformationScreen()));
      },
      child: Container(
        child: Image.asset("assets/logo/quizer.gif"),
      ),
    );
  }
}
