import 'dart:convert';

import 'package:dolanyuk/main.dart';
import 'package:dolanyuk/screen/ubahPassword.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profil extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilState();
  }
}

class _ProfilState extends State<Profil> {
  final _controllerNama = TextEditingController();
  final _controllerUrl = TextEditingController();

  int _user_id = 0;
  String _user_name = '';
  String _user_photo_url = '';
  String _user_email = '';

  Future<Map<String, dynamic>> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    int user_id = prefs.getInt("id") ?? 0;
    String user_name = prefs.getString('name') ?? '';
    String user_email = prefs.getString('email') ?? '';
    String photo_url = prefs.getString('photo_url') ?? '';
    return {
      'id': user_id,
      'name': user_name,
      'email': user_email,
      'photo_url': photo_url
    };
  }

  @override
  void initState() {
    super.initState();
    checkUser().then((value) => setState(
          () {
            _user_id = value['id'];
            _user_name = value['name'];
            _user_email = value['email'];
            _user_photo_url = value['photo_url'];
            _controllerNama.text = _user_name;
            _controllerUrl.text = _user_photo_url;
          },
        ));
  }

  void submit() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160420056/dolanyuk/updateprofile.php"),
        body: {
          'name': _user_name,
          'photo_url': _user_photo_url,
          'user_id': _user_id.toString(),
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("name", _user_name);
        prefs.setString("photo_url", _user_photo_url);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Sukses mengubah Data'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to read API'),
        backgroundColor: Colors.red,
      ));
      throw Exception('Failed to read API');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_user_photo_url),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    onChanged: (v) {
                      setState(() {
                        _user_name = v;
                      });
                    },
                    controller: _controllerNama,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nama Lengkap',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    controller: TextEditingController(text: _user_email),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    onChanged: (v) {
                      setState(() {
                        _user_photo_url = v;
                      });
                    },
                    controller: _controllerUrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Photo Url',
                    ),
                  ),
                  const Divider(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UbahPassword()),
                      );
                    },
                    child: Text('Ubah Password'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_user_name != '' && _user_photo_url != '') {
                        submit();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Name and Photo Url can not be empty'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text('Simpan'),
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
