import 'package:akyam/models/user.dart';
import 'package:akyam/services/database.dart';
import 'package:akyam/widgets/main_sidebar.dart';
import 'package:akyam/widgets/titlebar.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  final User user;

  const Homepage({Key? key, required this.user}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool showSidebar = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF343A40),
      body: Column(
        children: [
          const AkyamTitleBar(),
          Expanded(
            child: HomeSidebar(
              user: widget.user,
            ),
          )
        ],
      ),
    );
  }
}
