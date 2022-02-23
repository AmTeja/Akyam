import 'package:akyam/models/post.dart';
import 'package:flutter/material.dart';

class BuildPost extends StatefulWidget {
  final Post post;

  const BuildPost({Key? key, required this.post}) : super(key: key);

  @override
  State<BuildPost> createState() => _BuildPostState();
}

class _BuildPostState extends State<BuildPost> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 500,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [header(), body(), footer()]),
    );
  }

  Widget header() {
    return Container(
      width: 800,
      height: 40,
      child: ListTile(
        title: Text(widget.post.desc),
      ),
    );
  }

  Widget footer() {
    return Container(
        width: 800,
        height: 40,
        child: Row(
          children: [
            Icon(
              Icons.thumb_up_alt_rounded,
              color: Colors.blue,
            ),
            SizedBox(
              width: 30,
            ),
            Text(widget.post.likes.length.toString())
          ],
        ));
  }

  Widget body() {
    return Expanded(
      child: Container(
        child: Image.network(
          widget.post.url,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
