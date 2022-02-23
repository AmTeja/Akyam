class Comment {
  final String parentId;
  final String id;
  final String content;
  final List<String> likes;

  Comment(
      {required this.parentId,
      required this.id,
      required this.content,
      required this.likes});
}
