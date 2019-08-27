import 'package:flutter/material.dart';

import 'activity/ContactList.dart';
import 'package:kevin_app/activity/contactActivity.dart';
import 'package:kevin_app/activity/contactDetails.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Contacts',
      routes: {
        '/contactList': (context) => ContactList(),
        '/contactDetails': (context) => ContactDetails(),
        // '/contactEdit': (context) => ContactEdit()
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: DefaultTabController(length: 2, child: Home()),
      home: _Home(),
    );
  }
}

class _Home extends StatefulWidget {
  final List<Widget> _activities = [ContactActivity(), ContactList()];
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  int _currentIndex = 0;
  // This widget is the root of your application.

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget._activities[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), title: Text('home')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.contacts), title: Text('contactList')),
            ]));
  }
}
