import 'dart:developer';

import 'package:akyam/main.dart';
import 'package:akyam/models/post.dart';
import 'package:akyam/models/user.dart';
import 'package:akyam/services/database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class FeedPage extends StatefulWidget {
  final User user;

  const FeedPage({Key? key, required this.user}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool isLoading = false;
  ScrollController controller = ScrollController();
  List<Post> posts = [];

  @override
  void initState() {
    print(widget.user);
    setState(() {
      isLoading = true;
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
                controller: controller,
                shrinkWrap: true,
                itemCount: posts.length,
                // cacheExtent: 10,
                separatorBuilder: (context, index) => const BuildSeperator(),
                itemBuilder: (context, index) => BuildPost(post: posts[index])),
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
      log(e.toString());
      log(_.toString());
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
      height: 30,
    );
  }
}

class BuildPost extends StatelessWidget {
  final Post post;

  const BuildPost({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 500,
      color: Colors.blue,
      child: Text(post.desc),
    );
  }
}
