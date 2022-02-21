import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';

class AkyamTitleBar extends StatelessWidget {
  final String? title;
  const AkyamTitleBar({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: Row(children: [
        Expanded(
            child: MoveWindow(
                // child: Center(
                //     child: Text(
                //   title ?? "Aksyam",
                //   style: const TextStyle(color: Colors.white),
                // )),
                )),
        const WindowButtons()
      ]),
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
