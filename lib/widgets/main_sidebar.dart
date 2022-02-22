import 'package:akyam/models/user.dart';
import 'package:flutter/material.dart';

class HomeSidebar extends StatefulWidget {
  final User user;

  const HomeSidebar({Key? key, required this.user}) : super(key: key);

  @override
  _HomeSidebarState createState() => _HomeSidebarState();
}

class _HomeSidebarState extends State<HomeSidebar> {
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    return !expanded ? getCollapsedBar() : getExpandedBar();
  }

  getCollapsedBar() {
    return Container(
      width: 40,
    );
  }

  getExpandedBar() {
    return Container(
      width: 200,
    );
  }
}
