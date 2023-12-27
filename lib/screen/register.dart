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
  String _user_id = '';
  String _user_password = "";

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
                    setState(() {});
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
                    setState(() {});
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
                    setState(() {});
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
                    setState(() {});
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ulangi Password',
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
                    // Handle sign up button press
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
}
