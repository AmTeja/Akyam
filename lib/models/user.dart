class User {
  final String id;
  final String username;
  final String email;
  final String profileUrl;
  final String coverUrl;
  final List<String> followers;
  final List<String> following;
  final bool isAdmin;

  User({
    required this.username,
    required this.id,
    required this.email,
    required this.profileUrl,
    required this.coverUrl,
    required this.followers,
    required this.following,
    required this.isAdmin,
  });

  factory User.fromMap(Map json) => User(
      id: json["_id"].toString(),
      username: json["username"].toString(),
      email: json["email"].toString(),
      profileUrl: json["profilePicture"].toString(),
      coverUrl: json["coverPicture"].toString(),
      followers: json["followers"] == null
          ? []
          : List.from(
              (json["followers"] as List<dynamic>).map((e) => e.toString())),
      following: json["following"] == null
          ? []
          : List.from(
              (json["following"] as List<dynamic>).map((e) => e.toString())),
      isAdmin: json["isAdmin"] ?? false);
}
