import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kevin_app/activity/contactEdit.dart';

import '../contact.dart';

class ContactDetails extends StatelessWidget {
  // final String name;
  // final String phone;
  // final String image;
  final Contact contact;

  ContactDetails({this.contact});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kevin APP',
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
          title: Text(contact.name),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 30, left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.person,
                            color: Colors.blue[300],
                          ),
                        ),
                        Text(
                          contact.name,
                          style: TextStyle(fontSize: 40),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 30, left: 30),
                    child: Row(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(Icons.phone, color: Colors.blue[300])),
                        Text(
                          contact.phone.toString(),
                          style: TextStyle(fontSize: 40),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              contact.image == null
                  ? Container(
                      child: Image.asset('assets/person.png'),
                      height: 100,
                    )
                  : Container(
                      child: Image.file(File(contact.image)),
                      height: 300,
                    )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ContactEdit(
                        contact: contact,
                      )),
            );
          },
        ),
      ),
    );
  }
}
