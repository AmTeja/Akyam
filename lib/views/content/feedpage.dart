import 'dart:developer' as dev;
import 'dart:math';

import 'package:akyam/main.dart';
import 'package:akyam/models/post.dart';
import 'package:akyam/models/user.dart';
import 'package:akyam/services/database.dart';
import 'package:akyam/widgets/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';

class FeedPage extends StatefulWidget {
  final User user;

  const FeedPage({Key? key, required this.user}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool isLoading = false;
  ScrollController scrollController = ScrollController();
  double _extraScrollSpeed = 80;
  List<Post> posts = [];

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    scrollController.addListener(() {
      ScrollDirection scrollDirection =
          scrollController.position.userScrollDirection;
      if (scrollDirection != ScrollDirection.idle) {
        double scrollEnd = scrollController.offset +
            (scrollDirection == ScrollDirection.reverse
                ? _extraScrollSpeed
                : -_extraScrollSpeed);
        scrollEnd = min(scrollController.position.maxScrollExtent,
            max(scrollController.position.minScrollExtent, scrollEnd));
        scrollController.jumpTo(scrollEnd);
      }
    });
    setupPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: ListView.separated(
                controller: scrollController,
                shrinkWrap: true,
                itemCount: posts.length,
                // cacheExtent: 10,
                separatorBuilder: (context, index) => const BuildSeperator(),
                itemBuilder: (context, index) {
                  return BuildPost(post: posts[index]);
                }),
          );
  }

  setupPosts() async {
    try {
      List<String> ids = widget.user.following;
      ids.add("6210b1e8c844415a62d12319");
      posts = List.from(
          ((await PostDB.getPosts(ids: ids, auth_token: widget.user.authToken))!
                  .data as List<dynamic>)
              .map((post) => post as Post));
    } catch (e, _) {
      dev.log(e.toString());
      dev.log(_.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

class BuildSeperator extends StatelessWidget {
  const BuildSeperator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
    );
  }
}
