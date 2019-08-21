import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:kevin_app/components/contact_form.dart';

import './ContactList.dart';

class ContactActivity2 extends StatefulWidget {
  @override
  ContactActivityState2 createState() => ContactActivityState2();
}

class ContactActivityState2 extends State<ContactActivity2> {
  String _image = "";
  final StreamController<String> _streamController = StreamController<String>();

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Contacts',
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
        home: Scaffold(
          appBar: AppBar(
            title: Text('My Contacts'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    'Add your contacts',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                StreamBuilder<String>(
                  stream: _streamController.stream,
                  initialData: _image,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return Container(
                        height: 150,
                        child: snapshot.data == ""
                            ? Image.asset('assets/person.png')
                            : Image.file(File(snapshot.data)));
                  },
                ),
                // Container(height: 100, child: Image.asset('assets/person.png')),
                ContactForm(streamController: _streamController),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.contacts),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactList()),
              );
            },
          ),
        ));
  }
}
