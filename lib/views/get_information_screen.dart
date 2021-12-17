import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizer_student/components/custom_app_bar.dart';
import 'package:quizer_student/helper/utility.dart';
import 'package:quizer_student/views/waiting_room_screen.dart';

class GetInformationScreen extends StatefulWidget {
  const GetInformationScreen({Key? key}) : super(key: key);

  @override
  State<GetInformationScreen> createState() => _GetInformationScreenState();
}

class _GetInformationScreenState extends State<GetInformationScreen> {
  late TextEditingController _nameController;
  late TextEditingController _surNameController;
  late TextEditingController _numberController;
  late TextEditingController _loginCodeController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _nameController = TextEditingController();
    _surNameController = TextEditingController();
    _numberController = TextEditingController();
    _loginCodeController = TextEditingController();
    super.initState();
  }

  void dispose() {
    _nameController.dispose();
    _surNameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(),
        body: buildSingleChildScrollView(),
      ),
    );
  }

  Center buildSingleChildScrollView() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildText("Adınız"),
            buildTextField(_nameController),
            buildText("Soyadınız"),
            buildTextField(_surNameController),
            buildText("Numaranız"),
            buildTextField(_numberController, isNumber: true),
            buildText("Sınav giriş kodu"),
            buildTextField(_loginCodeController),
            buildButton(),
          ],
        ),
      ),
    );
  }

  Padding buildTextField(TextEditingController controller,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: <TextInputFormatter>[
          isNumber
              ? FilteringTextInputFormatter.digitsOnly
              : FilteringTextInputFormatter.singleLineFormatter,
        ],
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      ),
    );
  }

  Align buildText(String text) =>
      Align(alignment: Alignment.centerLeft, child: Text(text));

  SizedBox buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        child: Text("Giriş"),
        style: ElevatedButton.styleFrom(
          primary: Colors.deepOrange,
        ),
        onPressed: () {
          _login();
        },
      ),
    );
  }

  void _login() {
    if (_nameController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _loginCodeController.text.isEmpty ||
        _numberController.text.isEmpty) {
      Utiliy.customSnackBar(_scaffoldKey, 'Lütfen tüm alanları doldurun!');
      return;
    }
    if (_nameController.text.length > 23 ||
        _surNameController.text.length > 23 ||
        _loginCodeController.text.length > 23 ||
        _numberController.text.length > 23) {
      Utiliy.customSnackBar(
          _scaffoldKey, 'Bilgi alanlarına maximum 23 karakter girebilirsiniz!');
      return;
    }

    FirebaseFirestore.instance
        .collection('examManagement')
        .where('examLoginCode', isEqualTo: _loginCodeController.text)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) {
        if (document['examLoginCode'] == _loginCodeController.text) {
          Utiliy.customSnackBar(_scaffoldKey, 'Sınavda başarılar... :)');
          DocumentReference student =
              FirebaseFirestore.instance.collection('students').doc();
          student.set({
            'studentName': _nameController.text,
            'studentSurName': _surNameController.text,
            'studentNumber': _numberController.text,
            'examLoginCode': _loginCodeController.text,
          });

          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WaitingRoomScreen(
                          querySnapshot: querySnapshot,
                          docId: document.id,
                          student: student)));
            });
          });
        }
      });
    });
    //TODO hata var düzeltimesi gerek
    Utiliy.customSnackBar(_scaffoldKey, 'Sınav giriş kodunuz yanlış!');
  }
}
