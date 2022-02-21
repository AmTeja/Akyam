import 'package:akyam/models/user.dart';
import 'package:akyam/widgets/titlebar.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  final User user;

  const Homepage({Key? key, required this.user}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AkyamTitleBar(),
          Center(
            child: Text("Welcome ${widget.user.username}"),
          ),
        ],
      ),
    );
  }
}
