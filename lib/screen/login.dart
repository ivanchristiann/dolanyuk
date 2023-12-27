import 'dart:convert';

import 'package:dolanyuk/main.dart';
import 'package:dolanyuk/screen/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dolan Yuk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  String _user_id = '';
  String _user_password = "";
  String error_login = "";

  // void doLogin() async {
  //   final response = await http.post(
  //       Uri.parse("https://ubaya.me/flutter/160420056/login.php"),
  //       body: {'user_id': _user_id, 'user_password': _user_password});
  //   if (response.statusCode == 200) {
  //     Map json = jsonDecode(response.body);
  //     if (json['result'] == 'success') {
  //       final prefs = await SharedPreferences.getInstance();
  //       prefs.setString("user_id", _user_id);
  //       prefs.setString("user_name", json['user_name']);
  //       main();
  //     } else {
  //       setState(() {
  //         error_login = "Incorrect user or password";
  //       });
  //     }
  //   } else {
  //     throw Exception('Failed to read API');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'DolanYuk',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (v) {
                  setState(() {});
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (v) {
                  setState(() {});
                },
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyRegister()),
                    );
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                  child: Text('Sign Up'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  child: Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
