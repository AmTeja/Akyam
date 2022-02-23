import 'dart:developer';
import 'package:akyam/services/database.dart';
import 'package:akyam/models/server_response.dart';
import 'package:akyam/views/authpage.dart';
import 'package:akyam/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';
import 'models/user.dart';

SystemTray? _systemTray;
bool hasToken = false;
String? authToken = "";
String? refreshToken = "";
User? user;
Widget page = const AuthPage();
FlutterSecureStorage? storage;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  _systemTray = SystemTray();
  await initSystemTray();

  storage = const FlutterSecureStorage();

  await getPage();

  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitleBarStyle('hidden');
    await windowManager.setSize(const Size(1280, 720));
    await windowManager.setResizable(false);
    await windowManager.center();
    await windowManager.show();
    await windowManager.setSkipTaskbar(false);
  });

  runApp(const MyApp());
}

Future<void> getPage() async {
  try {
    authToken = await storage!.read(key: 'authToken');
    refreshToken = await storage!.read(key: 'refresh_token');

    if (authToken != null && refreshToken != null) {
      Auth.verify(authToken: authToken!, refreshToken: refreshToken!)
          .then((ServerResponse serverResponse) {
        page = Homepage(user: serverResponse.data as User);
      });
    } else {
      page = const AuthPage();
    }
  } catch (e, _) {
    log(_.toString());
  }
}

Future<void> initSystemTray() async {
  String path = 'assets/icon.ico';

  final menu = [
    MenuItem(label: 'Show', onClicked: windowManager.show),
    MenuItem(label: 'Hide', onClicked: windowManager.hide),
    MenuItem(label: 'Exit', onClicked: windowManager.close),
  ];

  // We first init the systray menu and then add the menu entries
  await _systemTray!
      .initSystemTray(title: "Akyam", iconPath: path, toolTip: "Runnin Akyam");

  await _systemTray!.setContextMenu(menu);

  // handle system tray event
  _systemTray!.registerSystemTrayEventHandler((eventName) {
    if (eventName == "leftMouseDown") {
    } else if (eventName == "leftMouseUp") {
      _systemTray!.popUpContextMenu();
    } else if (eventName == "rightMouseDown") {
    } else if (eventName == "rightMouseUp") {
      windowManager.show();
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Akyam",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          iconTheme: const IconThemeData(size: 24)),
      themeMode: ThemeMode.dark,
      home: page,
    );
  }
}
