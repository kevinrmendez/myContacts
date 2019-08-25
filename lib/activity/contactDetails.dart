import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kevin_app/activity/contactEdit.dart';

import '../contact.dart';

class ContactDetails extends StatelessWidget {
  final Contact contact;

  ContactDetails({this.contact});

  Widget _buildVerticalLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height:
                      contact.image == null || contact.image == "" ? 150 : 300,
                  child: contact.image == null || contact.image == ""
                      ? Image.asset('assets/person.png')
                      : Image.file(File(contact.image)),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 5, left: 30, top: 30),
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
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5, left: 30),
                  child: Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(Icons.phone, color: Colors.blue[300])),
                      Text(
                        contact.phone.toString(),
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
                contact.email != ""
                    ? Container(
                        margin: EdgeInsets.only(bottom: 5, left: 30),
                        child: Row(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.only(right: 20),
                                child:
                                    Icon(Icons.email, color: Colors.blue[300])),
                            Text(
                              contact.email,
                              style: TextStyle(fontSize: 30),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height:
                      contact.image == null || contact.image == "" ? 150 : 250,
                  child: contact.image == null || contact.image == ""
                      ? Image.asset('assets/person.png')
                      : Image.file(File(contact.image)),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 5, left: 30),
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
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5, left: 30),
                  child: Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(Icons.phone, color: Colors.blue[300])),
                      Text(
                        contact.phone.toString(),
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
                contact.email != ""
                    ? Container(
                        margin: EdgeInsets.only(bottom: 5, left: 30),
                        child: Row(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.only(right: 20),
                                child:
                                    Icon(Icons.email, color: Colors.blue[300])),
                            Text(
                              contact.email,
                              style: TextStyle(fontSize: 30),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            )
          ],
        ),
      ],
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final Contact contact = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Details'),
      ),
      body: Center(
        child: OrientationBuilder(builder: (context, orientation) {
          var orientation = MediaQuery.of(context).orientation;
          return orientation == Orientation.portrait
              ? _buildVerticalLayout()
              : _buildHorizontalLayout();
        }),
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
