import 'package:dolanyuk/screen/Cari.dart';
import 'package:dolanyuk/screen/Jadwal.dart';
import 'package:dolanyuk/screen/Profil.dart';
import 'package:dolanyuk/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";
int topScore = 0;

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      active_user = result;
      runApp(MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        'jadwal': (context) => Jadwal(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _emoji = "";
  int _currentIndex = 0;
  final List<Widget> _screensBottNav = [Jadwal(), Cari(), Profil()];
  final List<String> _title = ['Jadwal', 'Cari', 'Profil'];

  String _user_id = "";
  int top_poin = 0;

  @override
  void initState() {
    super.initState();
    checkUser().then((value) => setState(
          () {
            _user_id = value;
          },
        ));
  }

  // void doLogout() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.remove("user_id");
  //   main();
  // }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      Jadwal(),
      Cari(),
      Profil(),
    ];

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(_title[_currentIndex])),
      body: _screensBottNav[_currentIndex],
      drawer: myDrawer(context),
      persistentFooterButtons: <Widget>[
        ElevatedButton(
          onPressed: () {},
          child: Icon(Icons.skip_previous),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Icon(Icons.skip_next),
        ),
      ],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        fixedColor: Colors.teal,
        items: [
          BottomNavigationBarItem(
            label: "Jadwal",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Cari",
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: "Profil",
            icon: Icon(Icons.history),
          ),
        ],
      ),
    );
  }

  Drawer myDrawer(BuildContext context) {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text("xyz"),
              accountEmail: Text(_user_id),
              currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150"))),
          ListTile(
              title: new Text("My Basket"),
              leading: new Icon(Icons.shopping_basket),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Jadwal()));
              }),
          ListTile(
              title: Text("Add Recipe"),
              leading: Icon(Icons.receipt),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Cari()));
              }),
          ListTile(
              title: Text("Quiz"),
              leading: Icon(Icons.question_answer),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Profil()));
              }),

          // ListTile(
          //     title: Text("Logout", style: TextStyle(color: Colors.red)),
          //     leading: Icon(Icons.logout),
          //     onTap: () {
          //       doLogout();
          //     }),
        ],
      ),
    );
  }
}
