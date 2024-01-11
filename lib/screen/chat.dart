import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dolanyuk/class/chat.dart';

class ListChat extends StatefulWidget {
  int jadwalId;
  ListChat({super.key, required this.jadwalId});
  @override
  State<StatefulWidget> createState() {
    return _ChatState();
  }
}

class _ChatState extends State<ListChat> {
  List<Chat> chat = [];

  final _controllerChat = TextEditingController();

  String chatUser = '';
  int _user_id = 0;

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160420056/dolanyuk/getchat.php"),
        body: {'jadwal_id': widget.jadwalId.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  void reloadChat() {
    chat.clear();
    bacaData();
  }

  Future<int> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    int user_id = prefs.getInt("id") ?? 0;
    return user_id;
  }

  void newChat() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160420056/dolanyuk/newChat.php"),
        body: {
          'jadwal_id': widget.jadwalId.toString(),
          'user_id': _user_id.toString(),
          'message': _controllerChat.text,
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        reloadChat();
        _controllerChat.text = "";
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error')));
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

  void initState() {
    super.initState();
    _initializeData();
  }

  _initializeData() async {
    try {
      _user_id = await checkUser();
      await bacaData();
    } catch (error) {
      print('Error initializing data: $error');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Party Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) {
                      setState(() {
                        chatUser = v;
                      });
                    },
                    controller: _controllerChat,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tulis Chat',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    newChat();
                  },
                  child: Text('Kirim'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyChat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Hello Chat',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _chatCard(BuildContext context, Chat chat) {
    bool checkName = chat.user_id.toString() == this._user_id.toString();
    return Container(
      margin: EdgeInsets.fromLTRB(12.0, 3.0, 12.0, 3.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              checkName ? 'You' : chat.name.toString(),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 1.0),
            Text(
              chat.message.toString(),
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.left,
            ),
          ]),
        ),
      ),
    );
  }
}
