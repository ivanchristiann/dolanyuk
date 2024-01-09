class User {
  int id;
  String name;
  String photo_url;

  User({required this.id, required this.name, required this.photo_url});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['users_id'] as int,
        name: json['name'] as String,
        photo_url: json['photo_url'] as String);
  }
}
