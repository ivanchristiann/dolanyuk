import 'dart:convert';

import 'package:dolanyuk/main.dart';
import 'package:dolanyuk/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dolan Yuk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Register(),
    );
  }
}

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  String _user_email = '';
  String _user_nama = "";
  String _user_password = "";
  String _user_repeat_password = "";

  List<String> emails = [];

  Future<String> fetchData() async {
    final response = await http.get(Uri.parse(
        "https://ubaya.me/flutter/160420056/dolanyuk/checkemail.php"));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      if (jsonData['result'] == 'success') {
        List<Map<String, dynamic>> dataList =
            List<Map<String, dynamic>>.from(jsonData['data']);
        for (var data in dataList) {
          emails.add(data['email']);
        }
        setState(() {});
        return response.body;
      } else {
        throw Exception('Failed to fetch data: ${jsonData['result']}');
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  void submit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160420056/dolanyuk/register.php"),
        body: {
          'name': _user_nama,
          'email': _user_email,
          'password': _user_password,
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Success Registered New Account'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyLogin()),
                    );
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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Sebelum nikmatin fasilitas DolanYuk, bikin akun dulu yuk!',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            const Divider(
              height: 20,
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  onChanged: (v) {
                    setState(() {
                      _user_email = v;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  onChanged: (v) {
                    setState(() {
                      _user_nama = v;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nama Lengkap',
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  onChanged: (v) {
                    setState(() {
                      _user_password = v;
                    });
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  onChanged: (v) {
                    setState(() {
                      _user_repeat_password = v;
                    });
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Repeat Password',
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyLogin()),
                    );
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                  child: Text('Back'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_validateFields() && !_isEmailExist()) {
                      submit();
                    }
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _validateFields() {
    if (_user_email.isEmpty ||
        _user_nama.isEmpty ||
        _user_password.isEmpty ||
        _user_repeat_password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all field.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    } else if (_user_password != _user_repeat_password) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password and Repeat Password must be same.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  bool _isEmailExist() {
    if (emails.contains(_user_email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email has been registered. Please use another email.'),
          backgroundColor: Colors.red,
        ),
      );
      return true;
    }
    return false;
  }
}
