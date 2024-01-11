class Chat {
  int chat_id;
  int jadwal_id;
  int user_id;
  String message;
  String name;
  String urlPhoto;

  Chat(
      {required this.chat_id,
      required this.jadwal_id,
      required this.user_id,
      required this.message,
      required this.name,
      required this.urlPhoto});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
        chat_id: json['chat_id'] as int,
        jadwal_id: json['jadwal_id'] as int,
        user_id: json['user_id'] as int,
        message: json['message'] as String,
        name: json['userName'] as String,
        urlPhoto: json['photo_url'] as String);
  }
}
