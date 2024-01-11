import 'dart:convert';

import 'package:dolanyuk/screen/chat.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dolanyuk/class/jadwal.dart';

class ListJadwal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _JadwalState();
  }
}

class _JadwalState extends State<ListJadwal> {
  List<Jadwal> jadwal = [];
  int _user_id = 0;

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160420056/dolanyuk/getjadwal.php"),
        body: {'user_id': _user_id.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  void reloadJadwal() {
    jadwal.clear();
    bacaData();
  }

  bacaData() {
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var jadwals in json['data']) {
        Jadwal jad = Jadwal.fromJson(jadwals);
        jadwal.add(jad);
      }
      setState(() {});
    });
  }

  Future<int> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    int user_id = prefs.getInt("id") ?? 0;
    return user_id;
  }

  @override
  void initState() {
    super.initState();
    checkUser().then((result) {
      _user_id = result;
      bacaData();
    });
  }

  void cancelJadwal(int $idJadwal) async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160420056/dolanyuk/cancelJadwal.php"),
        body: {
          'idUser': _user_id.toString(),
          'idJadwal': $idJadwal.toString(),
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success Cancel !!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    reloadJadwal();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error')));
      throw Exception('Failed to read API');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            jadwal.isEmpty
                ? _emptyJadwal()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: jadwal.length,
                    itemBuilder: (context, index) {
                      return _jadwalCard(context, jadwal[index]);
                    },
                  ),
            const Divider(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyJadwal() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Jadwal main masih kosong nih',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            'Cari konco main atau bikin jadwal baru aja',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _confirmationCancel(int $idJadwal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin membatalkan?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                cancelJadwal($idJadwal);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              child: Text(
                'Ya, Hapus',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _jadwalCard(BuildContext context, Jadwal jadwal) {
    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: -6,
            blurRadius: 8,
            offset: Offset(8, 7),
          ),
        ],
      ),
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(jadwal.image_url),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                jadwal.nama_dolanan,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                'Tanggal: ${jadwal.tanggal}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                'Waktu: ${jadwal.waktu}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Icon(Icons.group, color: Colors.teal),
                  SizedBox(width: 4),
                  ElevatedButton(
                    onPressed: null,
                    child:
                        Text('${jadwal.terisi}/${jadwal.minimal_member} orang'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                'Lokasi: ${jadwal.lokasi}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                'Alamat: ${jadwal.alamat}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListChat(
                                jadwalId: jadwal.id,
                              )),
                    );
                  },
                  child: Text('Party Chat'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _confirmationCancel(jadwal.id);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
