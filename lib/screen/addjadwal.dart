import 'dart:convert';

import 'package:dolanyuk/class/dolanan.dart';
import 'package:dolanyuk/main.dart';
import 'package:dolanyuk/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddJadwal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddJadwalState();
  }
}

class _AddJadwalState extends State<AddJadwal> {
  final _controllerDate = TextEditingController();
  final _controllerTime = TextEditingController();
  final _controllerLocation = TextEditingController();
  final _controllerAddress = TextEditingController();
  String _selectedDolanan = 'Pilih Dolanan';
  int dolanan_id = 0;
  int _minMember = 0;
  int _user_id = 0;

  List<Dolanan> dolanan = [];

  Future<String> fetchData() async {
    final response = await http.get(Uri.parse(
        "https://ubaya.me/flutter/160420056/dolanyuk/getdolanan.php"));
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
      for (var dols in json['data']) {
        Dolanan dol = Dolanan.fromJson(dols);
        dolanan.add(dol);
      }
      setState(() {});
    });
  }

  Future<int> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    int user_id = prefs.getInt("id") ?? 0;
    return user_id;
  }

  void submit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160420056/dolanyuk/newjadwal.php"),
        body: {
          'dolanan_id': dolanan_id.toString(),
          'tanggal': _controllerDate.text,
          'waktu': _controllerTime.text,
          'lokasi': _controllerLocation.text,
          'alamat': _controllerAddress.text,
          'user_id': _user_id.toString(),
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Sukses Menambah Data'),
          backgroundColor: Colors.green,
        ));
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error'),
        backgroundColor: Colors.red,
      ));
      throw Exception('Failed to read API');
    }
  }

  @override
  void initState() {
    super.initState();
    bacaData();
    checkUser().then((result) {
      _user_id = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Jadwal"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Bikin jadwal dolananmu yuk!',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            const Divider(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tanggal Dolan',
                      suffixIcon: ElevatedButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2200),
                          ).then((value) {
                            if (value != null) {
                              setState(() {
                                _controllerDate.text =
                                    value.toString().substring(0, 10);
                              });
                            }
                          });
                        },
                        child: Icon(
                          Icons.calendar_today_sharp,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      ),
                    ),
                    controller: _controllerDate,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Jam Dolan',
                      suffixIcon: ElevatedButton(
                        onPressed: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((value) {
                            if (value != null) {
                              setState(() {
                                _controllerTime.text =
                                    '${value.hour}:${value.minute}';
                              });
                            }
                          });
                        },
                        child: Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      ),
                    ),
                    controller: _controllerTime,
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        onChanged: (v) {
                          setState(() {});
                        },
                        controller: _controllerLocation,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Lokasi dolan',
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'contoh: Starbucks, McDonald, Cafe Cozy',
                        style: TextStyle(fontSize: 14.0, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    onChanged: (v) {
                      setState(() {});
                    },
                    controller: _controllerAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Alamat dolan',
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: DropdownButtonFormField<String>(
                        value: _selectedDolanan,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedDolanan = newValue!;
                            if (_selectedDolanan != 'Pilih Dolanan') {
                              _minMember = dolanan
                                  .firstWhere((element) =>
                                      element.name == _selectedDolanan)
                                  .min_member;
                              dolanan_id = dolanan
                                  .firstWhere((element) =>
                                      element.name == _selectedDolanan)
                                  .id;
                            }
                          });
                        },
                        items: [
                          'Pilih Dolanan',
                          ...dolanan.map((Dolanan value) {
                            return value.name;
                          })
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Dolan Utama',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Minimal Member',
                    ),
                    controller: TextEditingController(text: '$_minMember'),
                  ),
                  const Divider(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_controllerDate == '' ||
                          _controllerAddress == '' ||
                          _controllerLocation == '' ||
                          _controllerTime == '' ||
                          _selectedDolanan == 'Pilih Dolanan') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('You must fill all field'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        submit();
                      }
                    },
                    child: Text('Add Jadwal'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
