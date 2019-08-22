import 'package:flutter/material.dart';
import 'package:kevin_app/activity/contactActivity.dart';

import 'activity/ContactList.dart';
import 'activity/contactActivity2.dart';
import 'activity/contactDetails.dart';
import 'activity/contactEdit.dart';

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
      home: ContactActivity2(),
    );
  }
}
