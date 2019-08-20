import 'dart:io';

import 'package:flutter/material.dart';

class ContactDetails extends StatelessWidget {
  final String name;
  final String phone;
  final String image;

  ContactDetails({this.name, this.phone, this.image});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 40),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Text(
                  phone,
                  style: TextStyle(fontSize: 40),
                ),
              ),
              Container(height: 400, child: Image.file(File(image)))
            ],
          ),
        ),
      ),
    );
  }
}
