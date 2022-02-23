import 'package:akyam/main.dart';
import 'package:akyam/models/user.dart';
import 'package:akyam/views/content/feedpage.dart';
import 'package:akyam/views/content/profile.dart';
import 'package:akyam/views/content/settings.dart';
import 'package:flutter/material.dart';

class HomeSidebar extends StatefulWidget {
  final User user;

  const HomeSidebar({Key? key, required this.user}) : super(key: key);

  @override
  _HomeSidebarState createState() => _HomeSidebarState();
}

class _HomeSidebarState extends State<HomeSidebar> {
  bool expanded = false;

  PageController pageController = PageController();

  int index = 0;

  List<Icon> sidebarIcons = const [
    Icon(
      Icons.arrow_forward_ios_rounded,
      color: Color(0xFF0e141a),
    ),
    Icon(
      Icons.home_filled,
      color: Color(0xFF0e141a),
    ),
    Icon(
      Icons.person,
      color: Color(0xFF0e141a),
    ),
    Icon(
      Icons.settings,
      color: Color(0xFF0e141a),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        expanded ? getExpandedBar() : getCollapsed(),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(13))),
            child: PageView(
                scrollDirection: Axis.vertical,
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    this.index = index;
                  });
                },
                children: [
                  FeedPage(
                    user: widget.user,
                  ),
                  ProfilePage(),
                  SettingsPage()
                ]),
          ),
        )
      ],
    );
  }

  getCollapsed() {
    return AnimatedContainer(
      width: 50,
      duration: const Duration(milliseconds: 120),
      child: ListView.builder(
          itemCount: sidebarIcons.length,
          itemBuilder: (context, i) => InkWell(
                onTap: () {
                  setState(() {
                    if (i != 0) {
                      index = i - 1;
                      pageController.animateToPage(index,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn);
                    }
                    ;
                  });
                },
                child: BuildCollapsedIcon(
                    icon: sidebarIcons[i], selected: i == index + 1),
              )),
    );
  }

  getExpandedBar() {
    return SizedBox(
      width: 200,
      child: ListView(
        children: [
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.home),
            title: const Text("Home"),
          )
        ],
      ),
    );
  }
}

class BuildCollapsedIcon extends StatelessWidget {
  final bool selected;
  final Icon icon;
  const BuildCollapsedIcon(
      {Key? key, required this.icon, required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          color: selected ? Color(0xFF0e141a).withOpacity(0.3) : null,
          borderRadius: BorderRadius.circular(13)),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      child: icon,
    );
  }
}
