class Jadwal {
  int id;
  int dolanan_id;
  String tanggal;
  String waktu;
  String lokasi;
  String alamat;

  Jadwal({
    required this.id,
    required this.dolanan_id,
    required this.tanggal,
    required this.waktu,
    required this.lokasi,
    required this.alamat,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(
      id: json['id'] as int,
      dolanan_id: json['dolanan_id'] as int,
      tanggal: json['tanggal'] as String,
      waktu: json['waktu'] as String,
      lokasi: json['lokasi'] as String,
      alamat: json['alamat'] as String,
    );
  }
}
