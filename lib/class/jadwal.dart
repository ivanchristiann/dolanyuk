class Jadwal {
  int id;
  int dolanan_id;
  String tanggal;
  String waktu;
  String lokasi;
  String alamat;
  String nama_dolanan;
  int minimal_member;
  String image_url;
  int terisi;

  Jadwal(
      {required this.id,
      required this.dolanan_id,
      required this.tanggal,
      required this.waktu,
      required this.lokasi,
      required this.alamat,
      required this.nama_dolanan,
      required this.minimal_member,
      required this.image_url,
      required this.terisi});

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(
        id: json['id'] as int,
        dolanan_id: json['dolanan_id'] as int,
        tanggal: json['tanggal'] as String,
        waktu: json['waktu'] as String,
        lokasi: json['lokasi'] as String,
        alamat: json['alamat'] as String,
        nama_dolanan: json['nama_dolanan'] as String,
        minimal_member: json['minimal_member'] as int,
        image_url: json['image_url'] as String,
        terisi: json['terisi'] as int);
  }
}
