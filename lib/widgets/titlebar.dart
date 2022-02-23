import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class AkyamTitleBar extends StatelessWidget {
  final String? title;
  const AkyamTitleBar({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child:
          Row(children: [Expanded(child: MoveWindow()), const WindowButtons()]),
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(),
        MaximizeWindowButton(),
        CloseWindowButton()
      ],
    );
  }
}
