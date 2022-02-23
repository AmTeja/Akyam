import 'package:akyam/models/comment.dart';

enum PostType { postVideo, postImage }

class Post {
  final String id;
  final String uid;
  final PostType type;
  final String url;
  final String desc;
  final List<String> likes;
  final String createdTime;
  // final List<Comment> comments;

  Post(
      {required this.id,
      required this.uid,
      required this.type,
      required this.url,
      required this.likes,
      required this.createdTime,
      required this.desc});

  factory Post.fromMap(Map json) => Post(
      id: json['_id'],
      uid: json['userId'],
      type: PostType.values[int.parse(json['contentType'].toString())],
      url: json['url'],
      desc: json['desc'],
      likes: List.from(
          (json['likes'] as List<dynamic>).map((like) => like.toString())),
      createdTime: json['createdAt']);
}
