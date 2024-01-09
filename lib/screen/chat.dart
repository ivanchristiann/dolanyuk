import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dolanyuk/class/chat.dart';

class ListChat extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatState();
  }
}

class _ChatState extends State<ListChat> {
  List<Chat> chat = [];

  int jadwalId = 3;

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160420056/dolanyuk/getUserDolanan.php"),
        body: {'jadwalId': jadwalId.toString()});
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
      for (var chats in json['data']) {
        Chat ch = Chat.fromJson(chats);
        chat.add(ch);
      }
      setState(() {});
    });
  }

  // Future<int> checkUser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   int user_id = prefs.getInt("id") ?? 0;
  //   return user_id;
  // }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            chat.isEmpty
                ? _emptyChat()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: chat.length,
                    itemBuilder: (context, index) {
                      return _chatCard(context, chat[index]);
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

  Widget _emptyChat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Hello',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _chatCard(BuildContext context, Chat chat) {
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
                  image: NetworkImage(chat.message),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8)
          ],
        ),
      ),
    );
  }
}
