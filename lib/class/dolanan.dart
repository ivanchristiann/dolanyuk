class Dolanan {
  final int id;
  final String name;
  final int min_member;

  Dolanan({required this.id, required this.name, required this.min_member});

  factory Dolanan.fromJson(Map<String, dynamic> json) {
    return Dolanan(
      id: json['id'] as int,
      name: json['nama_dolanan'] as String,
      min_member: json['minimal_member'] as int,
    );
  }
}
