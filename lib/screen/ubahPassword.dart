import 'dart:convert';

import 'package:dolanyuk/class/dolanan.dart';
import 'package:dolanyuk/main.dart';
import 'package:dolanyuk/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddNewJadwal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dolan Yuk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UbahPassword(),
    );
  }
}

class UbahPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UbahPasswordState();
  }
}

class _UbahPasswordState extends State<UbahPassword> {
  final _controllerNowPassord = TextEditingController();
  final _controllerNewPassword = TextEditingController();
  final _controllerConfirmasiNewPassword = TextEditingController();

  int _user_id = 0;
  String password = "";

  Future<String> fetchData() async {
    final response = await http.get(Uri.parse(
        "https://ubaya.me/flutter/160420056/dolanyuk/getdolanan.php"));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  // bacaData() {
  //   Future<String> data = fetchData();
  //   data.then((value) {
  //     Map json = jsonDecode(value);
  //     for (var dols in json['data']) {
  //       Dolanan dol = Dolanan.fromJson(dols);
  //       dolanan.add(dol);
  //     }
  //     setState(() {});
  //   });
  // }

  Future<int> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    int user_id = prefs.getInt("id") ?? 0;
    return user_id;
  }

  Future<String> passwordNow() async {
    final prefs = await SharedPreferences.getInstance();
    String passwordNow = prefs.getString("password") ?? '';
    return passwordNow;
  }

  void submit() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160420056/dolanyuk/ubahPassword.php"),
        body: {
          'password': _controllerNewPassword.text,
          'user_id': _user_id.toString(),
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("password", _controllerNewPassword.text);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Sukses mengubah Data'),
        ));
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to read API'),
        backgroundColor: Colors.red,
      ));
      throw Exception('Failed to read API');
    }
  }

  @override
  void initState() {
    super.initState();
    // bacaData();
    checkUser().then((result) {
      _user_id = result;
    });
    passwordNow().then((result) {
      password = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubah Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Ubah Passwordmu Sekarang yuk!',
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        onChanged: (v) {
                          setState(() {});
                        },
                        controller: _controllerNowPassord,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password Saat Ini',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    onChanged: (v) {
                      setState(() {});
                    },
                    controller: _controllerNewPassword,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password Baru',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    onChanged: (v) {
                      setState(() {});
                    },
                    controller: _controllerConfirmasiNewPassword,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Konfirmasi Password Baru',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_controllerNewPassword == '' ||
                          _controllerNowPassord == '' ||
                          _controllerConfirmasiNewPassword == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('You must fill all field'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else if (_controllerNewPassword.text !=
                          _controllerConfirmasiNewPassword.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'New Password and ConfNewPassword Must be Same'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else if (_controllerNowPassord.text != this.password) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Password Saat Ini is Wrong'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        submit();
                      }
                    },
                    child: Text('Ubah Password'),
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
