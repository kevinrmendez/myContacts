import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kevin_app/activity/contactEdit.dart';

import '../contact.dart';

class ContactDetails extends StatelessWidget {
  final Contact contact;

  ContactDetails({this.contact});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final Contact contact = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                contact.image == null || contact.image == ""
                    ? Container(
                        child: Image.asset('assets/person.png'),
                        height: 100,
                      )
                    : Container(
                        child: Image.file(File(contact.image)),
                        height: 300,
                      ),
                Container(
                  margin: EdgeInsets.only(bottom: 30, left: 30, top: 30),
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
                Container(
                  margin: EdgeInsets.only(bottom: 30, left: 30),
                  child: Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(Icons.email, color: Colors.blue[300])),
                      Text(
                        contact.email,
                        style: TextStyle(fontSize: 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
          // Navigator.pushNamed(context, '/contactEdit', arguments: contact);
        },
      ),
    );
  }
}
