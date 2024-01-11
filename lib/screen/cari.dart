import 'dart:convert';

import 'package:dolanyuk/class/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dolanyuk/class/jadwal.dart';

class Cari extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _CariState();
  }
}

Future<int> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  int user_id = prefs.getInt("id") ?? 0;
  return user_id;
}

class _CariState extends State<Cari> {
  List<Jadwal> jadwal = [];
  List<Jadwal> _allJadwal = [];
  List<User> members = [];
  int _user_id = 0;
  String _txtCari = '';

  void reloadCari() {
    jadwal.clear();
    _allJadwal.clear();
    bacaData();
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160420056/dolanyuk/getCari.php"),
        body: {'user_id': _user_id.toString(), 'search': _txtCari.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  void joinJadwal(int $idJadwal) async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160420056/dolanyuk/joinJadwal.php"),
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
              title: Text('Success Join !!'),
              content: Text(
                  'Selamat, kamu berhasi join pada jadwal dolanan. Kamu bisa ngobrol bareng teman-teman dolananmu, Terman temanmu menghargai komitmenrmu Untuk hadir dan bermain bersama!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    reloadCari();
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

  Future<String> fetchDataMember(int $idJadwal) async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160420056/dolanyuk/getUserDolanan.php"),
        body: {'jadwalId': $idJadwal.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      List<Jadwal> newJadwalList = [];
      for (var jadwals in json['data']) {
        Jadwal jad = Jadwal.fromJson(jadwals);
        newJadwalList.add(jad);
      }
      setState(() {
        _allJadwal = newJadwalList;
        jadwal = _txtCari.isEmpty
            ? _allJadwal
            : _allJadwal
                .where((jadwal) => jadwal.nama_dolanan
                    .toLowerCase()
                    .contains(_txtCari.toLowerCase()))
                .toList();
      });
    });
  }

  bacaDataMember(int $id_jadwal) async {
    try {
      String data = await fetchDataMember($id_jadwal);
      Map json = jsonDecode(data);
      for (var member in json['data']) {
        User us = User.fromJson(member);
        members.add(us);
      }
      setState(() {});
    } catch (error) {
      print('Error fetching member data: $error');
    }
  }

  Future<int> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    int user_id = prefs.getInt("id") ?? 0;
    return user_id;
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  _initializeData() async {
    try {
      _user_id = await checkUser();
      await bacaData();
      if (jadwal.isNotEmpty) {
        await bacaDataMember(jadwal[0].id);
      }
    } catch (error) {
      print('Error initializing data: $error');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.search),
                  labelText: 'Nama Dolanan mengandung kata:',
                  border: InputBorder.none,
                ),
                onFieldSubmitted: (value) {
                  setState(() {
                    _txtCari = value;
                    bacaData();
                  });
                },
              ),
            ),
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
          jadwal.isEmpty
              ? Text(
                  'Tidak ada jadwal yang tersedia',
                  style: TextStyle(fontSize: 18),
                )
              : Container(),
        ],
      ),
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
                    onPressed: () async {
                      members.clear();
                      await bacaDataMember(jadwal.id);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Column(
                              children: [
                                Text(
                                  'Konco Dolanan',
                                  style: TextStyle(fontSize: 24),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Member bergabung: ${jadwal.terisi}/${jadwal.minimal_member}',
                                  style: TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                            content: SizedBox(
                              width: double.maxFinite,
                              height: 300,
                              child: ListView.builder(
                                itemCount: members.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            members[index].photo_url),
                                      ),
                                      title: Text(members[index].name),
                                    ),
                                  );
                                },
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
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
                    joinJadwal(jadwal.id);
                  },
                  child: Text('Join'),
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
