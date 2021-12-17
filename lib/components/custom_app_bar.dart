import 'package:flutter/material.dart';

import '../constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 5,
      shadowColor: primaryColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(appName, style: TextStyle(color: primaryColor)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
