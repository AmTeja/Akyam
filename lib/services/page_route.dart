import 'package:flutter/material.dart';

class CustomPageRoute {
  static MaterialPageRoute getAkyamRoute(
      {required BuildContext context, required Widget page}) {
    return MaterialPageRoute(builder: ((context) => page));
  }
}
