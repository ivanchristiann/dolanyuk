import 'package:dolanyuk/screen/Cari.dart';
import 'package:dolanyuk/screen/Jadwal.dart';
import 'package:dolanyuk/screen/Profil.dart';
import 'package:dolanyuk/screen/addjadwal.dart';
import 'package:dolanyuk/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

int active_user_id = 0;
String active_user_name = "";
String active_photo_url = "";

Future<Map<String, dynamic>> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  int user_id = prefs.getInt("id") ?? 0;
  String user_name = prefs.getString('name') ?? '';
  String photo_url = prefs.getString('photo_url') ?? '';
  return {'id': user_id, 'name': user_name, 'photo_url': photo_url};
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((result) {
    if (result['id'] == 0)
      runApp(MyLogin());
    else {
      active_user_id = result['id'];
      active_user_name = result['name'];
      active_photo_url = result['photo_url'];
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
        'jadwal': (context) => ListJadwal(),
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
  int _currentIndex = 0;
  final List<Widget> _screensBottNav = [ListJadwal(), Cari(), Profil()];
  final List<String> _title = ['Jadwal', 'Cari', 'Profil'];

  int _user_id = 0;
  String _user_name = '';
  String _user_photo_url = '';

  @override
  void initState() {
    super.initState();
    checkUser().then((value) => setState(
          () {
            _user_id = value['id'] ?? 0;
            _user_name = value['name'] ?? '';
            _user_photo_url = value['photo_url'] ?? '';
          },
        ));
  }

  void doLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    main();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      ListJadwal(),
      Cari(),
      Profil(),
    ];

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(_title[_currentIndex])),
      body: _screensBottNav[_currentIndex],
      drawer: myDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewJadwal()),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.create),
      ),
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
            icon: Icon(Icons.person),
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
              accountName: Text(_user_name),
              accountEmail: Text(_user_id.toString()),
              currentAccountPicture:
                  CircleAvatar(backgroundImage: NetworkImage(_user_photo_url))),
          ListTile(
              title: new Text("My Basket"),
              leading: new Icon(Icons.shopping_basket),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ListJadwal()));
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
          ListTile(
              title: Text("Logout", style: TextStyle(color: Colors.red)),
              leading: Icon(Icons.logout),
              onTap: () {
                doLogout();
              }),
        ],
      ),
    );
  }
}
